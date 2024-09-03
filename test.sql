
-- This query will return the top 10 job titles with the skills separated by commas
-- The results are ordered by job title and limited to 10 records
SELECT 
    jpf.job_title_short,
    sd.skills
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd
    ON sjd.skill_id = sd.skill_id
    GROUP BY sd.skills, jpf.job_title_short


-- The LIMIT clause limits the output to 10 records
LIMIT 10;



-- This query will return the top 10 job titles with the skills separated by commas
-- The skills are aggregated by job title using the STRING_AGG function
-- The results are ordered by job title and limited to 10 records
SELECT
    jpf.job_title_short,
    STRING_AGG(DISTINCT sd.skills, ', ') AS skills
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd
    ON sjd.skill_id = sd.skill_id
GROUP BY jpf.job_title_short
ORDER BY jpf.job_title_short
LIMIT 10;





-- This query will return the top 10 skills with the most occurrences across all job titles
SELECT
    sd.skills,
    COUNT(*) AS count
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd
    ON sjd.skill_id = sd.skill_id
-- The results will be ordered by the number of occurrences in descending order
GROUP BY sd.skills
ORDER BY count DESC
-- The top 10 skills will be returned
LIMIT 10;






-- This query will return the top 20 skills for each job title, with the number of occurrences
-- The results are grouped by job title and ordered by the number of occurrences in descending order
-- The skills with fewer than 1000 occurrences will be excluded
SELECT
    job_title_short,
    skills,
    COUNT(*) AS occurrence_count
FROM job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY job_title_short, skills
HAVING COUNT(*) > 1000
ORDER BY job_title_short, occurrence_count DESC
LIMIT 200;






WITH ranked_skills AS (
  -- This CTE will rank the skills by the number of occurrences, grouped by job title
  -- The rank is partitioned by job title and ordered by the count in descending order
  SELECT
    jpf.job_title_short,
    sd.skills,
    COUNT(*) AS count,
    ROW_NUMBER() OVER (PARTITION BY jpf.job_title_short ORDER BY COUNT(*) DESC) AS rank
  FROM job_postings_fact jpf
  INNER JOIN skills_job_dim sjd
    ON jpf.job_id = sjd.job_id
  INNER JOIN skills_dim sd
    ON sjd.skill_id = sd.skill_id
  GROUP BY jpf.job_title_short, sd.skills
)
SELECT
  job_title_short,
  STRING_AGG(skills, ', ') AS top_5_skills
FROM ranked_skills
WHERE rank <= 5
GROUP BY job_title_short;

-- This query will return the top 5 skills for each job title, with the skills separated by commas





/**
 * This query will return the top 5 skills for each job title, with the skills ordered by the number of occurrences
 * The results are grouped by job title and limited to 5 skills per job title
 */
SELECT job_title_short, skills, occurrence_count
FROM (
  SELECT job_title_short, skills, occurrence_count,
         ROW_NUMBER() OVER (PARTITION BY job_title_short ORDER BY occurrence_count DESC) AS skill_rank
  FROM (
    SELECT job_title_short, skills, COUNT(*) AS occurrence_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    GROUP BY job_title_short, skills
    HAVING COUNT(*) > 1000
  ) AS subquery
) AS ranked_skills
WHERE skill_rank <= 5
ORDER BY job_title_short, occurrence_count DESC;
