Data Analysis With SQL Project
================
Mwangi George
2022-10-10

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
    -   <a href="#manipulating-the-dataset"
        id="toc-manipulating-the-dataset">Manipulating the dataset</a>
    -   <a href="#uploading-the-consumer_complaints-table-to-the-database"
        id="toc-uploading-the-consumer_complaints-table-to-the-database">Uploading
        the consumer_complaints table to the database</a>
    -   <a href="#delete-the-table-from-r-environment"
        id="toc-delete-the-table-from-r-environment">Delete the table from R
        environment.</a>
-   <a href="#section-two---querying"
    id="toc-section-two---querying">Section Two - Querying</a>
    -   <a
        href="#find-out-how-many-complaints-were-received-and-sent-on-the-same-day"
        id="toc-find-out-how-many-complaints-were-received-and-sent-on-the-same-day">Find
        out how many complaints were received and sent on the same day.</a>
    -   <a href="#extract-the-complaints-received-in-the-state-of-new-york"
        id="toc-extract-the-complaints-received-in-the-state-of-new-york">Extract
        the complaints received in the state of New York.</a>
    -   <a
        href="#extract-the-complaints-received-in-the-state-of-new-york-and-california"
        id="toc-extract-the-complaints-received-in-the-state-of-new-york-and-california">Extract
        the complaints received in the state of New York and California.</a>
    -   <a
        href="#extract-all-the-rows-with-the-word-credit-in-the-product-field"
        id="toc-extract-all-the-rows-with-the-word-credit-in-the-product-field">Extract
        all the rows with the word “Credit” in the product field.</a>
    -   <a href="#extract-all-the-rows-with-the-word-late-in-the-issue-field"
        id="toc-extract-all-the-rows-with-the-word-late-in-the-issue-field">Extract
        all the rows with the word “Late” in the issue field.</a>

## Section One - Preparation

In this Section, I assume am a Data Analyst working for a government
agency. I have been supplied a dataset with consumer complaints received
by financial institutions in 2013-2015. My task is to upload the data
into a database and perform the following preliminary analyses.

1.  Find out how many complaints were received and sent on the same day.
2.  Extract the complaints received in the state of New York.
3.  Extract the complaints received in the state of New York and
    California.
4.  Extract all the rows with the word “Credit” in the product field.
5.  Extract all the rows with the word “Late” in the issue field.

