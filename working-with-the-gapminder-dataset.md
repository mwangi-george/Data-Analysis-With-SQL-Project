Data Analyst with SQL
================
Mwangi George
2022-10-12

-   <a href="#introduction" id="toc-introduction">Introduction</a>
    -   <a href="#loading-important-packages-and-creating-database-connection"
        id="toc-loading-important-packages-and-creating-database-connection">Loading
        Important Packages and Creating database connection</a>
    -   <a href="#loading-gapminder-dataset-and-uploading-it-to-database"
        id="toc-loading-gapminder-dataset-and-uploading-it-to-database">Loading
        Gapminder dataset and Uploading it to database</a>
-   <a href="#sql-statements" id="toc-sql-statements">SQL Statements</a>

## Introduction

In this paper, I am going to run SQL queries with the `gapminder`
dataset. The goal is to showcase my understanding of the following SQL
clauses:

-   SELECT
-   WHERE
-   ORDER BY
-   GROUP BY
-   ALIASING

### Loading Important Packages and Creating database connection

``` r
# loading packages
library(gapminder)
library(tidyverse, quietly = T)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
    ## ✔ ggplot2 3.3.6      ✔ purrr   0.3.4 
    ## ✔ tibble  3.1.8      ✔ dplyr   1.0.10
    ## ✔ tidyr   1.2.0      ✔ stringr 1.4.1 
    ## ✔ readr   2.1.2      ✔ forcats 0.5.2 
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(RSQLite)
library(DBI)

lite_connect <- dbConnect(SQLite(), "myProjectDatabase.sqlite")
```

### Loading Gapminder dataset and Uploading it to database

``` r
# load dataset into R environment
gapminder <- gapminder

# Write the data to the database as a table
dbWriteTable(conn = lite_connect, 
             name = "gapminder", 
             value = gapminder,
             overwrite = T)

# Check whether the dataset now exists in the database
dbExistsTable(conn = lite_connect,
              name = "gapminder")
```

    ## [1] TRUE

``` r
# select the last 5 rows from the gapminder table
dbGetQuery(conn = lite_connect,
           statement = "SELECT * FROM gapminder LIMIT 5")
```

    ##       country continent year lifeExp      pop gdpPercap
    ## 1 Afghanistan      Asia 1952  28.801  8425333  779.4453
    ## 2 Afghanistan      Asia 1957  30.332  9240934  820.8530
    ## 3 Afghanistan      Asia 1962  31.997 10267083  853.1007
    ## 4 Afghanistan      Asia 1967  34.020 11537966  836.1971
    ## 5 Afghanistan      Asia 1972  36.088 13079460  739.9811

## SQL Statements

1.  **Write a query to extract only the observations from the year
    1957.**

``` sql
SELECT * 
FROM gapminder
WHERE year = 1957
```

| country     | continent | year | lifeExp |      pop |  gdpPercap |
|:------------|:----------|-----:|--------:|---------:|-----------:|
| Afghanistan | Asia      | 1957 |  30.332 |  9240934 |   820.8530 |
| Albania     | Europe    | 1957 |  59.280 |  1476505 |  1942.2842 |
| Algeria     | Africa    | 1957 |  45.685 | 10270856 |  3013.9760 |
| Angola      | Africa    | 1957 |  31.999 |  4561361 |  3827.9405 |
| Argentina   | Americas  | 1957 |  64.399 | 19610538 |  6856.8562 |
| Australia   | Oceania   | 1957 |  70.330 |  9712569 | 10949.6496 |
| Austria     | Europe    | 1957 |  67.480 |  6965860 |  8842.5980 |
| Bahrain     | Asia      | 1957 |  53.832 |   138655 | 11635.7995 |
| Bangladesh  | Asia      | 1957 |  39.348 | 51365468 |   661.6375 |
| Belgium     | Europe    | 1957 |  69.240 |  8989111 |  9714.9606 |

Displaying records 1 - 10

3.  **Filter the gapminder data to retrieve only the observation from
    China in the year 2002.**

``` sql
SELECT * 
FROM gapminder 
WHERE country = "China" 
AND year = 2002
```

| country | continent | year | lifeExp |        pop | gdpPercap |
|:--------|:----------|-----:|--------:|-----------:|----------:|
| China   | Asia      | 2002 |  72.028 | 1280400000 |  3119.281 |

