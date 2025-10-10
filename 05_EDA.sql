/***********************************************************************
   EXPLORATORY DATA ANALYSIS (EDA)
   Dataset: Used Car Resale Prices (2002–2023)
   Purpose: Explore data patterns, distributions, and relationships
***********************************************************************/


------------------------------------------------------------
-- 1. YEAR ANALYSIS
------------------------------------------------------------

-- Earliest and latest registered year
SELECT 
    MIN(registered_year) AS lowest_registered_year,
    MAX(registered_year) AS highest_registered_year
FROM sales_analysis;

-- Year-on-Year average resale price with % change
SELECT 
    registered_year,
    ROUND(AVG(resale_price), 2) AS avg_price,
    ROUND(
        (
            (AVG(resale_price) - LAG(AVG(resale_price)) OVER (ORDER BY registered_year))
            / LAG(AVG(resale_price)) OVER (ORDER BY registered_year)
        ) * 100, 
        2
    ) AS pct_change
FROM sales_analysis
WHERE registered_year IS NOT NULL
GROUP BY registered_year
ORDER BY registered_year;



------------------------------------------------------------
-- 2. BRAND & VARIANT ANALYSIS
------------------------------------------------------------

-- Minimum, Maximum, and Average resale prices per brand
SELECT 
    brand_name, 
    COUNT(*) AS total_cars,
    FORMAT(MIN(resale_price), 0) AS min_price,
    FORMAT(AVG(resale_price), 0) AS avg_price,
    FORMAT(MAX(resale_price), 0) AS max_price
FROM sales_analysis
GROUP BY brand_name
ORDER BY total_cars DESC;

-- Top 10 most common variants by frequency
SELECT 
    variant_name,
    COUNT(*) AS count,
    FORMAT(AVG(resale_price), 0) AS avg_price
FROM sales_analysis
GROUP BY variant_name
ORDER BY count DESC
LIMIT 10;



------------------------------------------------------------
-- 3. ENGINE & PERFORMANCE
------------------------------------------------------------

-- Bucket engine capacities and check average resale price
SELECT 
    CASE
        WHEN engine_capacity_cc BETWEEN 0 AND 100 THEN '0-100 cc'
        WHEN engine_capacity_cc BETWEEN 101 AND 500 THEN '101-500 cc'
        WHEN engine_capacity_cc BETWEEN 501 AND 1000 THEN '501-1000 cc'
        WHEN engine_capacity_cc BETWEEN 1001 AND 1500 THEN '1001-1500 cc'
        WHEN engine_capacity_cc BETWEEN 1501 AND 2000 THEN '1501-2000 cc'
        WHEN engine_capacity_cc > 2000 THEN '2000+ cc'
        ELSE 'Electric Vehicles'
    END AS cc_bucket,
    COUNT(*) AS car_count,
    FORMAT(AVG(resale_price), 0) AS avg_price
FROM sales_analysis
GROUP BY cc_bucket
ORDER BY MIN(engine_capacity_cc);


-- Check min and max engine capacity 
SELECT 
    MIN(engine_capacity_cc) AS min_cc,
    MAX(engine_capacity_cc) AS max_cc
FROM sales_analysis
WHERE engine_capacity_cc IS NOT NULL;

-- Check missing values in max_power
SELECT 
    COUNT(*) AS total_rows,
    SUM(max_power IS NULL) AS missing_power,
    ROUND(SUM(max_power IS NULL) * 100.0 / COUNT(*), 2) AS pct_missing
FROM sales_analysis;

-- Check missing values in power_unit
SELECT 
    COUNT(*) AS total_rows,
    SUM(power_unit IS NULL) AS missing_power,
    ROUND(SUM(power_unit IS NULL) * 100.0 / COUNT(*), 2) AS pct_missing
FROM sales_analysis;

-- Power vs. price relationship
SELECT 
    power_unit,
    max_power,
    FORMAT(AVG(resale_price), 0) AS avg_price
FROM sales_analysis
GROUP BY power_unit, max_power
ORDER BY max_power;



------------------------------------------------------------
-- 4. OWNERSHIP & USAGE PATTERNS
------------------------------------------------------------

