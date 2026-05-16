/*📝 **Notes:**
 
 A **`CASE`** expression in SQL is a way to apply conditional logic within your SQL queries.
 
 ```sql
 SELECT
 CASE
 WHEN column_name = 'Value1' THEN 'Description for Value1'
 WHEN column_name = 'Value2' THEN 'Description for Value2'
 ELSE 'Other' 
 END AS column_description
 FROM
 table_name;
 ```
 
 - `CASE` - begins the expression
 - `WHEN` - specifies the condition(s) to look at
 - `THEN` - what to do when the condition is `TRUE`
 - `ELSE` (optional) - provides output if none of the `WHEN`  conditions are met
 - `END` - concludes the `CASE` expression
 - Notes:
 - It runs from top to bottom, similar to an if-then-else statement
 - Once a condition is true, it’ll stop reading and return the value
 - If no conditions are true, it returns `NULL`*/
/*Problem Statement 1 
 From the job_postings_fact table, categorize the salaries from job postings that are data analyst jobs,
 and that have yearly salary information. Put salary into 3 different categories:
 
 If the salary_year_avg is greater than or equal to $100,000, then return ‘high salary’.
 If the salary_year_avg is greater than or equal to $60,000 but less than $100,000, then return ‘Standard salary.’
 If the salary_year_avg is below $60,000 return ‘Low salary’.
 Also, order from the highest to the lowest salaries.
 
 Hint
 In SELECT retrieve these columns: job_id, job_title, salary_year_avg, and a new column for the salary category.
 
 CASE Statement: Use to categorize salary_year_avg into 'High salary', 'Standard salary', or 'Low salary'.
 If the salary is over $100,000, it's a High salary.
 For salaries greater than or equal to $60,000,  assign Standard salary.
 Any salary below $60,000 should be marked as Low salary.
 FROM the job_postings_fact table.
 WHERE statement:
 Exclude records without a specified salary_year_avg.
 Focus on job_title_short that exactly matches 'Data Analyst'.
 Use ORDER BY to sort by salary_year_avg in descending order to start with the highest salaries first.
 
 SELECT
 job_id,
 job_title,
 salary_year_avg,
 CASE
 WHEN salary_year_avg >= 100000 THEN 'High salary'
 WHEN salary_year_avg >= 60000 THEN 'Standard salary'
 ELSE 'Low salary'
 END AS salary_category
 FROM
 job_postings_fact
 WHERE
 job_title_short = 'Data Analyst'
 AND salary_year_avg IS NOT NULL
 ORDER BY
 salary_year_avg DESC;*/
/*Problem Statement 2
 Count the number of unique companies that offer work from home (WFH) 
 versus those requiring work to be on-site. Use the job_postings_fact table to count
 and compare the distinct companies based on their WFH policy (job_work_from_home).
 
 Hint
 Use COUNT with DISTINCT to ensure each company is only counted once, 
 even if they have multiple job postings.
 Use CASE WHEN to separate companies based on their WFH policy (job_work_from_home column).
 
 SELECT
 CASE
 WHEN job_work_from_home = true THEN 'Work from Home'
 ELSE 'On-site'
 END AS work_policy,
 COUNT(DISTINCT company_id) AS unique_companies_count
 FROM
 job_postings_fact
 GROUP BY
 work_policy;*/
/*Problem Statement 3
 Write a SQL query using the job_postings_fact table that returns the following columns:
 
 job_id
 
 salary_year_avg
 
 experience_level (derived using a CASE WHEN)
 
 remote_option (derived using a CASE WHEN)
 
 Only include rows where salary_year_avg is not null.
 
 Instructions
 Experience Level
 Create a new column called experience_level
 based on keywords in the job_title column:
 
 Contains "Senior" → 'Senior'
 
 Contains "Manager" or "Lead" → 'Lead/Manager'
 
 Contains "Junior" or "Entry" → 'Junior/Entry'
 
 Otherwise → 'Not Specified'
 
 Use ILIKE instead of LIKE to perform 
 case-insensitive matching (PostgreSQL-specific).
 
 Remote Option
 Create a new column called remote_option:
 
 If job_work_from_home is true → 'Yes'
 
 Otherwise → 'No'
 
 Filter and Order
 
 Filter out rows where salary_year_avg is NULL
 
 Order the results by job_id
 
 Hint
 
 
 This problem introduces PostgreSQL’s ILIKE, which functions 
 like LIKE but ignores case.
 
 You’ll need to write two separate CASE WHEN expressions 
 — one for each derived column.
 
 This challenge is slightly more advanced due to the multiple
 conditions and the use of ILIKE. Don’t worry if it takes a few tries to get it right!
 
 SELECT
 job_id,
 salary_year_avg,
 CASE
 WHEN job_title ILIKE '%Senior%' THEN 'Senior'
 WHEN job_title ILIKE '%Manager%' OR job_title ILIKE '%Lead%' THEN 'Lead/Manager'
 WHEN job_title ILIKE '%Junior%' OR job_title ILIKE '%Entry%' THEN 'Junior/Entry'
 ELSE 'Not Specified'
 END AS experience_level,
 CASE
 WHEN job_work_from_home = true THEN 'Yes'
 ELSE 'No'
 END AS remote_option
 FROM
 job_postings_fact
 WHERE
 salary_year_avg IS NOT NULL
 ORDER BY
 job_id;
 */