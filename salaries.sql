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







-- This query calculates the average hourly and yearly salary for each job title
-- and job location. It will return all columns from the job_postings_fact table
-- as well as the average hourly and yearly salary for each job title and job
-- location.
--
-- The query will only return rows where the salary_hourly_avg and salary_yearly_avg
-- fields are greater than 0, because the average salary is meaningless if there
-- are no valid salary data points.
--
-- The GROUP BY clause groups the results by job title and job location.
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






-- This query calculates the average hourly and yearly salary for each job title,
-- job location and month.
--
-- The query will only return rows where the salary_hourly_avg and salary_yearly_avg
-- fields are greater than 0, because the average salary is meaningless if there
-- are no valid salary data points.
--
-- The GROUP BY clause groups the results by job title, job location and month.
SELECT 
    job_title_short,
    job_location,
    EXTRACT(MONTH FROM job_posted_date) AS posted_month,
    CEIL(AVG(salary_hour_avg)) AS avg_hourly,
    CEIL(AVG(salary_year_avg)) AS avg_yearly
FROM 
    job_postings_fact
WHERE salary_hour_avg > 0 OR salary_year_avg > 0
GROUP BY 
    job_title_short, job_location, posted_month;








    -- This query calculates the average hourly and yearly salary for each job title,
    -- job location and month, and the company name.
    --
    -- The query will only return rows where the salary_hourly_avg and salary_yearly_avg
    -- fields are greater than 0, because the average salary is meaningless if there
    -- are no valid salary data points.
    --
    -- The GROUP BY clause groups the results by job title, job location, and month.
SELECT 
    jpf.job_title_short,
    jpf.job_location,
    EXTRACT(MONTH FROM jpf.job_posted_date) AS posted_month,
    cd.name As company_name,
    CEIL(AVG(jpf.salary_hour_avg)) AS avg_hourly,
    CEIL(AVG(jpf.salary_year_avg)) AS avg_yearly
FROM 
    job_postings_fact jpf
INNER JOIN 
    company_dim cd ON jpf.company_id = cd.company_id
WHERE 
    jpf.salary_hour_avg > 0 OR jpf.salary_year_avg > 0
GROUP BY 
    jpf.job_title_short, jpf.job_location, EXTRACT(MONTH FROM jpf.job_posted_date), cd.name;










SELECT 
    job_title_short,
    ROUND(AVG(salary_year_avg),0) AS avg_yearly_salary
FROM 
    job_postings_fact
WHERE 
    salary_year_avg > 0
GROUP BY 
    job_title_short;