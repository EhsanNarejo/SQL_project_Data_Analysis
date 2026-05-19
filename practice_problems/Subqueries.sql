/*notes 
 https://www.notion.so/SubQueries-and-CTEs-eaed83d861d98368a7ac01f055cf4517
 */
/*WITH company_job_count AS (
 SELECT company_id,
 COUNT(*) AS total_jobs
 FROM job_postings_fact
 GROUP BY company_id
 )
 SELECT company_dim.name AS company_name,
 company_job_count.total_jobs
 FROM company_dim
 LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
 ORDER BY total_jobs DESC */
/*Problem Statement 1
 Identify the top 5 skills that are most frequently mentioned in job postings. Use a subquery to find the skill IDs
 with the highest counts in the skills_job_dim table and then join this result with the skills_dim table to get the skill names.
 
 Hint
 Focus on creating a subquery that identifies and ranks (ORDER BY in descending order) the top 5 skill IDs
 by their frequency (COUNT) of mention in job postings.
 Then join this subquery with the skills table (skills_dim) to match IDs to skill names.
 
 SELECT
 skills_dim.skill_id,
 skills_dim.skills AS skill_name,
 top_skills.skill_count
 FROM skills_dim
 JOIN (
 SELECT
 skill_id,
 COUNT(*) AS skill_count
 FROM skills_job_dim
 GROUP BY skill_id
 ORDER BY skill_count DESC
 LIMIT 5
 ) AS top_skills
 ON skills_dim.skill_id = top_skills.skill_id
 ORDER BY top_skills.skill_count DESC; 
 Select the skills_dim.skills to get the actual skill names from the skills dimension table.
 In an INNER JOIN use a subquery that ranks the top 5 skills by frequency of mention in job postings.
 SELECT the skill_id and get the skill count using COUNT(job_id) AS skill_count.
 FROM the skills_job_dim which is where the skill-job relationships are stored.
 GROUP BY skill_id to aggregate counts by each skill ID.
 ORDER BY the COUNT(job_id) DESC to sort the skills by the most frequent at the top.
 LIMIT 5 to restrict the results to the top 5 most frequent skills.
 Rename the subquery as top_skills and join on skills_dim.skill_id = top_skills.skill_id matching the skill ID from the subquery to the skill ID in the skills dimension table.
 In the outer query use ORDER BY the top_skills.skill_count in descending order to list the top 5 skills in order.
 */
/*Problem Statement 2
 Determine the size category ('Small', 'Medium', or 'Large') for each company by first identifying the number of job postings they have. Use a subquery to calculate the total job postings per company. A company is considered 'Small' if it has less than 10 job postings, 'Medium' if the number of job postings is between 10 and 50, and 'Large' if it has more than 50 job postings. Implement a subquery to aggregate job counts per company before classifying them based on size.
 
 Hint
 Aggregate job counts per company in the subquery. This involves grouping by company and counting job postings.
 Use this subquery in the FROM clause of your main query.
 In the main query, categorize companies based on the aggregated job counts from the subquery with a CASE statement.
 The subquery prepares data (counts jobs per company), and the outer query classifies companies based on these counts.
 
 SELECT
 company_id,
 name,
 CASE
 WHEN job_count < 10 THEN 'Small'
 WHEN job_count BETWEEN 10 AND 50 THEN 'Medium'
 ELSE 'Large'
 END AS company_size
 FROM (
 SELECT
 company_dim.company_id,
 company_dim.name,
 COUNT(job_postings_fact.job_id) AS job_count
 FROM company_dim
 INNER JOIN job_postings_fact ON company_dim.company_id = job_postings_fact.company_id
 GROUP BY company_dim.company_id, company_dim.name
 ) AS company_job_counts;
 * We used **INNER JOIN** to connect companies with their job postings using `company_id`.
 * We used **GROUP BY** to group all jobs under each company.
 * We used **COUNT()** to calculate total job postings per company.
 * We used a **subquery** to first create this aggregated result (company + job_count).
 * In the outer query, we used a **CASE statement** to classify companies:
 
 * < 10 = Small
 * 10–50 = Medium
 * > 50 = Large
 * Subquery is used because aggregation must happen before classification.
 */
/*Problem Statement 3
 SELECT
 company_dim.name
 FROM
 company_dim
 INNER JOIN
 (SELECT
 company_id,
 AVG(salary_year_avg) AS avg_salary
 FROM job_postings_fact
 GROUP BY company_id) AS company_salaries ON company_dim.company_id = company_salaries.company_id
 WHERE
 company_salaries.avg_salary > (
 SELECT
 AVG(salary_year_avg)
 FROM job_postings_fact
 
 );
 Select the company names (name) from the company_dim table to identify the companies.
 INNER JOIN the company_dim table with a subquery:
 Selects the company_id and the average of salary_year_avg
 From the job_postings_fact table,
 Grouping the results by company_id.
 Name this subquery as company_salaries, which now holds the average salary information per company
 JOIN on company_id
 In the WHERE clause of your main query, include another subquery that:
 In the SELECT calculates the overall average salary across all job postings (AVG(salary_year_avg)) from the job_postings_fact table.
 Compare each company's average salary (company_salaries subquery) to the overall average salary determined by the second subquery; average salary is greater than this overall average. */