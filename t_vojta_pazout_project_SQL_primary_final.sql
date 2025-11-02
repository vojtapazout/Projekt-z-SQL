CREATE TABLE t_vojta_pazout_project_SQL_primary_final AS
WITH avg_salaries AS (
    SELECT 
        p.payroll_year AS year,
        ib.name AS industry_name,
        ROUND(AVG(p.value)::numeric, 2) AS avg_salary
    FROM czechia_payroll p
    JOIN czechia_payroll_industry_branch ib
        ON p.industry_branch_code = ib.code
    WHERE p.value_type_code = 5958  -- Průměrná hrubá mzda na zaměstnance
    GROUP BY p.payroll_year, ib.name
),
avg_prices AS (
    SELECT 
        EXTRACT(YEAR FROM pr.date_from)::INT AS year,
        pc.name AS price_category,
        ROUND(AVG(pr.value)::numeric, 2) AS price_value
    FROM czechia_price pr
    JOIN czechia_price_category pc
        ON pr.category_code = pc.code
    GROUP BY EXTRACT(YEAR FROM pr.date_from), pc.name
)
SELECT 
    s.year,
    s.industry_name,
    s.avg_salary,
    p.price_category,
    p.price_value
FROM avg_salaries s
CROSS JOIN avg_prices p
WHERE s.year = p.year
ORDER BY s.year, s.industry_name, p.price_category;