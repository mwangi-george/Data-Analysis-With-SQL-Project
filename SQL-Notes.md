Short Notes - SQL
================
Mwangi George
2022-10-14

## Introduction

This markdown discusses some SQL commands and clauses I have encountered
in my learning journey. Since am using R markdown to make this document,
I am going to create connections with two SQLite databases stored in the
memory of R. Before that, I will load the necessary libraries that I
will require.

``` r
# loading important packages
pacman::p_load(tidyverse, DBI, RSQLite)

# creating database connections
consumer_conn <- dbConnect(SQLite(), "myProjectDatabase.sqlite")

# consumer_conn contains 4 tables listed below
dbListTables(consumer_conn)
```

    ## [1] "console_dates"       "console_games"       "consumer_complaints"
    ## [4] "gapminder"

``` r
# creating another connection
main_conn <- dbConnect(SQLite(), "C:\\Users\\Admin\\Documents\\learningSQL\\SQl.sqlite")

#main_conn contains several tables as shown below
dbListTables(conn = main_conn)
```

    ##  [1] "base_data"                        "datafiniti_hotel_big_data"       
    ##  [3] "datafiniti_hotel_reviews"         "datafiniti_hotel_reviews_Jun2019"
    ##  [5] "datarium_marketing"               "fam_Info"                        
    ##  [7] "laterite"                         "lemonade_stand"                  
    ##  [9] "product_full"                     "product_info"                    
    ## [11] "product_stats"                    "product_table"                   
    ## [13] "product_tests"                    "products"

## Sub-languages of SQL

-   Data Definition Language (DFL): used for creating and modifying the
    structure of a database.

-   Data Manipulation Language (DML): used for performing the Read,
    Insert, Update, and Delete operations of the data in the database.

-   Data Control Language (DCL): used for controlling the access of the
    data in a database.

## ALTER TABLE

The `ALTER` command is useful when modifying columns in a table. Its
syntax is: \* `ALTER TABLE [table_name] ADD [column_name][data_type]`

**Adding Columns: Example**

``` sql
--select all columns from the table fam_info
SELECT * 
FROM fam_info
```

| id  | first_name | last_name | age | gender | education       | body_height_cm | body_weight_kg | shoe_size | marital_status |
|:----|:-----------|:----------|----:|:-------|:----------------|---------------:|---------------:|----------:|:---------------|
| 1   | John       | Mwangi    |  47 | Male   | Upper Primary   |            180 |             88 |        45 | married        |
| 2   | Virginia   | Karugi    |  42 | Female | Upper Primary   |            155 |             85 |        40 | married        |
| 3   | George     | Ngugi     |  23 | Male   | University      |            178 |             65 |        44 | single         |
| 4   | Carol      | Wanjiru   |  20 | Female | Upper Secondary |            150 |             70 |        39 | married        |
| 5   | Faith      | Gathoni   |  18 | Female | Upper Secodary  |            165 |             73 |        40 | single         |
| 6   | Evelyn     | Nyambura  |  14 | Female | Lower Secondary |            145 |             55 |        38 | single         |
| 7   | Anastacia  | Wairimu   |   5 | Female | Lower Primary   |             80 |             30 |        20 | single         |
| 8   | Alvin      | Njau      |   0 | Male   | None            |             50 |             10 |        15 | single         |

8 records

``` sql
-- Add a column (relation_to_John) to the table fam_info 
ALTER TABLE 
fam_info 
ADD relation_to_John VARCHAR (50)
```

``` sql
-- to see if the column was add, let's select all columns from fam_info
SELECT *
FROM fam_info
```

| id  | first_name | last_name | age | gender | education       | body_height_cm | body_weight_kg | shoe_size | marital_status | relation_to_John |
|:----|:-----------|:----------|----:|:-------|:----------------|---------------:|---------------:|----------:|:---------------|:-----------------|
| 1   | John       | Mwangi    |  47 | Male   | Upper Primary   |            180 |             88 |        45 | married        | NA               |
| 2   | Virginia   | Karugi    |  42 | Female | Upper Primary   |            155 |             85 |        40 | married        | NA               |
| 3   | George     | Ngugi     |  23 | Male   | University      |            178 |             65 |        44 | single         | NA               |
| 4   | Carol      | Wanjiru   |  20 | Female | Upper Secondary |            150 |             70 |        39 | married        | NA               |
| 5   | Faith      | Gathoni   |  18 | Female | Upper Secodary  |            165 |             73 |        40 | single         | NA               |
| 6   | Evelyn     | Nyambura  |  14 | Female | Lower Secondary |            145 |             55 |        38 | single         | NA               |
| 7   | Anastacia  | Wairimu   |   5 | Female | Lower Primary   |             80 |             30 |        20 | single         | NA               |
| 8   | Alvin      | Njau      |   0 | Male   | None            |             50 |             10 |        15 | single         | NA               |

8 records

**Dropping Columns: Example**

``` sql
-- drop the created column 
ALTER TABLE
fam_info
DROP relation_to_John
```

``` sql
--select all columns from the table fam_info
SELECT * 
FROM fam_info
```

