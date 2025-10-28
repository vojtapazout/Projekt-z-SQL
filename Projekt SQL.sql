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

CREATE TABLE t_vojta_pazout_project_SQL_secondary_final AS
SELECT 
    country,
    year,
    gdp,
    gini,
    population
FROM economies
WHERE country IN (
    'Austria', 'Belgium', 'Bulgaria', 'Croatia', 'Cyprus', 'Czechia', 'Denmark',
    'Estonia', 'Finland', 'France', 'Germany', 'Greece', 'Hungary', 'Ireland',
    'Italy', 'Latvia', 'Lithuania', 'Luxembourg', 'Malta', 'Netherlands', 'Poland',
    'Portugal', 'Romania', 'Slovakia', 'Slovenia', 'Spain', 'Sweden'
)
AND year IN (SELECT DISTINCT payroll_year FROM czechia_payroll)
ORDER BY country, year;

"Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?"
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
ORDER BY industry_name, year;

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

"Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?"

SELECT DISTINCT price_category
FROM t_vojta_pazout_project_SQL_primary_final
ORDER BY price_category;

WITH avg_prices AS (
    SELECT 
        year,
        price_category,
        AVG(price_value) AS avg_price
    FROM t_vojta_pazout_project_SQL_primary_final
    WHERE price_category IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
    GROUP BY year, price_category
),
avg_salaries AS (
    SELECT 
        year,
        AVG(avg_salary) AS avg_salary
    FROM t_vojta_pazout_project_SQL_primary_final
    GROUP BY year
),
affordability AS (
    SELECT
        p.year,
        p.price_category,
        s.avg_salary,
        p.avg_price,
        ROUND(s.avg_salary / p.avg_price, 2) AS quantity_affordable
    FROM avg_prices p
    JOIN avg_salaries s
        ON p.year = s.year
)
SELECT *
FROM affordability
WHERE year = (SELECT MIN(year) FROM affordability)
   OR year = (SELECT MAX(year) FROM affordability)
ORDER BY year, price_category;

"Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?"

WITH price_change AS (
    SELECT
        price_category,
        year,
        price_value,
        LAG(price_value) OVER (PARTITION BY price_category ORDER BY year) AS prev_year_price
    FROM t_vojta_pazout_project_SQL_primary_final
)
, pct_change AS (
    SELECT
        price_category,
        year,
        ROUND((price_value - prev_year_price)/prev_year_price * 100, 2) AS pct_change
    FROM price_change
    WHERE prev_year_price IS NOT NULL
)
SELECT
    price_category,
    ROUND(AVG(pct_change), 2) AS avg_annual_pct_change
FROM pct_change
GROUP BY price_category
ORDER BY avg_annual_pct_change ASC
LIMIT 10;  -- nejpomalejší růst

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
        price_category,
        AVG(price_value) AS avg_price
    FROM t_vojta_pazout_project_SQL_primary_final
    GROUP BY year, price_category
),
price_change AS (
    SELECT
        price_category,
        year,
        avg_price,
        LAG(avg_price) OVER (PARTITION BY price_category ORDER BY year) AS prev_year_price
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
        p.price_category,
        p.year,
        ROUND((p.avg_price - p.prev_year_price)/p.prev_year_price * 100, 2) AS price_pct_change,
        ROUND((s.avg_salary - s.prev_year_salary)/s.prev_year_salary * 100, 2) AS salary_pct_change,
        ROUND((p.avg_price - p.prev_year_price)/p.prev_year_price * 100, 2)
        - ROUND((s.avg_salary - s.prev_year_salary)/s.prev_year_salary * 100, 2) AS diff_pct
    FROM price_change p
    JOIN salary_change s ON p.year = s.year
    WHERE p.prev_year_price IS NOT NULL AND s.prev_year_salary IS NOT NULL
)
SELECT *
FROM growth_comparison
WHERE diff_pct > 10
ORDER BY year, diff_pct DESC;


"Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?"

SELECT DISTINCT country FROM t_vojta_pazout_project_SQL_secondary_final;

"Vytvoří tabulku HDP GINI a populaci ve stejných letech"

WITH gdp_change AS (
    SELECT
        country,
        year,
        gdp,
        LAG(gdp) OVER (PARTITION BY country ORDER BY year) AS prev_year_gdp,
        ROUND(((gdp - LAG(gdp) OVER (PARTITION BY country ORDER BY year)) / LAG(gdp) OVER (PARTITION BY country ORDER BY year) * 100)::numeric, 2) AS gdp_pct_change
    FROM t_vojta_pazout_project_SQL_secondary_final
),
avg_salaries AS (
    SELECT
        year,
        AVG(avg_salary) AS avg_salary
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
        AVG(price_value) AS avg_price
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
)
SELECT
    g.country,
    g.year,
    g.gdp_pct_change,
    s.salary_pct_change,
    p.price_pct_change
FROM gdp_change g
LEFT JOIN salary_change s ON g.year = s.year
LEFT JOIN price_change p ON g.year = p.year
ORDER BY g.country, g.year;



