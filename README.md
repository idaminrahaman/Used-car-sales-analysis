# Used Car Market Analysis (India, 2002–2023)

## Overview
This project presents an exploratory data analysis (EDA) of India’s used car market from 2002 to 2023. The dataset covers 33 major automobile brands and provides insights into pricing trends, ownership impact, fuel preferences, and city-wise sales patterns.  
The goal is to identify key factors influencing resale value and to recommend strategies for used car dealerships.

---

## Data Cleaning and Preparation
- Standardized resale prices by removing symbols (₹, Lakh, Crore) and converting them into numeric values.  
- Extracted valid registration years and converted them to integers.  
- Cleaned and converted engine capacity, mileage, power, and kilometer readings into numerical formats.  
- Split model names into `brand_name` and `variant_name`.  
- Unified inconsistent brand names (e.g., “Maruti” → “Maruti Suzuki”).  
- Replaced empty or placeholder values with NULLs.  
- Dropped approximately 5.5% of rows containing invalid or missing data.  

---

## Key Insights
- Top-selling brands: Maruti Suzuki (29%), Hyundai (21%), Honda (11%).  
- Average resale price for Maruti Suzuki and Hyundai cars: ₹5–6 lakhs.  
- Luxury brands with the highest resale value: Land Rover, BMW, Mercedes-Benz, Volvo.  
- Brands with the lowest resale value: Chevrolet, Fiat, Datsun (discontinued in India).  
- Ownership effect on resale price:  
  - Second owner: -19%  
  - Third owner: -42%  
  - Fourth owner: -60%  
- Cars with lower mileage command higher resale prices.  
- Diesel vehicles generally retain higher resale value than petrol.  
- City-wise resale value: Mumbai highest, followed by Delhi and Chennai.  

---

## Delhi Market Findings
- Dominated by mid-range cars priced between ₹15–30 lakhs.  
- Maruti Suzuki and Hyundai account for most sales.  
- Popular variants: Baleno 1.2 Delta, Grand i10 Sportz, Swift VXI, Swift Dzire, Wagon R.  
- Cars aged 4–8 years make up nearly 50% of sales.  
- Petrol vehicles form about two-thirds of the market.  
- Manual transmission cars represent roughly 70% of sales.  

---

## Recommendations
- Delhi offers the strongest opportunity for mid-range used car dealerships.  
- Focus inventory on Maruti Suzuki and Hyundai models aged 4–8 years.  
- Maintain a majority of petrol and manual transmission cars.  
- For the luxury segment, cities like Mumbai offer higher resale potential.  
- Prioritize first-owner vehicles with mileage below 50,000 km for better profit margins.  

---

## Tools and Technologies
- Python (Pandas, NumPy, Matplotlib, Seaborn)  
- MySQL for database management and querying
- Power BI for visual representation

---

## Author
**Idamin Rahaman**  
India
email: idaminrahaman8@gmail.com
