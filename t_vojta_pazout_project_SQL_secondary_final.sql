CREATE TABLE t_vojta_pazout_project_SQL_secondary_final AS
SELECT 
    e.country,
    e.year,
    ROUND(AVG(e.gdp)::numeric, 2) AS gdp,
    ROUND(AVG(e.gini)::numeric, 2) AS gini,
    ROUND(AVG(e.population)::numeric, 0) AS population
FROM economies e
JOIN countries c 
    ON e.country = c.country
WHERE e.year BETWEEN (
        SELECT MIN(payroll_year) FROM czechia_payroll
    ) AND (
        SELECT MAX(payroll_year) FROM czechia_payroll
    )
GROUP BY e.country, e.year
ORDER BY e.country, e.year;

select *
from t_vojta_pazout_project_sql_secondary_final tvppssf