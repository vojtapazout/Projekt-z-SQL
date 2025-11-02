"Identifikace poklesu"

WITH salary_change AS (
    SELECT 
        industry_name,
        year,
        avg_salary,
        LAG(avg_salary) OVER (PARTITION BY industry_name ORDER BY year) AS prev_year_salary
    FROM t_vojta_pazout_project_SQL_primary_final
    GROUP BY industry_name, year, avg_salary
)
SELECT
    industry_name,
    year,
    avg_salary,
    prev_year_salary,
    ROUND((avg_salary - prev_year_salary)/prev_year_salary * 100, 2) AS pct_change
FROM salary_change
WHERE prev_year_salary IS NOT NULL
  AND (avg_salary - prev_year_salary) < 0  -- ukáže jen pokles
ORDER BY year ASC, pct_change ASC;  -- nejstarší rok nahoře, největší pokles nahoře