/*- Find the count of the number of remote job postings per skill
 - Display the top 5 skills in descending order by their demand in remote jobs
 - Include skill ID, name, and count of postings requiring the skill
 - Why? Identify the top 5 skills in demand for remote jobs */
WITH remote_job_skills AS(
    SELECT skill_id,
        COUNT(*) AS skill_count
    FROM skills_job_dim AS skills_to_job
        JOIN job_postings_fact AS job_postings ON skills_to_job.job_id = job_postings.job_id
    WHERE job_postings.job_work_from_home = true
    GROUP BY skill_id
)
SELECT skills.skill_id,
    skills AS skill_name,
    remote_job_skills.skill_count
FROM remote_job_skills
    INNER JOIN skills_dim AS skills ON remote_job_skills.skill_id = skills.skill_id
ORDER BY skill_count DESC
LIMIT 5;