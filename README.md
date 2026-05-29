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

- The highest-paying Data Analyst roles are not limited to traditional analyst positions. Instead, the top salaries are dominated by senior and specialised roles such as Analytics Engineer, Director, and Principal Data Analyst.

- Companies like Netflix, Meta, and Atlassian appear frequently at the top end, showing that large tech firms drive most high-compensation roles. While a standard Data Analyst title does appear at the top, it is likely an outlier, with most salaries clustering in the ~$180K–$450K range.

- Overall, the data shows that seniority and specialization matter more than the job title itself when it comes to salary.

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

- The highest-paying Data Analyst roles require a mix of core analytics skills and advanced engineering tools. SQL and Python appear consistently across almost all roles, forming the foundation of high-paying analytics work.

- As salaries increase, the skill set expands into cloud and engineering technologies such as AWS, Databricks, Spark, Kubernetes, and Scala, especially in companies like Netflix and AT&T. Traditional BI tools like Tableau and Power BI still appear but are no longer the main differentiator.

- Overall, the data shows that the highest salaries are linked to hybrid roles that combine data analysis with software engineering and cloud infrastructure skills.


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

- SQL is the most in-demand skill by a wide margin, making it the core requirement for Data Analyst roles. Python follows as the key programming language for analysis and automation, while Excel remains a strong baseline skill expected in most roles.

- Visualization tools like Tableau and Power BI also rank highly, showing that employers expect analysts to not only work with data but also communicate insights effectively.

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
- Higher salaries for Data Analyst roles are strongly linked to big data and engineering-heavy skills. Technologies like PySpark, Scala, Databricks, and Kubernetes stand out, showing that distributed data processing and cloud environments are key drivers of higher pay.

- Interestingly, several software engineering tools and languages (like Go, C, and TypeScript) also appear, suggesting that the highest-paying “data analyst” roles often overlap with data engineering or analytics engineering responsibilities.

- Overall, the trend is clear: moving beyond traditional analytics tools into engineering and cloud ecosystems significantly increases earning potential.


### 5. Most Optimal Skills to Learn

This query combines both demand and salary insights to identify skills that are frequently requested and also associated with higher salaries in remote Data Analyst roles.

```sql
SELECT skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL -- AND job_work_from_home = True 
GROUP BY skills_dim.skill_id
HAVING COUNT(skills_job_dim.job_id) > 10
ORDER BY demand_count DESC,
    -- move demand_count to be first in the ORDER BY
    avg_salary DESC
LIMIT 25;nd_count DESC, avg_salary DESC
LIMIT 10;
```
### Insights

- The most valuable skills are those that balance both high demand and strong salary outcomes. Core tools like SQL, Python, Excel, Tableau, and Power BI remain essential for most Data Analyst roles and form the baseline for employability.

- Higher-paying opportunities appear when these core skills are combined with cloud and big data technologies such as AWS, Azure, Snowflake, Spark, and Databricks. BI tools like Looker also show strong salary potential compared to traditional reporting tools.

- Overall, the best career strategy is to build a strong foundation in core analytics tools, then layer in cloud and big data skills to maximize both demand and salary potential.



Each query not only served to answer a specific question but also to improve my understanding of SQL and database analysis. Through this project, I learned to leverage SQL's powerful data manipulation capabilities to derive meaningful insights from complex datasets.

# What I Learned

Throughout this project, I strengthened several key SQL and analytical skills:

- **Complex Query Construction**: Built advanced SQL queries using multiple table joins and CTEs (WITH clauses) to structure and simplify analysis.
- **Data Aggregation**: Used GROUP BY along with aggregate functions such as COUNT() and AVG() to summarise and interpret large datasets effectively.
- **Analytical Thinking**: Improved the ability to translate real-world questions into structured SQL queries and extract meaningful, data-driven insights from job market data.


# Conclusion

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.

## Closing Thought

This project gave me hands-on experience applying SQL to a real-world dataset and helped me understand how data analysis is used to extract meaningful insights from job market trends. It also strengthened my confidence in writing structured queries and thinking analytically. Overall, it was a valuable learning experience that reinforced what I’ve studied in the course and showed me how SQL can be used to support real career and decision-making insights in data analytics.



