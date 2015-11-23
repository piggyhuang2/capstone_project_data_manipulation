---
title       : #Check-ins Vs Popularity of Restaurants
subtitle    : Data Science Capstone Project
author      : Lily Huang
job         : Data Analyst
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Slide 2
Question:
What is the relation between number of check-ins and popularity of restaurants? Is it positive or negative?

---

## Slide 3
Main Challenges:
* Too many noises and unbalanced population will make it difficult to discover meaningful patterns
* Data manipulations are required to deal with missing values and data grouping 
* How to define popularity
* My definition: number of reviews * average rating by star  

---


## Slide 4
Results:
* After grouping number of check-ins, the correlation I got between #check-ins and popularity is   -0.6194577
* Based on the result, there is a significant negative correlation between number of check-ins and popularity of restaurants

---

## Slide 5
Discussion & Possible next steps:
* Further investigate users' behavior on check-ins. 
* Are users more likely to check-in when they receive negative experience?
* Do users prefer to check-in when they visit an unusual restaurants than those popular chain stores?





