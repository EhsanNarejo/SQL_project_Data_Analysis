/*Question: What are the highest - paying Data Analyst jobs in Australia
 and remote - friendly roles ? * * - Identify the top 20 highest - paying Data Analyst job postings based in Australia
 or listed as “ Anywhere ”.- Focuses on roles with specified salaries.- Why ? Highlights high - paying opportunities for Data Analysts across Australian
 and flexible / remote job markets,
 helping understand salary trends
 and job availability.*/
SELECT job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
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
LIMIT 20;