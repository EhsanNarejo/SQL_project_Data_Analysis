# Introduction

Welcome to my SQL Portfolio Project, where I explore the data job market with a focus on Data Analyst roles. This project investigates top-paying jobs, in-demand skills, and the relationship between skill demand and salary in the field of data analytics.

You can view the SQL queries used in this project here: [project_sql_folder](/project_sql/)

# Background

The goal of this project was to better understand the Data Analyst job market by identifying which skills are both highly demanded and associated with higher salaries. The analysis is designed to support more targeted, data-driven decisions for skill development and job searching.

The dataset used is from Luke Barousse’s SQL for Data Analytics course:
https://www.lukebarousse.com/sql

**Key Questions** 

- What are the highest-paying Data Analyst jobs?
- What skills are required for high-paying roles?
- What are the most in-demand skills for remote Data Analyst roles?
- Which skills are associated with higher salaries?
- Which skills are both high in demand and high paying?h in demand and high paying for Data Analyst roles?

# Tools I Used

In this project, I utilized a variety of tools to conduct my analysis:

- **SQL** (Structured Query Language): Enabled me to interact with the database, extract insights, and answer my key questions through queries.
- **PostgreSQL**: As the database management system, PostgreSQL allowed me to store, query, and manipulate the job posting data.
- **Visual Studio Code:** This open-source administration and development platform helped me manage the database and execute SQL queries.

# The Analysis

Each query in this project explores a different aspect of the Data Analyst job market, focusing on salary trends, skill requirements, and market demand in remote roles.

### 1. Top Paying Data Analyst Jobs

To identify the highest-paying Data Analyst roles, I filtered job postings with specified salaries and focused on remote or flexible (“Anywhere”) positions. This query highlights the top-paying opportunities available in the dataset.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    company_dim.name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim 
    ON job_postings_fact.company_id = company_dim.company_id
WHERE job_title_short = 'Data Analyst'
    AND (job_location = 'Australia' OR job_location = 'Anywhere')
    AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 20;
```
### Insights

The highest-paying Data Analyst roles are predominantly remote or listed as “Anywhere,” showing a strong presence of flexible work opportunities in top salary bands. Salaries vary significantly, with several roles offering well above-average compensation and one extreme outlier pushing the upper limit of the dataset. Overall, the highest-paying positions are mostly associated with senior-level analyst and analytics leadership roles.

### 2. Skills for Top Paying Jobs

To understand which skills are required for high-paying roles, I selected the top 10 highest-paying Data Analyst jobs and joined them with the skills dataset.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        company_dim.name AS company_name
    FROM job_postings_fact
    LEFT JOIN company_dim 
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE job_title_short = 'Data Analyst'
        AND (job_location = 'Australia' OR job_location = 'Anywhere')
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT
    top_paying_jobs.*,
    skills_dim.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim 
    ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```
### Insights

The highest-paying Data Analyst roles consistently require a combination of core technical skills such as SQL and Python, alongside strong data manipulation and analysis libraries like Pandas and NumPy. In addition, most top-paying positions demand experience with BI tools (Tableau, Power BI) and cloud/data platforms such as AWS, Azure, Snowflake, and Databricks. Overall, the results show that high salaries are associated with a well-rounded skill set spanning programming, data engineering tools, and modern cloud-based analytics technologies.

### 3. Most In-Demand Skills for Data Analysts

This query identifies the most frequently requested skills in Data Analyst job postings. It focuses on remote or flexible roles to highlight current market demand.

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
```
### Insights

Most in-demand skills for Data Analyst roles are led by SQL, which appears as the dominant requirement across remote job postings, highlighting its importance for data querying and management. Excel remains a core foundational tool, followed closely by Python for data analysis and automation. BI tools such as Tableau and Power BI also feature strongly, showing that employers value both technical analysis skills and data visualization capabilities in modern analytics roles.

### 4. Skills Based on Salary

This query explores which skills are associated with higher average salaries for Data Analyst roles, focusing on remote positions with valid salary data.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25;
```
### Insights
Skills associated with higher average salaries in Data Analyst roles are strongly aligned with big data and engineering-focused tools, with PySpark, Databricks, and cloud-related technologies leading the list. Programming and data processing libraries such as Pandas and NumPy also appear in higher-paying roles, reflecting the value of advanced data manipulation skills. Overall, the results suggest that analysts who combine traditional analytics skills with big data, cloud, and engineering tools tend to earn significantly higher salaries.


### 5. Most Optimal Skills to Learn

This query combines both demand and salary insights to identify skills that are frequently requested and also associated with higher salaries in remote Data Analyst roles.

```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim 
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
        AND job_work_from_home = TRUE
    GROUP BY skills_dim.skill_id, skills_dim.skills
),
average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        AVG(job_postings_fact.salary_year_avg) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim 
        ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY skills_job_dim.skill_id
)
SELECT
    skills_demand.skills,
    skills_demand.demand_count,
    ROUND(average_salary.avg_salary, 2) AS avg_salary
FROM skills_demand
INNER JOIN average_salary 
    ON skills_demand.skill_id = average_salary.skill_id
ORDER BY demand_count DESC, avg_salary DESC
LIMIT 10;
```
### Insights

The most optimal skills for Data Analyst roles are those that balance both high demand and strong salary potential. Core tools such as SQL, Excel, Python, Tableau, and Power BI consistently appear as the most valuable, indicating they are essential for breaking into the field. At the same time, cloud platforms and BI tools like Azure and Looker offer higher earning potential, showing that combining foundational analytics skills with modern data platforms leads to the best career outcomes.


Each query not only served to answer a specific question but also to improve my understanding of SQL and database analysis. Through this project, I learned to leverage SQL's powerful data manipulation capabilities to derive meaningful insights from complex datasets.

# What I Learned

Throughout this project, I strengthened several key SQL and analytical skills:

- **Complex Query Construction**: Built advanced SQL queries using multiple table joins and CTEs (WITH clauses) to structure and simplify analysis.
- **Data Aggregation**: Used GROUP BY along with aggregate functions such as COUNT() and AVG() to summarise and interpret large datasets effectively.
- **Analytical Thinking**: Improved the ability to translate real-world questions into structured SQL queries and extract meaningful, data-driven insights from job market data.


# Conclusion

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.

### Closing Thought

Got it — your current closing thought is too “analysis summary” and not enough **personal reflection on the project experience**, which is what that section is supposed to be.

Here’s a corrected **README-ready Closing Thought** that matches your intent:

---

## Closing Thought

This project gave me hands-on experience applying SQL to a real-world dataset and helped me understand how data analysis is used to extract meaningful insights from job market trends. It also strengthened my confidence in writing structured queries and thinking analytically. Overall, it was a valuable learning experience that reinforced what I’ve studied in the course and showed me how SQL can be used to support real career and decision-making insights in data analytics.



