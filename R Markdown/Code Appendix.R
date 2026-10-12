## MASTER CODE APPENDIX

Complete, working, copy-paste-ready R code blocks from class, labeled by topic and lecture:
  
  ### 1\. Vector Creation &amp; Subsetting (Class 03, Class 04)[120]
  
  ```
library(dplyr)

crashes_by_day = c(2020, 2241, 2327, 2285, 2380, 1866, 1664) [27]
names(crashes_by_day) = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun") [27]

# Subsetting operations [29, 30]
high_days = crashes_by_day[crashes_by_day &gt; 2000] [29]
total_high = sum(crashes_by_day &gt; 2300) [29, 31]
subset_pos = crashes_by_day[c(2, 4)] [29]
subset_name = crashes_by_day["Sat"] [29]

```

### 2\. List Navigation &amp; Pathing (Class 04)[9]

```
job = list(
  title = "Research Data Scientist, Magic Eye",
  company = "Google",
  salary = list(min = 147000, max = 210000)
) [33]

# Navigating nested lists [32, 36]
company_name = job$company [36]
max_salary_1 = job$salary$max [36]
max_salary_2 = job[["salary"]][["max"]] [36]

```

### 3\. Importing CSV, Excel &amp; JSON Data (Class 04, Class 05)[5]

```
library(readr)
library(readxl)
library(jsonlite)

# CSV Import with relative path [6, 7, 10]
crashes_df = readr::read_csv("../data/cincy_crashes.csv") [6, 7]

# Excel Import skipping title row [7, 15]
occupation_df = readxl::read_excel(
  "../data/occupation.xlsx", 
  sheet = "Table 1.4", 
  skip = 1, 
  n_max = 31
) [7, 15]

# Web-served JSON Import [8, 9]
campus_list = jsonlite::fromJSON("https://isa401-find-your-seat.vercel.app/campus.json") [9, 63]

```

### 4\. SQLite Database Querying (Class 06)[12][40]

```
library(DBI)
library(RSQLite)
library(dplyr)

# Connect to database file [12, 44]
con = DBI::dbConnect(RSQLite::SQLite(), "../data/scout.db") [12, 44]

# Read entire table into R tibble [12, 44]
postings = DBI::dbReadTable(con, "scout_postings") |&gt; dplyr::as_tibble() [12, 96]

# Execute direct SQL query [12]
sql_res = DBI::dbGetQuery(con, "SELECT company, COUNT(*) as n FROM scout_postings GROUP BY company ORDER BY n DESC LIMIT 5") [12]

DBI::dbDisconnect(con)

```

### 5\. `dplyr` Data Wrangling Pipeline (Class 07)[87][92]

```
library(dplyr)

# Full data wrangling pipeline [95, 100]
analysis_results = postings |&gt; 
dplyr::mutate(
  role = dplyr::case_when(
    grepl("scientist", title, [suspicious link removed] = TRUE) ~ "Data Scientist",
    grepl("engineer", title, [suspicious link removed] = TRUE) ~ "Data Engineer",
    grepl("analyst", title, [suspicious link removed] = TRUE) ~ "Analyst",
    TRUE ~ "Other"
  )
) |&gt; 
dplyr::group_by(role) |&gt; 
dplyr::summarize(
  total_jobs = dplyr::n(),
  remote_share = round(mean(remote), 3)
) |&gt; 
dplyr::filter(total_jobs &gt;= 10) |&gt; 
dplyr::arrange(dplyr::desc(remote_share)) [95, 100]

```

### 6\. `httr2` API Request Pipeline (Class 08, Class 09)[19]

```
library(httr2)
library(jsonlite)

# FRED API Request [19, 69, 70]
fred_df = httr2::request("[suspicious link removed]") |&gt; 
httr2::req_url_query(
  series_id = "IHLIDXUSOH",
  api_key = Sys.getenv("FRED_API_KEY"),
  file_type = "json"
) |&gt; 
httr2::req_perform() |&gt; 
httr2::resp_body_string() |&gt; 
jsonlite::fromJSON() |&gt; 
{{\(x) x$observations}}() |&gt; 
dplyr::as_tibble() [19, 69-71]

```

### 7\. Web Scraping &amp; Multi-Page Loop (Class 10, Class 11)[55]

```
library(rvest)
library(robotstxt)
library(dplyr)

# Verify permission [60, 61]
robotstxt::paths_allowed("https://bulletin.miamioh.edu/courses-instruction/isa/") [60, 61]

# Scrape single page [76-79]
page_html = rvest::read_html("https://bulletin.miamioh.edu/courses-instruction/isa/") [76, 79]

titles = page_html |&gt; 
rvest::html_elements("div.courseblock p.courseblocktitle") |&gt; 
rvest::html_text2() [57, 78, 82]

descriptions = page_html |&gt; 
rvest::html_elements("div.courseblock p.courseblockdesc") |&gt; 
rvest::html_text2() [57, 78, 82]

courses_df = tibble::tibble(title = titles, description = descriptions) [83]

```

### 8\. `ellmer` Structured Text Extraction (Class 12, Class 13)[45]

```
library(ellmer)
library(rvest)

# Initialize chat with restricted class model [105, 106]
chat = ellmer::chat_openai(
  model = "gpt-5.6-luna",
  params = ellmer::params(reasoning_effort = "none")
) [105, 106]

# Extract course block text [82, 105]
raw_text = rvest::read_html("https://bulletin.miamioh.edu/courses-instruction/isa/") |&gt; 
rvest::html_element("#sc_sccoursedescs &gt; div:nth-child(1)") |&gt; 
rvest::html_text2() [82, 105]

# Define schema [103-105]
schema = ellmer::type_object(
  name = ellmer::type_string("Name of the course without code"), [103, 105]
  description = ellmer::type_string("Description without prereqs"), [103, 105]
  prereqs = ellmer::type_string("Prerequisite details", required = FALSE) [104, 105]
)

# Extract structured output [102, 105, 111]
extracted_list = chat$chat_structured(raw_text, type = schema) [102, 105, 111]
```