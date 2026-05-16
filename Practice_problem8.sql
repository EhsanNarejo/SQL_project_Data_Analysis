/* 
 I only want to look at job postings from the first quarter that have a salary greater than $70k. 
 
 - ⚠️ Note:
 - Alias is necessary because it will return an error without it. It’s needed for subqueries in the FROM clause.
 - Combine job posting tables from the first quarter of 2023 (Jan-Mar)
 - Gets job postings with an average yearly salary > $70,000 from the first quarter of 2023 (Jan-Mar)
 - Why? Look at job postings for the first quarter of 2023 (Jan-Mar) that has a salary > $70,000
 */
SELECT quarter1_job_postings.job_title_short,
	quarter1_job_postings.job_location,
	quarter1_job_postings.job_via,
	quarter1_job_postings.job_posted_date::DATE
FROM -- Gets all rows from January, February, and March job postings 
	(
		SELECT *
		FROM january_jobs
		UNION ALL
		SELECT *
		FROM feburary_jobs
		UNION ALL
		SELECT *
		FROM march_jobs
	) AS quarter1_job_postings
WHERE quarter1_job_postings.salary_year_avg > 70000 --AND job_postings.job_title_short = 'Data Analyst'
ORDER BY quarter1_job_postings.salary_year_avg DESC