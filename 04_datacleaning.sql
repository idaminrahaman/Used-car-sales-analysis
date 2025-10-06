/*===============================================================
  STEP 1: CLEAN AND STANDARDIZE NUMERIC COLUMNS
===============================================================*/

-- Clean and standardize resale_price
UPDATE sales_analysis
SET resale_price = CASE
        WHEN resale_price LIKE '%Lakh%' THEN CAST(
            REPLACE(REPLACE(REPLACE(REPLACE(resale_price, '₹', ''), 'Lakh', ''), ',', ''), ' ', '')
            AS DECIMAL(15, 2)
        ) * 100000
        WHEN resale_price LIKE '%Crore%' THEN CAST(
            REPLACE(REPLACE(REPLACE(REPLACE(resale_price, '₹', ''), 'Crore', ''), ',', ''), ' ', '')
            AS DECIMAL(15, 2)
        ) * 10000000
        ELSE CAST(REPLACE(REPLACE(REPLACE(resale_price, '₹', ''), ',', ''), ' ', '') AS DECIMAL(15, 2))
    END;

ALTER TABLE sales_analysis
MODIFY resale_price INT;


-- Normalize registered_year
UPDATE sales_analysis
SET registered_year = CASE
        WHEN registered_year REGEXP '^[0-9]{4}$' THEN registered_year
        ELSE RIGHT(registered_year, 4)
    END;

UPDATE sales_analysis
SET registered_year = NULL
WHERE registered_year = '';

ALTER TABLE sales_analysis
MODIFY registered_year INT;


-- Clean engine_capacity_cc
ALTER TABLE sales_analysis
RENAME COLUMN engine_capacity TO engine_capacity_cc;

UPDATE sales_analysis
SET engine_capacity_cc = TRIM(REPLACE(engine_capacity_cc, 'cc', ''));

UPDATE sales_analysis
SET engine_capacity_cc = NULL
WHERE engine_capacity_cc = '' OR engine_capacity_cc = 0;

ALTER TABLE sales_analysis
MODIFY engine_capacity_cc INT;


-- Clean kms_driven column
UPDATE sales_analysis
SET kms_driven = TRIM(REPLACE(REPLACE(kms_driven, 'Kms', ''), ',', ''));

UPDATE sales_analysis
SET kms_driven = NULL
WHERE kms_driven = '';

ALTER TABLE sales_analysis
MODIFY kms_driven INT;


-- Normalize max_power and extract power_unit
ALTER TABLE sales_analysis
ADD COLUMN power_unit VARCHAR(5);

UPDATE sales_analysis
SET power_unit = CASE
        WHEN max_power LIKE '%PS%'  THEN 'PS'
        WHEN max_power LIKE '%bhp%' THEN 'BHP'
        ELSE NULL
    END;

UPDATE sales_analysis
SET max_power = REGEXP_SUBSTR(max_power, '^[0-9]+(\\.[0-9]+)?');

UPDATE sales_analysis
SET max_power = CASE
        WHEN power_unit = 'PS' THEN CAST(max_power AS DECIMAL(10, 2)) * 0.9863
        ELSE CAST(max_power AS DECIMAL(10, 2))
    END;

ALTER TABLE sales_analysis
MODIFY max_power DECIMAL(10, 2);


-- Clean seats column
UPDATE sales_analysis
SET seats = NULL
WHERE seats = '';

ALTER TABLE sales_analysis
MODIFY seats TINYINT;


-- Clean mileage column
UPDATE sales_analysis
SET mileage = TRIM(REPLACE(REPLACE(mileage, 'kmpl', ''), 'km/kg', ''));

UPDATE sales_analysis
SET mileage = NULL
WHERE mileage = '';

ALTER TABLE sales_analysis
MODIFY mileage DECIMAL(5, 2);



/*===============================================================
  STEP 2: RENAME AND SPLIT COLUMNS
===============================================================*/

-- Rename full_name → model_name
ALTER TABLE sales_analysis
RENAME COLUMN full_name TO model_name;

-- Split model_name into brand_name and variant_name
ALTER TABLE sales_analysis
ADD COLUMN brand_name VARCHAR(50) AFTER id,
ADD COLUMN variant_name VARCHAR(255) AFTER brand_name;

UPDATE sales_analysis
SET 
    brand_name   = SUBSTRING_INDEX(SUBSTRING_INDEX(model_name, ' ', 2), ' ', -1),
    variant_name = TRIM(SUBSTRING(model_name, LENGTH(SUBSTRING_INDEX(model_name, ' ', 2)) + 2));

