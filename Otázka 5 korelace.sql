"Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?"

"Korelační analýza"

WITH gdp_data AS (
    SELECT
        year,
        gdp
    FROM t_vojta_pazout_project_SQL_secondary_final
    WHERE country = 'Czech Republic'
),
gdp_change AS (
    SELECT
        year,
        gdp,
        LAG(gdp) OVER (ORDER BY year) AS prev_year_gdp,
        ROUND(((gdp - LAG(gdp) OVER (ORDER BY year)) / LAG(gdp) OVER (ORDER BY year) * 100)::numeric, 2) AS gdp_pct_change
    FROM gdp_data
),
avg_salaries AS (
    SELECT
        year,
        ROUND(AVG(avg_salary)::numeric, 2) AS avg_salary
    FROM t_vojta_pazout_project_SQL_primary_final
    GROUP BY year
),
salary_change AS (
    SELECT
        year,
        avg_salary,
        LAG(avg_salary) OVER (ORDER BY year) AS prev_year_salary,
        ROUND(((avg_salary - LAG(avg_salary) OVER (ORDER BY year)) / LAG(avg_salary) OVER (ORDER BY year) * 100)::numeric, 2) AS salary_pct_change
    FROM avg_salaries
),
avg_prices AS (
    SELECT
        year,
        ROUND(AVG(price_value)::numeric, 2) AS avg_price
    FROM t_vojta_pazout_project_SQL_primary_final
    GROUP BY year
),
price_change AS (
    SELECT
        year,
        avg_price,
        LAG(avg_price) OVER (ORDER BY year) AS prev_year_price,
        ROUND(((avg_price - LAG(avg_price) OVER (ORDER BY year)) / LAG(avg_price) OVER (ORDER BY year) * 100)::numeric, 2) AS price_pct_change
    FROM avg_prices
),
combined AS (
    SELECT
        g.year,
        g.gdp_pct_change,
        s.salary_pct_change,
        p.price_pct_change
    FROM gdp_change g
    JOIN salary_change s ON g.year = s.year
    JOIN price_change p ON g.year = p.year
    WHERE g.gdp_pct_change IS NOT NULL
      AND s.salary_pct_change IS NOT NULL
      AND p.price_pct_change IS NOT NULL
)
SELECT
    ROUND(corr(gdp_pct_change, salary_pct_change)::numeric, 3) AS corr_gdp_salary,
    ROUND(corr(gdp_pct_change, price_pct_change)::numeric, 3) AS corr_gdp_price
FROM combined;