1 records

4.  **Sort the gapminder dataset in ascending order of life expectancy
    (lifeExp).**

``` sql
SELECT * 
FROM gapminder 
ORDER BY lifeExp
```

| country      | continent | year | lifeExp |     pop | gdpPercap |
|:-------------|:----------|-----:|--------:|--------:|----------:|
| Rwanda       | Africa    | 1992 |  23.599 | 7290203 |  737.0686 |
| Afghanistan  | Asia      | 1952 |  28.801 | 8425333 |  779.4453 |
| Gambia       | Africa    | 1952 |  30.000 |  284320 |  485.2307 |
| Angola       | Africa    | 1952 |  30.015 | 4232095 | 3520.6103 |
| Sierra Leone | Africa    | 1952 |  30.331 | 2143249 |  879.7877 |
| Afghanistan  | Asia      | 1957 |  30.332 | 9240934 |  820.8530 |
| Cambodia     | Asia      | 1977 |  31.220 | 6978607 |  524.9722 |
| Mozambique   | Africa    | 1952 |  31.286 | 6446316 |  468.5260 |
| Sierra Leone | Africa    | 1957 |  31.570 | 2295678 | 1004.4844 |
| Burkina Faso | Africa    | 1952 |  31.975 | 4469979 |  543.2552 |

Displaying records 1 - 10

5.  **Write a query to retrieve all observations from the gapminder
    table in descending order of life expectancy (lifeExp).**

``` sql
SELECT * 
FROM gapminder 
ORDER BY lifeExp 
DESC
```

| country          | continent | year | lifeExp |       pop | gdpPercap |
|:-----------------|:----------|-----:|--------:|----------:|----------:|
| Japan            | Asia      | 2007 |  82.603 | 127467972 |  31656.07 |
| Hong Kong, China | Asia      | 2007 |  82.208 |   6980412 |  39724.98 |
| Japan            | Asia      | 2002 |  82.000 | 127065841 |  28604.59 |
| Iceland          | Europe    | 2007 |  81.757 |    301931 |  36180.79 |
| Switzerland      | Europe    | 2007 |  81.701 |   7554661 |  37506.42 |
| Hong Kong, China | Asia      | 2002 |  81.495 |   6762476 |  30209.02 |
| Australia        | Oceania   | 2007 |  81.235 |  20434176 |  34435.37 |
| Spain            | Europe    | 2007 |  80.941 |  40448191 |  28821.06 |
| Sweden           | Europe    | 2007 |  80.884 |   9031088 |  33859.75 |
| Israel           | Asia      | 2007 |  80.745 |   6426679 |  25523.28 |

Displaying records 1 - 10

6.  **Write a query to extract observations from just the year 1957
    sorted in descending order of population (pop).**

``` sql
SELECT * 
FROM gapminder 
WHERE year = 1957 
ORDER BY pop 
DESC
```

| country        | continent | year |  lifeExp |       pop |  gdpPercap |
|:---------------|:----------|-----:|---------:|----------:|-----------:|
| China          | Asia      | 1957 | 50.54896 | 637408000 |   575.9870 |
| India          | Asia      | 1957 | 40.24900 | 409000000 |   590.0620 |
| United States  | Americas  | 1957 | 69.49000 | 171984000 | 14847.1271 |
| Japan          | Asia      | 1957 | 65.50000 |  91563009 |  4317.6944 |
| Indonesia      | Asia      | 1957 | 39.91800 |  90124000 |   858.9003 |
| Germany        | Europe    | 1957 | 69.10000 |  71019069 | 10187.8267 |
| Brazil         | Americas  | 1957 | 53.28500 |  65551171 |  2487.3660 |
| United Kingdom | Europe    | 1957 | 70.42000 |  51430000 | 11283.1779 |
| Bangladesh     | Asia      | 1957 | 39.34800 |  51365468 |   661.6375 |
| Italy          | Europe    | 1957 | 67.81000 |  49182000 |  6248.6562 |

Displaying records 1 - 10

7.  **Write a query that returns the distinct number of countries in the
    Americas continent. Name the results `no_of_countries_in_America`**

