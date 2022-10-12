Challenge 2 - Working with Data
================
Mwangi George
2022-10-12

-   <a href="#section-one---preparation"
    id="toc-section-one---preparation">Section One - Preparation</a>
    -   <a href="#loading-important-packages"
        id="toc-loading-important-packages">Loading Important Packages</a>
    -   <a href="#creating-database" id="toc-creating-database">Creating
        database</a>
    -   <a href="#loading-dataset-from-working-directory"
        id="toc-loading-dataset-from-working-directory">Loading dataset from
        working directory</a>
    -   <a href="#dataset-structure" id="toc-dataset-structure">Dataset
        structure</a>
    -   <a href="#upload-datasets-into-database"
        id="toc-upload-datasets-into-database">Upload datasets into database</a>
-   <a href="#section-two---running-queries"
    id="toc-section-two---running-queries">Section Two - Running Queries</a>
    -   <a
        href="#calculate-the-percentage-of-global-sales-that-were-made-in-north-america"
        id="toc-calculate-the-percentage-of-global-sales-that-were-made-in-north-america">Calculate
        the percentage of global sales that were made in North America.</a>
    -   <a
        href="#extract-a-view-of-the-console-games-titles-ordered-by-platform-name-in-ascending-order-and-year-of-release-in-descending-order"
        id="toc-extract-a-view-of-the-console-games-titles-ordered-by-platform-name-in-ascending-order-and-year-of-release-in-descending-order">Extract
        a view of the console games titles ordered by platform name in ascending
        order and year of release in descending order.</a>
    -   <a
        href="#for-each-game-title-extract-the-first-four-letters-of-the-publishers-name"
        id="toc-for-each-game-title-extract-the-first-four-letters-of-the-publishers-name">For
        each game title extract the first four letters of the publisher’s
        name.</a>

## Section One - Preparation

In this challenge, I assume am an analytics consultant helping a console
games company conduct market research. The company has supplied me with
a file containing two datasets:

-   ConsoleGames.csv - *A historic list of all games released between
    1980 and 2015.*

-   ConsoleDates.csv - *A historic list of all console platforms(such as
    Wii, Play Station, Xbox) and information about them.*

My task is to upload the data into a database and perform the following
Analytics:

1.  Calculate the percentage of global sales that were made in North
    America.

2.  Extract a view of the console games titles ordered by platform name
    in ascending order and year of release in descending order.

3.  For each game title extract the first four letters of the
    publisher’s name.

4.  Display all console platforms which were released either just before
    Black Friday or just before Christmas(in any year).

5.  Order the platforms by their longevity in ascending order (i.e. the
    platform which was available for the longest at the bottom).

6.  Demonstrate how to deal with Game_Year column if the client wants to
    convert it to a different data type.

7.  Provide recommendation on how to deal with missing data in the file

### Loading Important Packages

``` r
library(DBI)
library(odbc)
library(sqldf)
```

    ## Loading required package: gsubfn

    ## Loading required package: proto

    ## Loading required package: RSQLite

``` r
library(RODBC)
library(tidyverse)
```

    ## ── Attaching packages
    ## ───────────────────────────────────────
    ## tidyverse 1.3.2 ──

    ## ✔ ggplot2 3.3.6      ✔ purrr   0.3.4 
    ## ✔ tibble  3.1.8      ✔ dplyr   1.0.10
    ## ✔ tidyr   1.2.0      ✔ stringr 1.4.1 
    ## ✔ readr   2.1.2      ✔ forcats 0.5.2 
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(RSQLite)
```

### Creating database

-   I am going to create a SQLite database in the memory of R and store
    it in the current working directory. Since I am working in R Studio,
    I will create a connection to the database and assign it to
    `lite_connect`. I will use this connection to perform all subsequent
    data operations in R.

``` r
# Creating database
lite_connect <- dbConnect(SQLite(), "myProjectDatabase.sqlite")
```

### Loading dataset from working directory

``` r
console_games <- read_csv("data/console_games.csv", 
                          show_col_types = F)
console_dates <- read_csv("data/console_dates.csv", 
                          show_col_types = F)
```

### Dataset structure

``` r
glimpse(console_dates)
```

    ## Rows: 30
    ## Columns: 5
    ## $ Platform                <chr> "Wii", "NES", "GB", "DS", "X360", "PS3", "PS2"…
    ## $ FirstRetailAvailability <date> 2006-11-19, 1983-07-15, 1989-04-21, 2004-11-2…
    ## $ Discontinued            <date> 2013-10-20, 2003-09-25, 2003-03-23, 2014-05-2…
    ## $ UnitsSoldMillions       <dbl> 101.63, 61.91, 118.69, 18.79, 84.00, 80.00, 15…
    ## $ Comment                 <chr> NA, "Nintendo Entertainment System", "Game Boy…

``` r
glimpse(console_games)
```

    ## Rows: 15,979
    ## Columns: 10
    ## $ Rank        <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,…
    ## $ Name        <chr> "Wii Sports", "Super Mario Bros.", "Mario Kart Wii", "Wii …
    ## $ Platform    <chr> "Wii", "NES", "Wii", "Wii", "GB", "GB", "DS", "Wii", "Wii"…
    ## $ Year        <dbl> 2006, 1985, 2008, 2009, 1996, 1989, 2006, 2006, 2009, 1984…
    ## $ Genre       <chr> "Sports", "Platform", "Racing", "Sports", "Role-Playing", …
    ## $ Publisher   <chr> "Nintendo", "Nintendo", "Nintendo", "Nintendo", "Nintendo"…
    ## $ NA_Sales    <dbl> 41.49, 29.08, 15.85, 15.75, 11.27, 23.20, 11.38, 14.03, 14…
    ## $ EU_Sales    <dbl> 29.02, 3.58, 12.88, 11.01, 8.89, 2.26, 9.23, 9.20, 7.06, 0…
    ## $ JP_Sales    <dbl> 3.77, 6.81, 3.79, 3.28, 10.22, 4.22, 6.50, 2.93, 4.70, 0.2…
    ## $ Other_Sales <dbl> 8.46, 0.77, 3.31, 2.96, 1.00, 0.58, 2.90, 2.85, 2.26, 0.47…

``` r
# modify the column names of the console_games table
colnames(console_games) <- c("game_rank",
                             "game_name",
                             "platform_name",
                             "game_year",
                             "genre",
                             "publisher",
                             "na_sales",
                             "eu_sales",
                             "jp_sales",
                             "other_sales")