-- Average resale price by owner type with % depreciation
WITH owner_avg AS (
    SELECT 
        owner_type,
        ROUND(AVG(resale_price), 0) AS avg_price,
        COUNT(*) AS total
    FROM sales_analysis
    WHERE owner_type IS NOT NULL
    GROUP BY owner_type
)
SELECT 
    owner_type,
    FORMAT(avg_price, 0) AS avg_resale_price,
    total AS total_cars,
    CONCAT(
        ROUND(
            (1 - avg_price / (SELECT MAX(avg_price) FROM owner_avg)) * 100, 
            2
        ), '%'
    ) AS pct_depreciation
FROM owner_avg
ORDER BY avg_price DESC;

-- Effect of kilometers driven on resale value
SELECT 
    CASE 
        WHEN kms_driven < 20000 THEN '0–20k'
        WHEN kms_driven < 50000 THEN '20k–50k'
        WHEN kms_driven < 100000 THEN '50k–100k'
        ELSE '100k+'
    END AS kms_range,
    FORMAT(AVG(resale_price), 0) AS avg_price,
    COUNT(*) AS total
FROM sales_analysis
GROUP BY kms_range;



------------------------------------------------------------
-- 5. FUEL & TRANSMISSION INSIGHTS
------------------------------------------------------------

-- Average resale price by fuel type
SELECT 
    fuel_type,
    FORMAT(AVG(resale_price), 0) AS avg_price,
    COUNT(*) AS total
FROM sales_analysis
GROUP BY fuel_type;

-- Average resale price by transmission type
SELECT 
    transmission_type,
    FORMAT(AVG(resale_price), 0) AS avg_price,
    COUNT(*) AS total
FROM sales_analysis
GROUP BY transmission_type;



------------------------------------------------------------
-- 6. GEOGRAPHICAL ANALYSIS
------------------------------------------------------------

-- Average resale price by city
SELECT 
    city,
    FORMAT(AVG(resale_price), 0) AS avg_price,
    COUNT(*) AS total
FROM sales_analysis
GROUP BY city
ORDER BY AVG(resale_price) DESC;



------------------------------------------------------------
-- 7. MARKET SHARE BY BRAND
------------------------------------------------------------

SELECT 
    brand_name,
    COUNT(*) AS total_cars,
    ROUND(
        (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sales_analysis)), 
        2
    ) AS market_share_percent
FROM sales_analysis
GROUP BY brand_name
ORDER BY market_share_percent DESC;



------------------------------------------------------------
-- 8. BRAND-WISE MOST SOLD (MOST LISTED) VARIANT
------------------------------------------------------------

WITH ranked_variants AS (
    SELECT 
        brand_name,
        variant_name,
        COUNT(*) AS total_sold,
        RANK() OVER (PARTITION BY brand_name ORDER BY COUNT(*) DESC) AS rank_within_brand
    FROM sales_analysis
    GROUP BY brand_name, variant_name
)
SELECT 
    brand_name,
    variant_name,
    total_sold
FROM ranked_variants
WHERE rank_within_brand = 1
ORDER BY total_sold DESC;



------------------------------------------------------------
-- 9. DISTINCT CAR BRANDS COUNT
------------------------------------------------------------

SELECT 
    COUNT(DISTINCT brand_name) AS total_brands
FROM sales_analysis;



------------------------------------------------------------
-- 10. ENTRY-LEVEL SEGMENT (0–5 LAKH)
------------------------------------------------------------

SELECT 
    brand_name,
    COUNT(*) AS total_cars,
    ROUND(AVG(resale_price), 0) AS avg_price
FROM sales_analysis
WHERE resale_price BETWEEN 0 AND 500000
GROUP BY brand_name
ORDER BY total_cars DESC;



------------------------------------------------------------
-- 11. HIGHEST RESALE VALUE BRANDS (≥ 30 CARS SOLD)
------------------------------------------------------------

SELECT 
    brand_name,
    ROUND(AVG(resale_price), 0) AS avg_resale_price,
    COUNT(*) AS total_cars_sold
FROM sales_analysis
GROUP BY brand_name
HAVING COUNT(*) >= 30
ORDER BY avg_resale_price DESC;



------------------------- END OF FILE -------------------------
