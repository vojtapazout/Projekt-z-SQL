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