The dataset used in this section can be found online from the Consumer
Financial Protection Bureau [web
page](http://www.consumerfinance.gov/data-research/consumer-complaints/).

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
consumer_complaints <- read_csv("data/consumer_complaints.csv", 
                                show_col_types = T)
```

    ## Rows: 65499 Columns: 18
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (15): Product Name, Sub Product, Issue, Sub Issue, Consumer Complaint N...
    ## dbl   (1): Complaint ID
    ## date  (2): Date Received, Date Sent to Company
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

### Dataset structure

``` r
# print dataset structure
glimpse(consumer_complaints)
```

    ## Rows: 65,499
    ## Columns: 18
    ## $ `Date Received`                <date> 2013-07-29, 2013-07-29, 2013-07-29, 20…
    ## $ `Product Name`                 <chr> "Consumer Loan", "Bank account or servi…
    ## $ `Sub Product`                  <chr> "Vehicle loan", "Checking account", "Ch…
    ## $ Issue                          <chr> "Managing the loan or lease", "Using a …
    ## $ `Sub Issue`                    <chr> NA, NA, NA, NA, NA, NA, "Debt is not mi…
    ## $ `Consumer Complaint Narrative` <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ `Company Public Response`      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ Company                        <chr> "Wells Fargo & Company", "Wells Fargo &…
    ## $ `State Name`                   <chr> "VA", "CA", "NY", "GA", "CT", "TX", "VA…
    ## $ `Zip Code`                     <chr> "24540", "95992", "10065", "30084", "61…
    ## $ Tags                           <chr> NA, "Older American", NA, NA, NA, NA, N…
    ## $ `Consumer Consent Provided`    <chr> "N/A", "N/A", "N/A", "N/A", "N/A", "N/A…
    ## $ `Submitted via`                <chr> "Phone", "Web", "Fax", "Web", "Web", "W…
    ## $ `Date Sent to Company`         <date> 2013-07-30, 2013-07-31, 2013-07-31, 20…
    ## $ `Company Response to Consumer` <chr> "Closed with explanation", "Closed with…
    ## $ `Timely Response`              <chr> "Yes", "Yes", "Yes", "Yes", "Yes", "Yes…
    ## $ `Consumer Disputed`            <chr> "No", "No", "No", "No", "No", "No", "No…
    ## $ `Complaint ID`                 <dbl> 468882, 468889, 468879, 468949, 475823,…

``` r
# print dataset dimensions 
dim(consumer_complaints)
```

    ## [1] 65499    18

``` r
# print column names 
names(consumer_complaints)
```

    ##  [1] "Date Received"                "Product Name"                
    ##  [3] "Sub Product"                  "Issue"                       
    ##  [5] "Sub Issue"                    "Consumer Complaint Narrative"
    ##  [7] "Company Public Response"      "Company"                     
    ##  [9] "State Name"                   "Zip Code"                    
    ## [11] "Tags"                         "Consumer Consent Provided"   
    ## [13] "Submitted via"                "Date Sent to Company"        
    ## [15] "Company Response to Consumer" "Timely Response"             
    ## [17] "Consumer Disputed"            "Complaint ID"

### Manipulating the dataset

To make the dataset SQL ready, I will change the column names to main a
consistent naming convention.

``` r
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

``` r
# manipulating dates into characters.
consumer_complaints$date_received <- as.character(consumer_complaints$date_received)
consumer_complaints$date_sent <- as.character(consumer_complaints$date_sent)
```

### Uploading the consumer_complaints table to the database

``` r
# write the dataset to the SQLite dataset
dbWriteTable(conn = lite_connect, 
             "consumer_complaints", 
             consumer_complaints, 
             overwrite = T)
```

### Delete the table from R environment.

``` r
# This ensures that the only place I can access the data is from the database.
rm(consumer_complaints)
```

## Section Two - Querying

-   Having created a datebase, uploaded the dataset, and created an R
    connection, it is now time to run SQL queries.

### Find out how many complaints were received and sent on the same day.

``` sql
SELECT * FROM
consumer_complaints 
WHERE
date_sent = date_received
```

| date_received | product_name     | sub_product                            | issue                                    | sub_issue                             | consumer_complaint_narrative | company_public_response | company                                | state_name | zip_code | tags          | consumer_consent_provided | submitted_via | date_sent  | company_response_to_consumer    | timely_response | consumer_disputed | complaint_id |
|:--------------|:-----------------|:---------------------------------------|:-----------------------------------------|:--------------------------------------|:-----------------------------|:------------------------|:---------------------------------------|:-----------|:---------|:--------------|:--------------------------|:--------------|:-----------|:--------------------------------|:----------------|:------------------|-------------:|
| 2013-07-29    | Credit card      | NA                                     | APR or interest rate                     | NA                                    | NA                           | NA                      | Synchrony Financial                    | WA         | 98548    | NA            | N/A                       | Web           | 2013-07-29 | Closed with monetary relief     | Yes             | No                |       469131 |
| 2013-07-29    | Credit reporting | NA                                     | Credit monitoring or identity protection | Problem cancelling or closing account | NA                           | NA                      | Experian                               | CA         | 90034    | NA            | N/A                       | Web           | 2013-07-29 | Closed with monetary relief     | Yes             | No                |       474204 |
| 2013-07-29    | Credit reporting | NA                                     | Incorrect information on credit report   | Public record                         | NA                           | NA                      | Equifax                                | CA         | 91605    | NA            | N/A                       | Web           | 2013-07-29 | Closed with non-monetary relief | Yes             | No                |       469201 |
| 2013-07-29    | Credit card      | NA                                     | Delinquent account                       | NA                                    | NA                           | NA                      | Amex                                   | TX         | 78232    | NA            | N/A                       | Web           | 2013-07-29 | Closed with monetary relief     | Yes             | No                |       479990 |
| 2013-07-29    | Credit reporting | NA                                     | Improper use of my credit report         | Report improperly shared by CRC       | NA                           | NA                      | Equifax                                | MO         | 64725    | NA            | N/A                       | Fax           | 2013-07-29 | Closed with explanation         | Yes             | No                |       479282 |
| 2013-07-29    | Credit card      | NA                                     | Billing disputes                         | NA                                    | NA                           | NA                      | Capital One                            | FL         | 32226    | Servicemember | N/A                       | Web           | 2013-07-29 | Closed with explanation         | Yes             | No                |       475777 |
| 2013-07-29    | Credit reporting | NA                                     | Unable to get credit report/credit score | Problem getting my free annual report | NA                           | NA                      | TransUnion Intermediate Holdings, Inc. | CO         | 80247    | NA            | N/A                       | Web           | 2013-07-29 | Closed with non-monetary relief | Yes             | No                |       479873 |
| 2013-07-30    | Credit card      | NA                                     | Closing/Cancelling account               | NA                                    | NA                           | NA                      | Citibank                               | TX         | 78249    | NA            | N/A                       | Web           | 2013-07-30 | Closed with explanation         | Yes             | Yes               |       470852 |
| 2013-07-31    | Mortgage         | Conventional fixed mortgage            | Loan modification,collection,foreclosure | NA                                    | NA                           | NA                      | Bank of America                        | NY         | 14212    | NA            | N/A                       | Web           | 2013-07-31 | Closed with explanation         | Yes             | Yes               |       493136 |
| 2013-07-31    | Mortgage         | Conventional adjustable mortgage (ARM) | Loan modification,collection,foreclosure | NA                                    | NA                           | NA                      | Nationstar Mortgage                    | CA         | 95037    | NA            | N/A                       | Web           | 2013-07-31 | Closed with explanation         | Yes             | Yes               |       454695 |

Displaying records 1 - 10

### Extract the complaints received in the state of New York.

``` sql

SELECT * FROM 
consumer_complaints 
WHERE 
state_name = "NY"
```

| date_received | product_name            | sub_product                 | issue                                    | sub_issue | consumer_complaint_narrative | company_public_response | company                            | state_name | zip_code | tags                          | consumer_consent_provided | submitted_via | date_sent  | company_response_to_consumer    | timely_response | consumer_disputed | complaint_id |
|:--------------|:------------------------|:----------------------------|:-----------------------------------------|:----------|:-----------------------------|:------------------------|:-----------------------------------|:-----------|:---------|:------------------------------|:--------------------------|:--------------|:-----------|:--------------------------------|:----------------|:------------------|-------------:|
| 2013-07-29    | Bank account or service | Checking account            | Account opening, closing, or management  | NA        | NA                           | NA                      | Santander Bank US                  | NY         | 10065    | NA                            | N/A                       | Fax           | 2013-07-31 | Closed                          | Yes             | No                |       468879 |
| 2013-07-29    | Mortgage                | Conventional fixed mortgage | Loan modification,collection,foreclosure | NA        | NA                           | NA                      | JPMorgan Chase & Co.               | NY         | 14092    | NA                            | N/A                       | Phone         | 2013-07-31 | Closed with explanation         | Yes             | No                |       469057 |
| 2013-07-29    | Mortgage                | Conventional fixed mortgage | Loan modification,collection,foreclosure | NA        | NA                           | NA                      | JPMorgan Chase & Co.               | NY         | 10019    | NA                            | N/A                       | Web           | 2013-07-30 | Closed with explanation         | Yes             | Yes               |       469070 |
| 2013-07-29    | Mortgage                | Conventional fixed mortgage | Application, originator, mortgage broker | NA        | NA                           | NA                      | Wells Fargo & Company              | NY         | 10605    | NA                            | N/A                       | Web           | 2013-07-31 | Closed with non-monetary relief | Yes             | No                |       480173 |
| 2013-07-29    | Mortgage                | Other mortgage              | Loan modification,collection,foreclosure | NA        | NA                           | NA                      | Ocwen                              | NY         | 14467    | NA                            | N/A                       | Referral      | 2013-07-30 | Closed with explanation         | Yes             | Yes               |       469360 |
| 2013-07-29    | Mortgage                | Conventional fixed mortgage | Loan servicing, payments, escrow account | NA        | NA                           | NA                      | CIT Bank National Association      | NY         | 11101    | NA                            | N/A                       | Web           | 2013-07-31 | Closed with explanation         | Yes             | No                |       469487 |
| 2013-07-29    | Mortgage                | Other mortgage              | Loan servicing, payments, escrow account | NA        | NA                           | NA                      | Ocwen                              | NY         | 10038    | NA                            | N/A                       | Web           | 2013-08-13 | Closed                          | Yes             | No                |       480183 |
| 2013-07-29    | Bank account or service | Other bank product/service  | Problems caused by my funds being low    | NA        | NA                           | NA                      | Bank of America                    | NY         | 11716    | Older American, Servicemember | N/A                       | Phone         | 2013-08-01 | Closed with explanation         | Yes             | No                |       469537 |
| 2013-07-29    | Consumer Loan           | Vehicle lease               | Managing the loan or lease               | NA        | NA                           | NA                      | Asset Management Outsourcing, Inc. | NY         | 11030    | NA                            | N/A                       | Web           | 2013-07-31 | Closed with explanation         | Yes             | No                |       469606 |
| 2013-07-30    | Bank account or service | Checking account            | Using a debit or ATM card                | NA        | NA                           | NA                      | JPMorgan Chase & Co.               | NY         | 11772    | NA                            | N/A                       | Web           | 2013-08-01 | Closed with explanation         | Yes             | No                |       472678 |

Displaying records 1 - 10

### Extract the complaints received in the state of New York and California.

``` sql

SELECT * FROM
consumer_complaints
WHERE
state_name IN ("NY", "CA")
```

| date_received | product_name            | sub_product                 | issue                                    | sub_issue                             | consumer_complaint_narrative | company_public_response | company               | state_name | zip_code | tags           | consumer_consent_provided | submitted_via | date_sent  | company_response_to_consumer    | timely_response | consumer_disputed | complaint_id |
|:--------------|:------------------------|:----------------------------|:-----------------------------------------|:--------------------------------------|:-----------------------------|:------------------------|:----------------------|:-----------|:---------|:---------------|:--------------------------|:--------------|:-----------|:--------------------------------|:----------------|:------------------|-------------:|
| 2013-07-29    | Bank account or service | Checking account            | Using a debit or ATM card                | NA                                    | NA                           | NA                      | Wells Fargo & Company | CA         | 95992    | Older American | N/A                       | Web           | 2013-07-31 | Closed with explanation         | Yes             | No                |       468889 |
| 2013-07-29    | Bank account or service | Checking account            | Account opening, closing, or management  | NA                                    | NA                           | NA                      | Santander Bank US     | NY         | 10065    | NA             | N/A                       | Fax           | 2013-07-31 | Closed                          | Yes             | No                |       468879 |
| 2013-07-29    | Mortgage                | Other mortgage              | Loan servicing, payments, escrow account | NA                                    | NA                           | NA                      | JPMorgan Chase & Co.  | CA         | 90703    | NA             | N/A                       | Referral      | 2013-07-30 | Closed with explanation         | Yes             | No                |       469284 |
| 2013-07-29    | Mortgage                | Other mortgage              | Loan modification,collection,foreclosure | NA                                    | NA                           | NA                      | Citibank              | CA         | 95821    | NA             | N/A                       | Referral      | 2013-07-31 | Closed with explanation         | Yes             | Yes               |       480488 |
| 2013-07-29    | Mortgage                | Conventional fixed mortgage | Loan modification,collection,foreclosure | NA                                    | NA                           | NA                      | JPMorgan Chase & Co.  | NY         | 14092    | NA             | N/A                       | Phone         | 2013-07-31 | Closed with explanation         | Yes             | No                |       469057 |
| 2013-07-29    | Mortgage                | Conventional fixed mortgage | Loan modification,collection,foreclosure | NA                                    | NA                           | NA                      | JPMorgan Chase & Co.  | NY         | 10019    | NA             | N/A                       | Web           | 2013-07-30 | Closed with explanation         | Yes             | Yes               |       469070 |
| 2013-07-29    | Credit reporting        | NA                          | Credit monitoring or identity protection | Problem cancelling or closing account | NA                           | NA                      | Experian              | CA         | 90034    | NA             | N/A                       | Web           | 2013-07-29 | Closed with monetary relief     | Yes             | No                |       474204 |
| 2013-07-29    | Mortgage                | Conventional fixed mortgage | Application, originator, mortgage broker | NA                                    | NA                           | NA                      | Wells Fargo & Company | NY         | 10605    | NA             | N/A                       | Web           | 2013-07-31 | Closed with non-monetary relief | Yes             | No                |       480173 |
| 2013-07-29    | Mortgage                | Other mortgage              | Loan modification,collection,foreclosure | NA                                    | NA                           | NA                      | Ocwen                 | NY         | 14467    | NA             | N/A                       | Referral      | 2013-07-30 | Closed with explanation         | Yes             | Yes               |       469360 |
| 2013-07-29    | Mortgage                | Other mortgage              | Loan servicing, payments, escrow account | NA                                    | NA                           | NA                      | U.S. Bancorp          | CA         | 92591    | NA             | N/A                       | Referral      | 2013-07-31 | Closed with monetary relief     | Yes             | No                |       469632 |

Displaying records 1 - 10

### Extract all the rows with the word “Credit” in the product field.

``` sql

SELECT * FROM 
consumer_complaints 
WHERE 
product_name 
LIKE 
"%Credit%"
```

| date_received | product_name     | sub_product | issue                                    | sub_issue                             | consumer_complaint_narrative | company_public_response | company                                             | state_name | zip_code | tags           | consumer_consent_provided | submitted_via | date_sent  | company_response_to_consumer    | timely_response | consumer_disputed | complaint_id |
|:--------------|:-----------------|:------------|:-----------------------------------------|:--------------------------------------|:-----------------------------|:------------------------|:----------------------------------------------------|:-----------|:---------|:---------------|:--------------------------|:--------------|:-----------|:--------------------------------|:----------------|:------------------|-------------:|
| 2013-07-29    | Credit card      | NA          | Billing statement                        | NA                                    | NA                           | NA                      | Citibank                                            | OH         | 45247    | NA             | N/A                       | Referral      | 2013-07-30 | Closed with explanation         | Yes             | Yes               |       469026 |
| 2013-07-29    | Credit card      | NA          | APR or interest rate                     | NA                                    | NA                           | NA                      | Synchrony Financial                                 | WA         | 98548    | NA             | N/A                       | Web           | 2013-07-29 | Closed with monetary relief     | Yes             | No                |       469131 |
| 2013-07-29    | Credit reporting | NA          | Credit monitoring or identity protection | Problem cancelling or closing account | NA                           | NA                      | Experian                                            | CA         | 90034    | NA             | N/A                       | Web           | 2013-07-29 | Closed with monetary relief     | Yes             | No                |       474204 |
| 2013-07-29    | Credit reporting | NA          | Incorrect information on credit report   | Public record                         | NA                           | NA                      | Equifax                                             | CA         | 91605    | NA             | N/A                       | Web           | 2013-07-29 | Closed with non-monetary relief | Yes             | No                |       469201 |
| 2013-07-29    | Credit card      | NA          | Delinquent account                       | NA                                    | NA                           | NA                      | Amex                                                | TX         | 78232    | NA             | N/A                       | Web           | 2013-07-29 | Closed with monetary relief     | Yes             | No                |       479990 |
| 2013-07-29    | Credit reporting | NA          | Improper use of my credit report         | Report improperly shared by CRC       | NA                           | NA                      | Equifax                                             | MO         | 64725    | NA             | N/A                       | Fax           | 2013-07-29 | Closed with explanation         | Yes             | No                |       479282 |
| 2013-07-29    | Credit card      | NA          | Billing disputes                         | NA                                    | NA                           | NA                      | Capital One                                         | FL         | 32226    | Servicemember  | N/A                       | Web           | 2013-07-29 | Closed with explanation         | Yes             | No                |       475777 |
| 2013-07-29    | Credit card      | NA          | Credit line increase/decrease            | NA                                    | NA                           | NA                      | Citibank                                            | WI         | 53066    | Older American | N/A                       | Phone         | 2013-07-30 | Closed with explanation         | Yes             | Yes               |       469473 |
| 2013-07-29    | Credit reporting | NA          | Incorrect information on credit report   | Information is not mine               | NA                           | NA                      | Fidelity National Information Services, Inc. (FNIS) | CT         | 6514     | NA             | N/A                       | Referral      | 2013-08-21 | Closed with explanation         | Yes             | No                |       469507 |
| 2013-07-30    | Credit card      | NA          | Payoff process                           | NA                                    | NA                           | NA                      | Wells Fargo & Company                               | NV         | 89108    | Servicemember  | N/A                       | Phone         | 2013-08-02 | Closed with explanation         | Yes             | No                |       470828 |

Displaying records 1 - 10

### Extract all the rows with the word “Late” in the issue field.

``` sql

SELECT * FROM 
consumer_complaints 
WHERE 
issue 
LIKE 
"%Late%"
```

| date_received | product_name | sub_product | issue    | sub_issue | consumer_complaint_narrative | company_public_response | company                        | state_name | zip_code | tags           | consumer_consent_provided | submitted_via | date_sent  | company_response_to_consumer | timely_response | consumer_disputed | complaint_id |
|:--------------|:-------------|:------------|:---------|:----------|:-----------------------------|:------------------------|:-------------------------------|:-----------|:---------|:---------------|:--------------------------|:--------------|:-----------|:-----------------------------|:----------------|:------------------|-------------:|
| 2013-07-31    | Credit card  | NA          | Late fee | NA        | NA                           | NA                      | JPMorgan Chase & Co.           | IL         | 60201    | NA             | N/A                       | Web           | 2013-07-31 | Closed with monetary relief  | Yes             | No                |       471204 |
| 2013-07-23    | Credit card  | NA          | Late fee | NA        | NA                           | NA                      | Capital One                    | AR         | 72015    | NA             | N/A                       | Web           | 2013-07-23 | Closed with monetary relief  | Yes             | No                |       463829 |
| 2013-08-07    | Credit card  | NA          | Late fee | NA        | NA                           | NA                      | Citibank                       | CA         | 94523    | NA             | N/A                       | Web           | 2013-08-07 | Closed with monetary relief  | Yes             | No                |       488956 |
| 2013-08-14    | Credit card  | NA          | Late fee | NA        | NA                           | NA                      | Citibank                       | TX         | 75024    | NA             | N/A                       | Web           | 2013-08-14 | Closed with monetary relief  | Yes             | No                |       492046 |
| 2013-08-14    | Credit card  | NA          | Late fee | NA        | NA                           | NA                      | Bank of America                | NY         | 10024    | NA             | N/A                       | Web           | 2013-08-20 | Closed with monetary relief  | Yes             | No                |       492446 |
| 2013-08-02    | Credit card  | NA          | Late fee | NA        | NA                           | NA                      | Citibank                       | MN         | 55403    | NA             | N/A                       | Web           | 2013-08-02 | Closed with monetary relief  | Yes             | No                |       472706 |
| 2013-08-05    | Credit card  | NA          | Late fee | NA        | NA                           | NA                      | Amex                           | MA         | 2138     | Older American | N/A                       | Web           | 2013-08-05 | Closed with monetary relief  | Yes             | No                |       473736 |
| 2013-08-05    | Credit card  | NA          | Late fee | NA        | NA                           | NA                      | Citibank                       | OK         | 73112    | Older American | N/A                       | Phone         | 2013-08-07 | Closed with monetary relief  | Yes             | No                |       473865 |
| 2013-08-22    | Credit card  | NA          | Late fee | NA        | NA                           | NA                      | Citizens Financial Group, Inc. | CA         | 91342    | NA             | N/A                       | Referral      | 2013-08-23 | Closed with monetary relief  | Yes             | No                |       501140 |
| 2013-08-02    | Credit card  | NA          | Late fee | NA        | NA                           | NA                      | Synchrony Financial            | IL         | 62951    | NA             | N/A                       | Web           | 2013-08-02 | Closed with monetary relief  | Yes             | No                |       473190 |

Displaying records 1 - 10
