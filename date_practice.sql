/*Problem Statement 3
 Find companies (include company name) that have posted jobs offering health insurance, 
 where these postings were made in the second quarter of 2023. Use date extraction 
 to filter by quarter. And order by the job postings count from highest to lowest.
 
 Hint
 Join job_postings_fact and company_dim on company_id to match jobs to companies.
 Use the WHERE clause to filter for jobs with job_health_insurance column.
 Use EXTRACT(QUARTER FROM job_posted_date) to filter for postings in the second quarter.
 Group results by company_name.
 Count the number of job postings per company with COUNT(job_id).
 Use HAVING to include only companies with at least one job posting.
 ORDER BY the job postings count in descending order to get highest → lowest.
 
 SELECT 
 company_dim.name AS company_name,
 COUNT(job_postings_fact.job_id) AS job_postings_count
 FROM
 job_postings_fact
 INNER JOIN
 company_dim ON job_postings_fact.company_id = company_dim.company_id
 WHERE
 job_postings_fact.job_health_insurance = true
 AND EXTRACT(QUARTER FROM job_postings_fact.job_posted_date) = 2
 GROUP BY
 company_dim.name
 HAVING
 COUNT(job_postings_fact.job_id) > 0
 ORDER BY
 job_postings_count DESC;*/
/*Problem Statement 2
 Count the number of job postings for each month, adjusting the job_posted_date to be in 'America/New_York' time zone 
 before extracting the month. Assume the job_posted_date is stored in UTC. Group by and order by the month.
 
 Hint
 Use the EXTRACT(MONTH FROM ...) function to get the month from job_posted_date and wihtin this EXTRACT convert it to the 'America/New_York' time zone using AT TIME ZONE (don’t forget to assume default is in ‘UTC’).
 COUNT the number of job postings
 GROUP BY the extracted month
 ORDER BY the month.
 
 SELECT
 job_title_short,
 EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') as month,
 COUNT(job_posted_date) AS jobs_counted
 FROM
 job_postings_fact
 GROUP BY 
 month, job_title_short
 ORDER BY
 month DESC; */
/*Problem Statement 1
 Find the average salary both yearly (salary_year_avg) and hourly (salary_hour_avg) 
 for job postings using the job_postings_fact table that were posted 
 after June 1, 2023. Group the results by job schedule type. Order by the job_schedule_type in ascending order.
 
 Hint
 Calculate average salaries by using the AVG function on both salary_year_avg and salary_hour_avg.
 Filter postings with WHERE for dates after June 1, 2023,
 Group the results with job_schedule_type.
 Use job_schedule_type for ORDER BY.
 
 SELECT
 job_title_short,
 job_schedule_type,
 AVG(salary_year_avg) AS salary_year_avg,
 AVG(salary_hour_avg) AS salary_hour_avg
 FROM
 job_postings_fact
 WHERE
 job_posted_date :: DATE > '2023-06-01' and
 job_title_short = 'Data Analyst'
 GROUP BY
 job_schedule_type, job_title_short
 ORDER BY
 job_title_short;*/
/*SELECT job_title_short AS title,
 job_location AS location,
 job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
 EXTRACT(
 MONTH
 FROM job_posted_date
 ) AS date_month,
 EXTRACT(
 YEAR
 FROM job_posted_date
 ) AS date_year
 FROM job_postings_fact
 LIMIT 5;*/