SELECT 
    ROUND(AVG(salary_hour_avg), 0) AS avg_salary_hour,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary_year,
    EXTRACT(YEAR FROM job_posted_date) AS year,
    EXTRACT(MONTH FROM job_posted_date) AS month,
    --COUNT(*) AS num_job_offers,
    job_schedule_type
FROM 
    job_postings_fact
WHERE 
     (salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL) AND job_posted_date >= '2023-06-01'
GROUP BY 
    EXTRACT(YEAR FROM job_posted_date),
    EXTRACT(MONTH FROM job_posted_date),
    job_schedule_type;
