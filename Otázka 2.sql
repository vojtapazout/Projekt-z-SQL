"Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?"


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
combined_prices AS (
    SELECT 
        p.year,
        MAX(CASE WHEN p.price_category = 'Mléko polotučné pasterované' THEN p.avg_price END) AS milk_price,
        MAX(CASE WHEN p.price_category = 'Chléb konzumní kmínový' THEN p.avg_price END) AS bread_price
    FROM avg_prices p
    GROUP BY p.year
),
affordability AS (
    SELECT 
        s.year,
        s.avg_salary,
        c.milk_price,
        c.bread_price,
        ROUND(s.avg_salary / (c.milk_price + c.bread_price), 2) AS combined_quantity_affordable
    FROM avg_salaries s
    JOIN combined_prices c ON s.year = c.year
)
SELECT *
FROM affordability
WHERE year = (SELECT MIN(year) FROM affordability)
   OR year = (SELECT MAX(year) FROM affordability)
ORDER BY year;
