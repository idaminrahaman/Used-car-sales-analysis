# Used Car Resale Analysis (SQL Project)

## Overview
This project explores Used Car Resale Data (2002–2023) sourced from Kaggle, analyzing trends, market share, and performance metrics using MySQL.
The goal is to understand factors influencing car resale values, brand dominance, and ownership patterns — transforming raw data into actionable business insights.

---

## Phase 1: Data Cleaning & Preprocessing
Performed extensive data cleaning to prepare the dataset for analysis:
- Removed inconsistencies and standardized formats.
- Handled missing and null values.
- Converted textual price formats (e.g., “₹5 Lakh”) into numeric values.
- Split combined columns like model name → brand + variant.
- Cleaned columns for engine_capacity_cc, kms_driven, mileage, and max_power.
- Standardized brand names (e.g., Maruti → Maruti Suzuki, Land → Land Rover).

---

## Phase 2: Exploratory Data Analysis (EDA)
Conducted SQL-based EDA to uncover patterns and relationships:

### Yearly Trends
- Analyzed average resale price by year and calculated year-on-year percentage change.

### Brand & Variant Insights
- Computed min, max, and average resale prices per brand.
- Identified most frequently listed car variants.

### Engine & Performance
- Segmented cars by engine capacity (cc buckets).
- Examined how power output (BHP/PS) relates to resale prices.
- Separated electric vehicles from combustion-engine cars.

### Ownership & Usage Patterns
- Compared resale prices by owner type (1st, 2nd, 3rd owner).
- Analyzed price depreciation and effect of kilometers driven on resale value.

### Fuel & Transmission
- Studied resale trends across fuel types and transmission modes (manual/automatic).

### Geographical Insights
- Compared average resale price by city.

### Market Insights
- Calculated brand-wise market share.
- Identified dominant brands in the entry-level (0–5 Lakh) segment.
- Highlighted top brands by resale value (min. 30 cars sold).

---

## Key Business Insights
- Maruti Suzuki dominates the entry-level market segment.
- Premium brands retain higher resale values with lower depreciation.
- Manual cars and diesel variants show higher listings than automatics.
- First-owner cars fetch significantly higher resale prices than subsequent owners.
- Engine capacity and power positively correlate with resale value — up to a threshold.

---

## Files Included
| File Name | Description |
|------------|-------------|
| schema.sql | Database and table creation scripts |
| load_data.sql | Data import and initial setup |
| data_cleaning.sql | Data cleaning and preprocessing steps |
| eda.sql | Exploratory data analysis queries |


---

## Tools & Technologies
- SQL (MySQL Workbench)
- Kaggle Dataset
- Excel / Power BI (optional for visualization)

---

## Dataset Source
[Kaggle - Used Car Dataset (India)](https://www.kaggle.com/)

---

## Next Steps
- Build a dashboard in Power BI or Tableau for visualization.
- Implement predictive modeling to estimate resale value using ML.

---

## Author
**Idamin Rahaman**  
Data Analyst | SQL | Python | Power BI  
[LinkedIn](https://linkedin.com) • [GitHub](https://github.com)
