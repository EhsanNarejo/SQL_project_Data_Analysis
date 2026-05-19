/*
Problem Statement
Identify companies with the most diverse (unique) job titles. Use a CTE to count the number of unique job titles per company,
 then select companies with the highest diversity in job titles.

Hint
Use a CTE to count the distinct number of job titles for each company.
After identifying the number of unique job titles per company, join this result with the company_dim table
 to get the company names.
Order your final results by the number of unique job titles in descending order to highlight 
the companies with the highest diversity.
Limit your results to the top 10 companies. This limit helps focus on the companies with the most significant diversity
 in job roles. Think about how SQL determines which companies make it into the top 10 when there are ties
  in the number of unique job titles. */

/*WITH title_diversity AS (
    SELECT 
        company_id,
        COUNT(DISTINCT job_title) AS unique_job_titles
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT
    company_dim.name,
    title_diversity.unique_job_titles
FROM
    title_diversity
JOIN company_dim ON title_diversity.company_id = company_dim.company_id
ORDER BY title_diversity.unique_job_titles DESC
LIMIT 10; 
Explanation
Create a CTE called title_diversityto:
Count unique job titles per company (COUNT(DISTINCT job_title)
From job_postings_fact
Grouping the results by company_id
In the main query:
In SELECT statement get the company names (name) and their corresponding counts of unique job titles from the CTE
Get data from the CTE title_diversity
INNER JOIN the CTE with company_dim on company_id to match each company's unique titles count with its name
ORDER BY companies by descending uniqueness of job titles
LIMIT by the top 10*/

/* PROBLEM 2

WITH 
    avg_salaries AS(
        SELECT
            job_country,
            AVG(salary_year_avg) AS avg_salary
        FROM job_postings_fact
        GROUP BY job_country
    )
SELECT
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    companies.name AS company_name,
    job_postings_fact.salary_year_avg AS salary_rate,
    CASE
        WHEN job_postings_fact.salary_year_avg > avg_salaries.avg_salary THEN 'Above Average'
        WHEN job_postings_fact.salary_year_avg < avg_salaries.avg_salary THEN 'Below Average'
        ELSE 'Average'
    END AS salary_category,
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date) AS posting_month
FROM job_postings_fact
INNER JOIN company_dim AS companies ON job_postings_fact.company_id = companies.company_id
INNER JOIN avg_salaries ON job_postings_fact.job_country = avg_salaries.job_country
ORDER BY
    posting_month DESC;


Explanation
Create a CTE named avg_salaries
Calculate the average yearly salary (AVG(salary_year_avg)) for each country (job_country)
From the job_postings_fact table
Grouping the results by job_country
In the main query:
Select:
the job_id, job_title, and company name (companies.name)
 to get the basic job posting information.
Retrieve the salary (salary_year_avg) for each job
 posting and label it as salary_rate.
Categorize each salary as 'Above Average' or 'Below Average' 
by comparing the individual salary rate to the average salary of 
the corresponding country obtained from the avg_salaries CTE 
(job_postings.salary_year_avg > avg_salaries.avg_salary)
Extract the month from the job posting date (job_posted_date) to 
include in your results as posting_month.
INNER JOIN the job_postings_fact table with the company_dim table to 
link each job posting with the respective company name.
INNER JOIN the avg_salaries CTE to bring in the average salary data for comparison.
Order the results by the posting_month in descending order to 
sort the job postings starting with the most recent. */ 


-- Counts the distinct skills required for each company's job posting
WITH required_skills AS (
    SELECT
        company_dim.company_id,
        COUNT(DISTINCT skills_job_dim.skill_id) AS unique_skills_required
    FROM
        company_dim
    LEFT JOIN job_postings_fact
        ON company_dim.company_id = job_postings_fact.company_id
    LEFT JOIN skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
    GROUP BY
        company_dim.company_id
),
-- Gets the highest average yearly salary from the jobs that require at least one skills 
max_salary AS(
    SELECT
        company_id,
        MAX(salary_year_avg) AS highest_average_salary
    FROM
        job_postings_fact
    WHERE
        job_id IN (SELECT job_id FROM skills_job_dim)
    GROUP BY company_id
)
SELECT
    company_dim.name,
    required_skills.unique_skills_required,
    max_salary.highest_average_salary
FROM
    company_dim
LEFT JOIN required_skills
    ON company_dim.company_id = required_skills.company_id
LEFT JOIN max_salary
    ON company_dim.company_id = max_salary.company_id
ORDER BY
    company_dim.name