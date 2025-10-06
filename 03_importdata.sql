-- Active: 1756533320549@@localhost@3306@used_car_sales_db
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/BMW_sales_data_(2010-2024).csv'
INTO TABLE sales_analysis
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Model, Year, Region, Color, Fuel_Type, Transmission, Engine_Size_L, Mileage_KM, Price_USD, Sales_Volume, Sales_Classification);

SELECT * FROM sales_analysis LIMIT 10;