# modify the column names of the console_dates table
colnames(console_dates) <- c("platform_name",
                             "first_retail_availability",
                             "discontinued",
                             "units_sold_millions",
                             "platform_comment")

# change the dates into characters 
console_dates$first_retail_availability <- as.character(console_dates$first_retail_availability)

console_dates$discontinued <- as.character(console_dates$discontinued)
```

### Upload datasets into database

``` r
# Creating connection
lite_connect <- dbConnect(SQLite(), "myProjectDatabase.sqlite")
```

``` r
# upload console_gamees
dbWriteTable(conn = lite_connect, 
             "console_games", 
             console_games,
             overwrite = T)
# upload console dates
dbWriteTable(conn = lite_connect,
             "console_dates",
             console_dates,
             overwrite = T)

# listing the tables in the database
dbListTables(conn = lite_connect)
```

    ## [1] "console_dates"       "console_games"       "consumer_complaints"

## Section Two - Running Queries

Having set everything, I can now start running SQL queries to accomplish
my objectives. I will start by running a query that displays the first
five rows of each table in the created SQLite database

``` sql
-- select the first 5 rows of the console_games table
SELECT 
* 
FROM 
console_games 
LIMIT 5
```

| game_rank | game_name                | platform_name | game_year | genre        | publisher | na_sales | eu_sales | jp_sales | other_sales |
|:----------|:-------------------------|:--------------|----------:|:-------------|:----------|---------:|---------:|---------:|------------:|
| 1         | Wii Sports               | Wii           |      2006 | Sports       | Nintendo  |    41.49 |    29.02 |     3.77 |        8.46 |
| 2         | Super Mario Bros.        | NES           |      1985 | Platform     | Nintendo  |    29.08 |     3.58 |     6.81 |        0.77 |
| 3         | Mario Kart Wii           | Wii           |      2008 | Racing       | Nintendo  |    15.85 |    12.88 |     3.79 |        3.31 |
| 4         | Wii Sports Resort        | Wii           |      2009 | Sports       | Nintendo  |    15.75 |    11.01 |     3.28 |        2.96 |
| 5         | Pokemon Red/Pokemon Blue | GB            |      1996 | Role-Playing | Nintendo  |    11.27 |     8.89 |    10.22 |        1.00 |

5 records

``` sql
-- select the first 5 rows of the console_dates table
SELECT 
* 
FROM 
console_dates 
LIMIT 5
```

| platform_name | first_retail_availability | discontinued | units_sold_millions | platform_comment              |
|:--------------|:--------------------------|:-------------|--------------------:|:------------------------------|
| Wii           | 2006-11-19                | 2013-10-20   |              101.63 | NA                            |
| NES           | 1983-07-15                | 2003-09-25   |               61.91 | Nintendo Entertainment System |
| GB            | 1989-04-21                | 2003-03-23   |              118.69 | Game Boy                      |
| DS            | 2004-11-21                | 2014-05-20   |               18.79 | Nintendo DS                   |
| X360          | 2005-11-22                | 2016-04-20   |               84.00 | Xbox 360                      |

5 records

### Calculate the percentage of global sales that were made in North America.

``` sql
SELECT 
  SUM(na_sales)
    /(SUM(na_sales) + 
    SUM(eu_sales) + 
    SUM(jp_sales) + 
    SUM(other_sales)) * 100
AS
na_percentage_sales
FROM
console_games
```

| na_percentage_sales |
|--------------------:|
|            49.31646 |

1 records

### Extract a view of the console games titles ordered by platform name in ascending order and year of release in descending order.

``` sql
SELECT 
  game_name 
FROM 
console_games 
ORDER BY 
platform_name ASC, 
game_year DESC 
```

| game_name                                   |
|:--------------------------------------------|
| WWE ’12                                     |
| Toy Story 3: The Video Game                 |
| LEGO Indiana Jones: The Original Adventures |
| Harry Potter and the Order of the Phoenix   |
| Shrek 2                                     |
| Double Dragon                               |
| Klax                                        |
| River Raid II                               |
| Rampage                                     |
| Kung-Fu Master                              |

Displaying records 1 - 10

### For each game title extract the first four letters of the publisher’s name.

``` sql
SELECT game_name,
        substring(publisher, 1, 4)
        AS publisher_initial
FROM 
console_games
```

| game_name                 | publisher_initial |
|:--------------------------|:------------------|
| Wii Sports                | Nint              |
| Super Mario Bros.         | Nint              |
| Mario Kart Wii            | Nint              |
| Wii Sports Resort         | Nint              |
| Pokemon Red/Pokemon Blue  | Nint              |
| Tetris                    | Nint              |
| New Super Mario Bros.     | Nint              |
| Wii Play                  | Nint              |
| New Super Mario Bros. Wii | Nint              |
| Duck Hunt                 | Nint              |

Displaying records 1 - 10
