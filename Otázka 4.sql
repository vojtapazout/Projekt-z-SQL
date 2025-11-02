"Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?"

WITH avg_salaries AS (
    SELECT 
        year,
        AVG(avg_salary) AS avg_salary
    FROM t_vojta_pazout_project_SQL_primary_final
    GROUP BY year
),
avg_prices AS (
    SELECT
        year,
        AVG(price_value) AS avg_price_all_food
    FROM t_vojta_pazout_project_SQL_primary_final
    GROUP BY year
),
price_change AS (
    SELECT
        year,
        avg_price_all_food,
        LAG(avg_price_all_food) OVER (ORDER BY year) AS prev_year_price
    FROM avg_prices
),
salary_change AS (
    SELECT
        year,
        avg_salary,
        LAG(avg_salary) OVER (ORDER BY year) AS prev_year_salary
    FROM avg_salaries
),
growth_comparison AS (
    SELECT
        p.year,
        ROUND((p.avg_price_all_food - p.prev_year_price)/p.prev_year_price * 100, 2) AS food_price_pct_change,
        ROUND((s.avg_salary - s.prev_year_salary)/s.prev_year_salary * 100, 2) AS salary_pct_change,
        ROUND((p.avg_price_all_food - p.prev_year_price)/p.prev_year_price * 100, 2)
        - ROUND((s.avg_salary - s.prev_year_salary)/s.prev_year_salary * 100, 2) AS diff_pct
    FROM price_change p
    JOIN salary_change s ON p.year = s.year
    WHERE p.prev_year_price IS NOT NULL AND s.prev_year_salary IS NOT NULL
)
SELECT *
FROM growth_comparison
WHERE TRUE
ORDER BY year DESC;