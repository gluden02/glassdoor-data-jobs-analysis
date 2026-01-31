# Data Cleaning and Exploratory Data Analysis of Job Offers (Glassdoor Dataset)

## 📌 Project Overview

This project focuses on **data cleaning, transformation, and exploratory data analysis (EDA)** of job postings from Glassdoor, with a particular emphasis on **Data Analytics, Data Science, and Data Engineering roles**.

The analysis was conducted primarily using **SQL**, followed by the development of an **interactive Power BI dashboard** to visualize key insights related to job demand, salaries, companies, and industries.

---

## 🗂 Dataset

* **Source:** Glassdoor Job Postings Dataset (Kaggle)
* **Raw file:** `Uncleaned_DS_jobs.csv`
* **Link:** [https://www.kaggle.com/datasets/rashikrahmanpritom/data-science-job-posting-on-glassdoor](https://www.kaggle.com/datasets/rashikrahmanpritom/data-science-job-posting-on-glassdoor)

The dataset contains job-level information such as:

* Job title and description
* Salary estimates
* Company ratings
* Company size, industry, sector, and revenue
* Location and headquarters

---

## 🛠 Tools & Technologies

* **SQL (MySQL)** – Data ingestion, cleaning, transformation, and EDA
* **Power BI** – Data visualization and dashboard creation
* **GitHub** – Version control and project documentation

---

## 🧹 Data Cleaning Process (SQL)

The data cleaning pipeline was fully implemented in SQL and includes:

### 1. Data Ingestion

* Table creation and data loading using `LOAD DATA INFILE`
* Creation of a backup table to preserve raw data integrity

### 2. Duplicate Removal

* Identification of duplicate records using `ROW_NUMBER()` window functions
* Removal of duplicates based on all relevant job and company attributes

### 3. Data Standardization

* Job title normalization (e.g., grouping variations into:

  * Data Analyst
  * Data Scientist
  * Data Engineer
  * Machine Learning Engineer
  * Computer Scientist)
* Seniority levels were removed due to inconsistent availability across postings
* Standardization of company headquarters and company size categories
* Conversion of invalid ratings (e.g., `-1`) to `NULL`

### 4. Handling Missing and Inconsistent Values

* Removal of records with multiple critical missing fields
* Replacement of invalid placeholders with meaningful values (e.g., `Unknown`)

### 5. Structural Transformations

* Removal of irrelevant columns (e.g., `competitors`)
* Parsing of salary ranges from text into numerical fields:

  * `min_salary(K)`
  * `max_salary(K)`

The final cleaned dataset is stored in the table **`jobs_clean2`**.

---

## 🔍 Exploratory Data Analysis (EDA)

EDA was performed using SQL queries with **CTEs, aggregations, GROUP BY, and UNION operations** to answer key questions such as:

* Which data-related jobs are the most demanded?
* Which roles offer the highest average salaries?
* Which companies provide the best compensation?
* How do company size and industry affect job availability and pay?
* Which industries demand Data Scientists the most?

---

## 📊 Power BI Dashboard

An interactive **Power BI dashboard** is included in this repository to visually communicate the insights obtained from SQL analysis.

### Dashboard Highlights:

* Job demand by data role
* Average minimum and maximum salaries per role
* Top-paying companies
* Company rating vs number of job offers
* Job offers by company size and industry

**File:** `Data_Jobs_Market_Analysis.pbix`

---

## 📁 Repository Structure

```
├── sql/
│   ├── data_cleaning.sql
│   └── exploratory_analysis.sql
├── power_bi/
│   └── Data_Jobs_Market_Analysis.pbix
├── data/
│   └── Uncleaned_DS_jobs.csv
└── README.md
```

---

## 🚀 Key Takeaways

* Data Scientist role dominate job demand
* Seniority information is often inconsistent in job postings
* Industry and sector play a significant role in demand distribution

---

## 📎 Notes

This project was developed as part of a **data analytics portfolio**, with a strong focus on SQL-based data processing and business-oriented insights.

Feel free to explore, fork, or provide feedback!