ALTER TABLE sales_analysis
DROP COLUMN model_name;



/*===============================================================
  STEP 3: CLEAN INSURANCE COLUMN
===============================================================*/

UPDATE sales_analysis
SET insurance = NULL
WHERE insurance IN ('1', '2', '');



/*===============================================================
  STEP 4: STANDARDIZE TEXT AND HANDLE BLANKS
===============================================================*/

-- Standardize brand names
UPDATE sales_analysis
SET brand_name = 'Maruti Suzuki'
WHERE brand_name = 'Maruti';

UPDATE sales_analysis
SET brand_name = 'Land Rover'
WHERE brand_name = 'Land';


-- Convert blank strings to NULL across all columns
UPDATE sales_analysis
SET
  brand_name         = NULLIF(TRIM(brand_name), ''),
  variant_name       = NULLIF(TRIM(variant_name), ''),
  resale_price       = NULLIF(TRIM(resale_price), ''),
  registered_year    = NULLIF(TRIM(registered_year), ''),
  engine_capacity_cc = NULLIF(TRIM(engine_capacity_cc), ''),
  insurance          = NULLIF(TRIM(insurance), ''),
  transmission_type  = NULLIF(TRIM(transmission_type), ''),
  kms_driven         = NULLIF(TRIM(kms_driven), ''),
  owner_type         = NULLIF(TRIM(owner_type), ''),
  fuel_type          = NULLIF(TRIM(fuel_type), ''),
  max_power          = NULLIF(TRIM(max_power), ''),
  seats              = NULLIF(TRIM(seats), ''),
  mileage            = NULLIF(TRIM(mileage), ''),
  body_type          = NULLIF(TRIM(body_type), ''),
  city               = NULLIF(TRIM(city), ''),
  power_unit         = NULLIF(TRIM(power_unit), '');


-- Set 0 engine capacity to NULL for EVs
UPDATE sales_analysis
SET engine_capacity_cc = NULL
WHERE engine_capacity_cc = 0;



/*===============================================================
  STEP 5: VALIDATION AND QUALITY CHECKS
===============================================================*/

-- Count NULL values across all key columns
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN brand_name IS NULL         THEN 1 ELSE 0 END) AS null_brand_name,
    SUM(CASE WHEN variant_name IS NULL       THEN 1 ELSE 0 END) AS null_variant_name,
    SUM(CASE WHEN resale_price IS NULL       THEN 1 ELSE 0 END) AS null_resale_price,
    SUM(CASE WHEN registered_year IS NULL    THEN 1 ELSE 0 END) AS null_registered_year,
    SUM(CASE WHEN engine_capacity_cc IS NULL THEN 1 ELSE 0 END) AS null_engine_capacity_cc,
    SUM(CASE WHEN kms_driven IS NULL         THEN 1 ELSE 0 END) AS null_kms_driven,
    SUM(CASE WHEN max_power IS NULL          THEN 1 ELSE 0 END) AS null_max_power,
    SUM(CASE WHEN power_unit IS NULL         THEN 1 ELSE 0 END) AS null_power_unit,
    SUM(CASE WHEN seats IS NULL              THEN 1 ELSE 0 END) AS null_seats,
    SUM(CASE WHEN mileage IS NULL            THEN 1 ELSE 0 END) AS null_mileage,
    SUM(CASE WHEN owner_type IS NULL         THEN 1 ELSE 0 END) AS null_owner_type,
    SUM(CASE WHEN transmission_type IS NULL  THEN 1 ELSE 0 END) AS null_transmission_type,
    SUM(CASE WHEN fuel_type IS NULL          THEN 1 ELSE 0 END) AS null_fuel_type,
    SUM(CASE WHEN body_type IS NULL          THEN 1 ELSE 0 END) AS null_body_type,
    SUM(CASE WHEN city IS NULL               THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN insurance IS NULL          THEN 1 ELSE 0 END) AS null_insurance
FROM sales_analysis;


-- Identify any remaining blank or invalid entries
SELECT *
FROM sales_analysis
WHERE brand_name = ''
   OR variant_name = ''
   OR resale_price = ''
   OR registered_year = ''
   OR engine_capacity_cc = ''
   OR insurance = ''
   OR transmission_type = ''
   OR kms_driven = ''
   OR owner_type = ''
   OR fuel_type = ''
   OR max_power = ''
   OR seats = ''
   OR mileage = ''
   OR body_type = ''
   OR city = ''
   OR power_unit = '';

------------------------END OF PAGE----------------------------