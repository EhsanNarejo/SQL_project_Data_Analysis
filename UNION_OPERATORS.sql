/*Combine result sets of two or more `SELECT` statements into a single result set. 
 
 - `UNION`: Remove duplicate rows
 - `UNION ALL`: Includes all duplicate rows
 
 ⚠️Note: Each `SELECT` statement within the `UNION` must have the same number of columns in the result sets with similar data types.
 
 ---
 
 ## 🤝`UNION`
 
 📝 **Notes:**
 
 - `UNION` - combines results from two or more `SELECT` statements
 - They need to have the same amount of columns, and the data type must match
 
 ```sql
 SELECT column_name
 FROM table_one
 
 UNION -- combine the two tables 
 
 SELECT column_name
 FROM table_two;
 ```
 
 - Gets rid of duplicate rows (unlike `UNION ALL` )
 - All rows are unique */
/*
 (
 SELECT 
 job_id, 
 job_title, 
 'With Salary Info' AS salary_info  -- Custom field indicating salary info presence
 FROM 
 job_postings_fact
 WHERE 
 salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL  
 )
 UNION ALL
 -- Select job postings without salary information
 (
 SELECT 
 job_id, 
 job_title, 
 'Without Salary Info' AS salary_info  -- Custom field indicating absence of salary info
 FROM 
 job_postings_fact
 WHERE 
 salary_year_avg IS NULL AND salary_hour_avg IS NULL 
 )
 ORDER BY 
 salary_info desc, 
 job_id; 
 
 Explanation
 First Query:
 SELECT postings with job_id, and job_title and mark it with ‘With Salary Info’
 FROM the job_postings_fact table
 In the WHERE clause only get job postings that have either yearly or 
 hourly salary information (salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL).
 Second Query:
 SELECT postings with job_id, and job_title and mark it with ‘Without Salary Info’
 FROM the job_postings_fact table
 In the WHERE clause only get job postings that don’t have yearly or 
 hourly salary information (salary_year_avg IS NULL AND salary_hour_avg IS NULL).
 Combine these two sets of postings using UNION ALL to create a comprehensive list. */
-- CTE for combining job postings from January, February, and March
WITH combined_job_postings AS (
    SELECT job_id,
        job_posted_date
    FROM january_jobs
    UNION ALL
    SELECT job_id,
        job_posted_date
    FROM february_jobs
    UNION ALL
    SELECT job_id,
        job_posted_date
    FROM march_jobs
),
-- CTE for calculating monthly skill demand based on the combined postings
monthly_skill_demand AS (
    SELECT skills_dim.skills,
        EXTRACT(
            YEAR
            FROM combined_job_postings.job_posted_date
        ) AS year,
        EXTRACT(
            MONTH
            FROM combined_job_postings.job_posted_date
        ) AS month,
        COUNT(combined_job_postings.job_id) AS postings_count
    FROM combined_job_postings
        INNER JOIN skills_job_dim ON combined_job_postings.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    GROUP BY skills_dim.skills,
        year,
        month
) -- Main query to display the demand for each skill during the first quarter
SELECT skills,
    year,
    month,
    postings_count
FROM monthly_skill_demand
ORDER BY skills,
    year,
    month;
/* Create a CTE named combined_job_postings to consolidate job postings from the first quarter:
 Include job postings from january_jobs, february_jobs, and march_jobs using UNION ALL to ensure all data from these months are combined.
 Select job_id and job_posted_date from each month's table, making sure that all postings are captured, including duplicates.
 Create a second CTE called monthly_skill_demand to calculate the demand for skills month by month:
 In the SELECT statement:
 Use skills to get the skill
 Use EXTRACT to pull out the year (EXTRACT(YEAR FROM combined_job_postings.job_posted_date)) and month (EXTRACT(MONTH FROM combined_job_postings.job_posted_date))
 COUNT the number of job postings for each skill (COUNT(combined_job_postings.job_id))
 Get data FROM the combined_job_postings CTE.
 INNER JOIN the combined_job_postings with skills_job_dim on job_id to associate job postings with their required skills.
 INNER JOIN the skills_dim on skill_id to get the names and types of the skills.
 GROUP BY the skills, year, month
 In the main query:
 Get the skills, year, month, and postings_count
 FROM the monthly_skill_demand CTE
 Use ORDER BY to sort the results first by skill name (skills), then year, and month/*