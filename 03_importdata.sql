LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/car_resale_prices.csv'
INTO TABLE sales_analysis
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id,full_name,resale_price,registered_year,engine_capacity,insurance,transmission_type,kms_driven,owner_type,fuel_type,max_power,seats,mileage,body_type,city
);

SELECT * FROM sales_analysis LIMIT 10;
