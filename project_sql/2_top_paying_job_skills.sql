/***Question: What are the highest-paying Data Analyst jobs and the skills required for these roles?** 
 
 - Identify the top 10 highest-paying Data Analyst job postings and the specific skills associated with them.
 - Focuses on opportunities located in Australia or available remotely (“Anywhere”) with specified salaries.
 - Why? Provides insight into which high-paying Data Analyst roles require specific technical skills, helping job seekers understand which skills align with top-paying opportunities.
 */
WITH top_paying_jobs AS (
    SELECT job_id,
        job_title,
        salary_year_avg,
        company_dim.name AS company_name
    FROM job_postings_fact
        LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE job_title_short = 'Data Analyst'
        AND (
            job_location = 'Australia'
            OR job_location = 'Anywhere'
        )
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT top_paying_jobs.*,
    skills_dim.skills
FROM top_paying_jobs
    INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;