| id  | first_name | last_name | age | gender | education       | body_height_cm | body_weight_kg | shoe_size | marital_status |
|:----|:-----------|:----------|----:|:-------|:----------------|---------------:|---------------:|----------:|:---------------|
| 1   | John       | Mwangi    |  47 | Male   | Upper Primary   |            180 |             88 |        45 | married        |
| 2   | Virginia   | Karugi    |  42 | Female | Upper Primary   |            155 |             85 |        40 | married        |
| 3   | George     | Ngugi     |  23 | Male   | University      |            178 |             65 |        44 | single         |
| 4   | Carol      | Wanjiru   |  20 | Female | Upper Secondary |            150 |             70 |        39 | married        |
| 5   | Faith      | Gathoni   |  18 | Female | Upper Secodary  |            165 |             73 |        40 | single         |
| 6   | Evelyn     | Nyambura  |  14 | Female | Lower Secondary |            145 |             55 |        38 | single         |
| 7   | Anastacia  | Wairimu   |   5 | Female | Lower Primary   |             80 |             30 |        20 | single         |
| 8   | Alvin      | Njau      |   0 | Male   | None            |             50 |             10 |        15 | single         |

8 records

## AND & OR Operators

These operators are useful when retrieving data from a table based on
multiple conditions.

Syntax:

-   `SELECT * FROM table WHERE (condition1) AND (condition2)`;
-   `SELECT * FROM table WHERE (condition1) OR (condition2)`

**Examples**

``` sql
SELECT * 
FROM fam_info
WHERE age > 20 
AND gender = "Male"
```

|  id | first_name | last_name | age | gender | education     | body_height_cm | body_weight_kg | shoe_size | marital_status |
|----:|:-----------|:----------|----:|:-------|:--------------|---------------:|---------------:|----------:|:---------------|
|   1 | John       | Mwangi    |  47 | Male   | Upper Primary |            180 |             88 |        45 | married        |
|   3 | George     | Ngugi     |  23 | Male   | University    |            178 |             65 |        44 | single         |

2 records

``` sql
SELECT * 
FROM fam_info
WHERE age > 20
OR body_weight_kg <30
```

|  id | first_name | last_name | age | gender | education     | body_height_cm | body_weight_kg | shoe_size | marital_status |
|----:|:-----------|:----------|----:|:-------|:--------------|---------------:|---------------:|----------:|:---------------|
|   1 | John       | Mwangi    |  47 | Male   | Upper Primary |            180 |             88 |        45 | married        |
|   2 | Virginia   | Karugi    |  42 | Female | Upper Primary |            155 |             85 |        40 | married        |
|   3 | George     | Ngugi     |  23 | Male   | University    |            178 |             65 |        44 | single         |
|   8 | Alvin      | Njau      |   0 | Male   | None          |             50 |             10 |        15 | single         |

4 records

## CASE Expression

The CASE expression is used to implement if-then logic.

Syntax:

`CASE input_expression` `WHEN compare1 THEN result1`
`[WHEN compare2 THEN result2]...` `[ELSE resultX]` `END`

**Examples**

``` sql
SELECT first_name, last_name,
CASE WHEN age >= 20 THEN "Adult"   --no commas
     WHEN age < 20 THEN "Young"
ELSE "Not Applicable"
END AS Maturity_level
FROM fam_info
```

| first_name | last_name | Maturity_level |
|:-----------|:----------|:---------------|
| John       | Mwangi    | Adult          |
| Virginia   | Karugi    | Adult          |
| George     | Ngugi     | Adult          |
| Carol      | Wanjiru   | Adult          |
| Faith      | Gathoni   | Young          |
| Evelyn     | Nyambura  | Young          |
| Anastacia  | Wairimu   | Young          |
| Alvin      | Njau      | Young          |

8 records

``` sql
SELECT first_name, last_name,
CASE WHEN body_height_cm >= 100 THEN "Tall"   --no commas
     WHEN body_height_cm < 100 THEN "Short"
ELSE "Not Applicable"
END AS Tallness
FROM fam_info
```

| first_name | last_name | Tallness |
|:-----------|:----------|:---------|
| John       | Mwangi    | Tall     |
| Virginia   | Karugi    | Tall     |
| George     | Ngugi     | Tall     |
| Carol      | Wanjiru   | Tall     |
| Faith      | Gathoni   | Tall     |
| Evelyn     | Nyambura  | Tall     |
| Anastacia  | Wairimu   | Short    |
| Alvin      | Njau      | Short    |

8 records

**CASE in an ORDER BY Clause**

``` sql
SELECT first_name, gender, education
FROM fam_info
ORDER By 
CASE education
    WHEN "University" THEN 1
    WHEN "Upper Secondary" THEN 2
    WHEN "Lower Secondary" THEN 3
    ELSE 4
    END, gender
```

| first_name | gender | education       |
|:-----------|:-------|:----------------|
| George     | Male   | University      |
| Carol      | Female | Upper Secondary |
| Evelyn     | Female | Lower Secondary |
| Virginia   | Female | Upper Primary   |
| Faith      | Female | Upper Secodary  |
| Anastacia  | Female | Lower Primary   |
| John       | Male   | Upper Primary   |
| Alvin      | Male   | None            |

8 records

## CREATING TABLES

The CREATE TABLE statement is used to create a table in a database.

Syntax:

`CREATE TABLE table_name` `(` `column_name1 data_type,`
`column_name2 data_type,` `column_name3 data_type,` `....` `)`

``` sql
CREATE TABLE
products_data
(
product_id INT IDENTITY(1,1) PRIMARY KEY,
product_name VARCHAR (50) NOT NULL,
product_type VARCHAR (50) NOT NULL,
class VARCHAR (50) NOT NULL,
lauch_year INT NULL
)
```

### Check whether the table exists in the database

``` r
dbExistsTable(conn = main_conn,
              name = "products_data")
```

    ## [1] TRUE