``` sql
SELECT  COUNT(DISTINCT country)
        AS no_of_countries_in_America
FROM gapminder 
WHERE continent = "Americas"
```

| no_of_countries_in_America |
|---------------------------:|
|                         25 |

1 records

8.  **Write a query that returns the all records for the United States
    for 1997, 2002, and 2007.**

``` sql
SELECT * 
FROM gapminder 
WHERE  continent = "Americas"
AND country = "United States" 
AND year IN (1997, 2002, 2007)
```

| country       | continent | year | lifeExp |       pop | gdpPercap |
|:--------------|:----------|-----:|--------:|----------:|----------:|
| United States | Americas  | 1997 |  76.810 | 272911760 |  35767.43 |
| United States | Americas  | 2002 |  77.310 | 287675526 |  39097.10 |
| United States | Americas  | 2007 |  78.242 | 301139947 |  42951.65 |

3 records

9.  **Write a query that returns the average life expectancy in the
    United States as `avg_lifeExp_US` for 2007.**

``` sql
SELECT AVG(lifeExp) 
       AS avg_lifeExp_US 
FROM gapminder 
WHERE continent = "Americas"
AND country = "United States"
AND year = 2007
```

| avg_lifeExp_US |
|---------------:|
|         78.242 |

1 records

10. **Write a query to calculate the average life expectancy per
    continent as `avg_lifeExp` in 2007.**

``` sql
SELECT  continent, 
        AVG(lifeExp) AS avg_lifeExp
FROM gapminder
WHERE year = 2007
GROUP BY continent
```

| continent | avg_lifeExp |
|:----------|------------:|
| Africa    |    54.80604 |
| Americas  |    73.60812 |
| Asia      |    70.72848 |
| Europe    |    77.64860 |
| Oceania   |    80.71950 |

5 records

11. **Write a query to calculate the total population per continent as
    `total_pop` in 2007. Sort the results in decreasing order of total
    population.**

``` sql
SELECT  continent,
        SUM(pop) AS total_pop
FROM gapminder
WHERE year = 2007
GROUP BY continent
ORDER BY total_pop DESC
```

| continent |  total_pop |
|:----------|-----------:|
| Asia      | 3811953827 |
| Africa    |  929539692 |
| Americas  |  898871184 |
| Europe    |  586098529 |
| Oceania   |   24549947 |

5 records

12. **Write a query that returns the country, year, population in
    millions of people, rounded to two decimal places and life
    expectancy rounded to one decimal place. As a bonus rename the
    columns.**

``` sql
SELECT  country,
        year, 
        ROUND(pop/1000000.0, 2) AS pop_in_millions,
        ROUND(lifeExp, 1) AS lifeExp
FROM gapminder
```

| country     | year | pop_in_millions | lifeExp |
|:------------|-----:|----------------:|--------:|
| Afghanistan | 1952 |            8.43 |    28.8 |
| Afghanistan | 1957 |            9.24 |    30.3 |
| Afghanistan | 1962 |           10.27 |    32.0 |
| Afghanistan | 1967 |           11.54 |    34.0 |
| Afghanistan | 1972 |           13.08 |    36.1 |
| Afghanistan | 1977 |           14.88 |    38.4 |
| Afghanistan | 1982 |           12.88 |    39.9 |
| Afghanistan | 1987 |           13.87 |    40.8 |
| Afghanistan | 1992 |           16.32 |    41.7 |
| Afghanistan | 1997 |           22.23 |    41.8 |

Displaying records 1 - 10

13a. \*\*Write a query that returns the country, year, life expectancy
and population in thousands of people for any field with a life
expectancy greater than 70.

``` sql
SELECT  country, 
        year, 
        lifeExp,
        pop/1000.0
FROM gapminder
WHERE lifeEXP > 70
```

| country   | year | lifeExp | pop/1000.0 |
|:----------|-----:|--------:|-----------:|
| Albania   | 1982 |  70.420 |   2780.097 |
| Albania   | 1987 |  72.000 |   3075.321 |
| Albania   | 1992 |  71.581 |   3326.498 |
| Albania   | 1997 |  72.950 |   3428.038 |
| Albania   | 2002 |  75.651 |   3508.512 |
| Albania   | 2007 |  76.423 |   3600.523 |
| Algeria   | 2002 |  70.994 |  31287.142 |
| Algeria   | 2007 |  72.301 |  33333.216 |
| Argentina | 1987 |  70.774 |  31620.918 |
| Argentina | 1992 |  71.868 |  33958.947 |

