-- Updates salary_year_avg by multiplying salary_hour_avg * 2080. This calculation assumes
-- that the employee works 2080 hours a year (40 hours a week * 52 weeks a year).
-- This updates the salary_year_avg field if it is null and the salary_hour_avg field
-- is not null.
UPDATE job_postings_fact
SET salary_year_avg = salary_hour_avg * 2080
WHERE salary_year_avg IS NULL AND salary_hour_avg IS NOT NULL;





-- Updates salary_hour_avg by dividing salary_year_avg by 2080. This calculation assumes
-- that the employee works 2080 hours a year (40 hours a week * 52 weeks a year).
-- This updates the salary_hour_avg field if it is null and the salary_year_avg field
-- is not null.
UPDATE job_postings_fact
SET salary_hour_avg = salary_year_avg / 2080
WHERE salary_hour_avg IS NULL AND salary_year_avg IS NOT NULL;






-- Cleaning up the data
SELECT
*
FROM job_postings_fact
WHERE salary_hour_avg > 0 OR salary_year_avg > 0
LIMIT 50





-- Calculates the average hourly and yearly salary for each job title
SELECT 
    job_title_short,
    CEIL(AVG(salary_hour_avg)) AS avg_hourly,
    CEIL(AVG(salary_year_avg)) AS avg_yearly
FROM 
    job_postings_fact
GROUP BY 
    job_title_short;






SELECT
    job_title_short,
    job_location,
    CEIL(AVG(salary_hour_avg)) AS avg_hourly,
    CEIL(AVG(salary_year_avg)) AS avg_yearly
FROM
    job_postings_fact
WHERE salary_hour_avg > 0 OR salary_year_avg > 0
GROUP BY
    job_title_short, job_location;
--HAVING
   -- salary_hourly_avg > 0 OR salary_yearly_avg > 0;
