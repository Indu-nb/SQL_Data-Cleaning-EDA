# SQL_Data-Cleaning-EDA
Showcases data pre-processing and EDA use case through SQL

This dataset contains layoff data from period Mar2020 to Mar 2023. It has the follwing parameters: company, industry, location, industry, stage, funds raised (in millions), total laid off, percentage laid off. Each of these parameters have 2361 entries against them.

Before doing exploratory data analysis or EDA to get meaningful insights, the data was cleaned.
Steps in Data Preprocessing: Creating duplicate table to ensure original data doesn't get corrupted or altered, Identifying and removing duplicates; standardizing data by identifying and removing white spaces, alternative spellings, format issues; identify null entries and attempt to repopulate, remove columns not required
SQL Functions: CTE Creation, OVER, PARTITION BY, JOIN, UPDATE, DELETE, TRIM, DATE, ROW_NUMBER, TRIM(TRAILING().

Exploratory Data used Min, Max, Avg and explored timelines. 
SQL Functions used are CTEs, SUBSTRING, DENSE_RANK, OVER, PARTITION BY, MONTH, YEAR, ORDER BY, GROUP BY

Exploratory Data Analysis helped us with the below questions:
1. What is the period of this data collection?
Ans. Mar 2020 to March 2023 (3 Years)

2. Who are the highest contributors to layoff (magnitude and percentage wise) per each instance?
Ans. Google has the highest total layoff in single instance (12000) in 2023. 116 companies had 100% laid off in this period

3. Which company had the highest layoff in the entire period in terms of magnitude?
Ans. Amazon

4. Which industry had the highest / lowest layoff in the entire period in terms of average percentage of layoff?
Ans. Aerospace is highest with 56.5% and Manufacturing is lowest with 0.05%.

5. Which industry had the highest / lowest layoff in the entire period in terms of magnitude?
Ans. USA followed by India had highest layoff in entire period. Poland has lowest layoff (as per available records)

6. Which year had highest layoff in this period?
Ans. 2022 had high layoff, however 2023 with data till Mar alone, is very close to 2022 levels and might have broken the record. 2021 had the lowest layoff- this might be due to post-COVID recovery.

7. Which company funding stage is associated with high layoffs?
Ans. Post-IPO since established companies have contributed highly to layoffs

8. Constructing a rolling table, establish the period with high layoffs:
Ans. Generally 2021 had low layoffs. Oct'22 to Feb'23 had the highest continuous layoffs, followed by May'22-Aug'22.

9. What are the top companies responsible for layoffs for each year in this period- using a CTE that has top 5 layoff contributor by year and rank?
Ans. Uber (2020), Bytedance (2021), Meta (2022) and Google (2023) are the top contributors to layoff each year of the time period of data.


11.