Displaying records 1 - 10

There are 493 records where life expectancy is greater than 70.

13b. **How many records are there if we change lifeExp to greater than
75?**

``` sql
SELECT  country, 
        year, 
        lifeExp,
        pop/1000.0
FROM gapminder
WHERE lifeEXP > 75
```

| country   | year | lifeExp | pop/1000.0 |
|:----------|-----:|--------:|-----------:|
| Albania   | 2002 |  75.651 |   3508.512 |
| Albania   | 2007 |  76.423 |   3600.523 |
| Argentina | 2007 |  75.320 |  40301.927 |
| Australia | 1987 |  76.320 |  16257.249 |
| Australia | 1992 |  77.560 |  17481.977 |
| Australia | 1997 |  78.830 |  18565.243 |
| Australia | 2002 |  80.370 |  19546.792 |
| Australia | 2007 |  81.235 |  20434.176 |
| Austria   | 1992 |  76.040 |   7914.969 |
| Austria   | 1997 |  77.510 |   8069.876 |

Displaying records 1 - 10

There are 173 records where life expectancy is greater than 75.

14a. **Write a query that returns the country, year, life expectancy and
population in thousands of people for any field with a life expectancy
greater than 70 and before 1990. How many records are there? **

``` sql
SELECT  country,
        year, 
        lifeExp,
        pop/1000.0 AS pop_in_millions
FROM gapminder
WHERE lifeExp > 70 
AND year > 1990
```

| country   | year | lifeExp | pop_in_millions |
|:----------|-----:|--------:|----------------:|
| Albania   | 1992 |  71.581 |        3326.498 |
| Albania   | 1997 |  72.950 |        3428.038 |
| Albania   | 2002 |  75.651 |        3508.512 |
| Albania   | 2007 |  76.423 |        3600.523 |
| Algeria   | 2002 |  70.994 |       31287.142 |
| Algeria   | 2007 |  72.301 |       33333.216 |
| Argentina | 1992 |  71.868 |       33958.947 |
| Argentina | 1997 |  73.275 |       36203.463 |
| Argentina | 2002 |  74.340 |       38331.121 |
| Argentina | 2007 |  75.320 |       40301.927 |

Displaying records 1 - 10

There are 277 records.

14b. **How many records are there if we just look at the year 1952?**

``` sql
SELECT  country,
        year, 
        lifeExp,
        pop/1000.0 AS pop_in_millions
FROM gapminder
WHERE lifeExp > 70 
AND year = 1952
```

| country     | year | lifeExp | pop_in_millions |
|:------------|-----:|--------:|----------------:|
| Denmark     | 1952 |   70.78 |        4334.000 |
| Iceland     | 1952 |   72.49 |         147.962 |
| Netherlands | 1952 |   72.13 |       10381.988 |
| Norway      | 1952 |   72.67 |        3327.728 |
| Sweden      | 1952 |   71.86 |        7124.673 |

5 records

There are 5 records if we just look at the year 1952.

14c. **How many records are there if we just look at the year 2007?**

``` sql
SELECT  country,
        year, 
        lifeExp,
        pop/1000.0 AS pop_in_millions
FROM gapminder
WHERE lifeExp > 70 
AND year = 2007
```

| country                | year | lifeExp | pop_in_millions |
|:-----------------------|-----:|--------:|----------------:|
| Albania                | 2007 |  76.423 |        3600.523 |
| Algeria                | 2007 |  72.301 |       33333.216 |
| Argentina              | 2007 |  75.320 |       40301.927 |
| Australia              | 2007 |  81.235 |       20434.176 |
| Austria                | 2007 |  79.829 |        8199.783 |
| Bahrain                | 2007 |  75.635 |         708.573 |
| Belgium                | 2007 |  79.441 |       10392.226 |
| Bosnia and Herzegovina | 2007 |  74.852 |        4552.198 |
| Brazil                 | 2007 |  72.390 |      190010.647 |
| Bulgaria               | 2007 |  73.005 |        7322.858 |

Displaying records 1 - 10

There are 83 records if we just look at the year 2007.
