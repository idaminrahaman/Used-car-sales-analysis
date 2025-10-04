DROP DATABASE IF EXISTS used_car_sales_db;
CREATE DATABASE used_car_sales_db;
USE used_car_sales_db;
DROP TABLE IF EXISTS sales_analysis;

DROP TABLE IF EXISTS sales_analysis;

CREATE TABLE sales_analysis (
    id INT PRIMARY KEY,                        -- Use the CSV id column
    full_name VARCHAR(100) NOT NULL,
    resale_price VARCHAR(30),
    registered_year VARCHAR(50),
    engine_capacity VARCHAR(50),
    insurance VARCHAR(50),
    transmission_type VARCHAR(20),
    kms_driven VARCHAR(20),
    owner_type VARCHAR(20),
    fuel_type VARCHAR(20),
    max_power VARCHAR(50),
    seats VARCHAR(50),
    mileage VARCHAR(50),
    body_type VARCHAR(50),
    city VARCHAR(50)
);
