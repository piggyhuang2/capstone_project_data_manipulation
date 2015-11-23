library(data.table)
library(dplyr)
library(ggplot2)
setwd("C:\\Users\\lhuan\\Documents\\coursera\\capstone")
user <- readRDS("user_file.rds")
tip <- readRDS("tip_file.rds")
checkin <- readRDS("checkin_file.rds")
review <- readRDS("review_file.rds")
biz <- readRDS("biz_file.rds")

subcheck1 <- checkin$checkin_info
subcheck2 <- cbind(checkin$type,checkin$business_id)
colnames(subcheck2) <- c("type","business_id")
newcheckin <- cbind(subcheck1,subcheck2)

# merge with review file
count_checkin <- unlist(row_numbers)
votes <- review$votes
newreview <- cbind(votes,review[,c(2:ncol(review))])

row_numbers <- list()
for(i in c(1:nrow(newcheckin))){
 temp <- length(which(!is.na(newcheckin[i,c(1:168)])))
 row_numbers <- c(row_numbers,temp)
  
}
# unlist row_numbers

# merge with review file
count_checkin <- unlist(row_numbers)
votes <- review$votes
newreview <- cbind(votes,review[,c(2:ncol(review))])
# avg ratings by star
newreview <- data.table(newreview)
newreview <- group_by(newreview, business_id)
df_ratings <- summarise(newreview,mean(stars))
colnames(df_ratings) <- c("business_id","avg_ratings")
df1 <- merge(df_reviews_checkins,df_ratings,by="business_id")
# #positive reviews (#stars >= 3)
sub <- filter(newreview,stars >= 3)
sub <- group_by(sub,business_id)
positive_reviews <- data.frame(table(sub$business_id))
avg_pos_reviews <- summarise(sub,mean(stars))
colnames(positive_reviews) <- c("business_id","num_pos_reviews")
colnames(avg_pos_reviews) <- c("business_id","avg_pos_reviews")
positive_reviews <- merge(positive_reviews,avg_pos_reviews,by="business_id")
df1 <- merge(df1,positive_reviews,by="business_id",all.x=TRUE)
# merge with business data to get price range information
temp_biz <- biz$attributes$"Price Range"
temp_biz <- cbind(biz$business_id,temp_biz)
temp_biz <- data.frame(temp_biz)
colnames(temp_biz) <- c("business_id","price_range")
df1 <- merge(df1,temp_biz,by="business_id",all.x=TRUE)
df1$num_neg_reviews <- df1$num_reviews_c - df1$num_pos_reviews
df1 <- mutate(df1,avg_neg_reviews = (num_reviews_c*avg_ratings - num_pos_reviews*avg_pos_reviews)/num_neg_reviews)
df1$popularity <- df1$num_reviews_c*df1$avg_ratings
# merge with newcheckin datset to get detailed checkin information
df2 <- merge(df1,newcheckin,by="business_id",all.x=TRUE)
df2$type <- NULL
# for exploratory data analysis and statistical tests, use df1; for check-in analysis, use df2;
# Description statistics
# normalize the data before plotting
# replace missing values with column mean
sub_df1 <- df1[,c(2:10)]
sub_df1$price_range <- as.character(sub_df1$price_range)
sub_df1$price_range <- as.integer(sub_df1$price_range)
column_means <- colMeans(sub_df1,na.rm=TRUE)
for(i in c(1:ncol(sub_df1))){
  sub_df1[,i][is.na(sub_df1[,i])] <- column_means[i]
  }

# Plot
library(ggplot2)
p <- ggplot(sub_df1,aes(x=num_checkins,y=popularity))
p+geom_point()
# too much noise in the data and too many data points
# by looking at number of checkins data, calculate average popularity by interval
# for example, calculate average popularity for num_checkins between 0-5 and then for num_checkins between 6-10, etc
tab1 <- filter(df1,num_checkins <= 10)
tab2 <- filter(df1,num_checkins <= 20 & num_checkins > 10)
tab3 <- filter(df1,num_checkins <= 30 & num_checkins > 20)
tab4 <- filter(df1,num_checkins <= 40 & num_checkins > 30)
tab5 <- filter(df1,num_checkins <= 50 & num_checkins > 40)
tab6 <- filter(df1,num_checkins <= 60 & num_checkins > 50)
tab7 <- filter(df1,num_checkins <= 70 & num_checkins > 60)
tab8 <- filter(df1,num_checkins <= 80 & num_checkins > 70)
tab9 <- filter(df1,num_checkins <= 90 & num_checkins > 80)
tab10 <- filter(df1,num_checkins <= 100 & num_checkins > 90)
tab11 <- filter(df1,num_checkins <= 110 & num_checkins > 100)
tab12 <- filter(df1,num_checkins <= 120 & num_checkins > 110)
tab13 <- filter(df1,num_checkins <= 130 & num_checkins > 120)
tab14 <- filter(df1,num_checkins <= 140 & num_checkins > 130)
tab15 <- filter(df1,num_checkins <= 150 & num_checkins > 140)
tab16 <- filter(df1,num_checkins <= 160 & num_checkins > 150)
tab17 <- filter(df1,num_checkins > 160)
col1 <- mean(tab1$popularity,na.rm=TRUE)
col2 <- mean(tab2$popularity,na.rm=TRUE)
col3 <- mean(tab3$popularity,na.rm=TRUE)
col4 <- mean(tab4$popularity,na.rm=TRUE)
col5 <- mean(tab5$popularity,na.rm=TRUE)
col6 <- mean(tab6$popularity,na.rm=TRUE)
col7 <- mean(tab7$popularity,na.rm=TRUE)
col8 <- mean(tab8$popularity,na.rm=TRUE)
col9 <- mean(tab9$popularity,na.rm=TRUE)
col10 <- mean(tab10$popularity,na.rm=TRUE)
col11 <- mean(tab11$popularity,na.rm=TRUE)
col12 <- mean(tab12$popularity,na.rm=TRUE)
col13 <- mean(tab13$popularity,na.rm=TRUE)
col14 <- mean(tab14$popularity,na.rm=TRUE)
col15 <- mean(tab15$popularity,na.rm=TRUE)
col16 <- mean(tab16$popularity,na.rm=TRUE)
col17 <- mean(tab17$popularity,na.rm=TRUE)

# exclude outliers and re-plot
sub_scaled <- scaled_df[scaled_df$popularity <= 1 ,]
p <- ggplot(sub_scaled,aes(x=num_checkins,y=popularity))
p+geom_point()
ggplot(scaled_df,aes(x=num_checkins,y=popularity),geom_point())
plot(scaled_df$num_checkins,scaled_df$avg_pos_reviews)
plot(scaled_df$num_checkins,scaled_df$popularity)

plot(scaled_df$popularity,scaled_df$num_checkins,type="l")
group <- c(1:17)
popularity_grouped <- c(col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17)
new <- cbind(group,popularity_grouped)
grouped_checkin_popularity <- data.frame(new)

saveRDS(sub_df1,file="sub_df1.RDS")
saveRDS(df2,file="df2.RDS")
saveRDS(grouped_checkin_popularity,file="grouped_checkin_popularity.RDS")

