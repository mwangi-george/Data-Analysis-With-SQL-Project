---
  title: "Data Analysis With SQL Project"
author: "Mwangi George"
date: "2022-10-10"
output: 
  github_document:
  toc: true
---
  
  ## Section One - Preparation
  In this Section, I assume am a Data Analyst working for a government agency. I have been supplied a dataset with consumer complaints received by financial institutions in 2013-2015. My task is to upload the data into a database and perform the following preliminary analyses. 

1. Find out how many complaints were received and sent on the same day.
2. Extract the complaints received in the state of New York.
3. Extract the complaints received in the state of New York and California.
4. Extract all the rows with the word "Credit" in the product field.
5. Extract all the rows with the word "Late" in the issue field.

The dataset used in this section can be found online from the Consumer Financial Protection Bureau [web page](http://www.consumerfinance.gov/data-research/consumer-complaints/). 

### Loading Important Packages
```{r}
library(DBI)
library(odbc)
library(sqldf)
library(RODBC)
library(tidyverse)
library(RSQLite)
```

### Creating database
* I am going to create a SQLite database in the memory of R and store it in the current working directory. Since I am working in R Studio, I will create a connection to the database and assign it to `lite_connect`. I will use this connection to perform all subsequent data operations in R.
```{r}
# Creating database
lite_connect <- dbConnect(SQLite(), "myProjectDatabase.sqlite")
```

### Loading dataset from working directory
```{r}
consumer_complaints <- read_csv("data/consumer_complaints.csv", 
                                show_col_types = T)
```

### Dataset structure
```{r}
# print dataset structure
glimpse(consumer_complaints)

# print dataset dimensions 
dim(consumer_complaints)

# print column names 
names(consumer_complaints)
```

### Manipulating the dataset
To make the dataset SQL ready, I will change the column names to main a consistent naming convention.
```{r}
# changing column names
colnames(consumer_complaints) <- c("date_received", 
                                   "product_name", 
                                   "sub_product", 
                                   "issue", 
                                   "sub_issue", 
                                   "consumer_complaint_narrative",
                                   "company_public_response", 
                                   "company",
                                   "state_name",
                                   "zip_code",
                                   "tags",
                                   "consumer_consent_provided",
                                   "submitted_via",
                                   "date_sent",
                                   "company_response_to_consumer",
                                   "timely_response",
                                   "consumer_disputed",
                                   "complaint_id")
```

```{r}
# manipulating dates into characters.
consumer_complaints$date_received <- as.character(consumer_complaints$date_received)
consumer_complaints$date_sent <- as.character(consumer_complaints$date_sent)
```


### Uploading the consumer_complaints table to the database
```{r}
# write the dataset to the SQLite dataset
dbWriteTable(conn = lite_connect, 
             "consumer_complaints", 
             consumer_complaints, 
             overwrite = T)
```


### Delete the table from R environment. 
```{r}
# This ensures that the only place I can access the data is from the database.
rm(consumer_complaints)
```


## Section Two - Querying
* Having created a datebase, uploaded the dataset, and created an R connection, it is now time to run SQL queries. 

### Find out how many complaints were received and sent on the same day.
```{sql connection = lite_connect}
SELECT * FROM
consumer_complaints 
WHERE
date_sent = date_received
```

### Extract the complaints received in the state of New York.
```{sql connection = lite_connect}

SELECT * FROM 
consumer_complaints 
WHERE 
state_name = "NY"
```

### Extract the complaints received in the state of New York and California.
```{sql connection= lite_connect}

SELECT * FROM
consumer_complaints
WHERE
state_name IN ("NY", "CA")

```

### Extract all the rows with the word "Credit" in the product field.
```{sql connection= lite_connect}

SELECT * FROM 
consumer_complaints 
WHERE 
product_name 
LIKE 
"%Credit%"

```

### Extract all the rows with the word "Late" in the issue field.
```{sql connection=lite_connect}

SELECT * FROM 
consumer_complaints 
WHERE 
issue 
LIKE 
"%Late%"

```

