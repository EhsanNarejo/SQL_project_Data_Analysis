/*## 🆕 Create Tables from Other Tables
 
 ❓**Question:** 
 
 - Create three tables:
 - Jan 2023 jobs
 - Feb 2023 jobs
 - Mar 2023 jobs
 - **Foreshadowing:** This will be used in another practice problem below.
 - Hints:
 - Use `CREATE TABLE table_name AS` syntax to create your table
 - Look at a way to filter out only specific months (`EXTRACT`)*/
CREATE TABLE january_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(
        MONTH
        FROM job_posted_date
    ) = 1;
CREATE TABLE feburary_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(
        MONTH
        FROM job_posted_date
    ) = 2;
CREATE TABLE march_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(
        MONTH
        FROM job_posted_date
    ) = 3;
SELECT job_posted_date
FROM march_jobs

/*  problem 6 maybe 
-- Problem: Find companies that have posted jobs offering health insurance in Q2 2023
-- Include company name, order by job postings count from highest to lowest

SELECT 
    c.name AS company_name,
    COUNT(j.job_id) AS job_postings_count
FROM 
    job_postings_fact j
JOIN 
    company_dim c ON j.company_id = c.company_id
WHERE 
    j.job_health_insurance = true
    AND EXTRACT(QUARTER FROM j.job_posted_date) = 2
    AND EXTRACT(YEAR FROM j.job_posted_date) = 2023
GROUP BY 
    c.name
HAVING 
    COUNT(j.job_id) > 0
ORDER BY 
    job_postings_count DESC; */
    