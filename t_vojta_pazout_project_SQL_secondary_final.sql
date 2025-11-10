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
WHERE c.continent = 'Europe'
  AND e.year BETWEEN (
        SELECT MIN(year) FROM t_vojta_pazout_project_SQL_primary_final
    ) AND (
        SELECT MAX(year) FROM t_vojta_pazout_project_SQL_primary_final
    )
GROUP BY e.country, e.year
ORDER BY e.country, e.year;


