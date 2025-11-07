#Project Title: Global Data Center Market Intelligence

**Level**: Intermediate
**Database**: global_data_center_market

## Project Overview

This project simulates real-world market intelligence analysis for global data centers, focusing on understanding metro-level readiness for digital infrastructure expansion. Using PostgreSQL and pgAdmin, the analysis evaluates power capacity, land costs, vacancy rates, hyperscaler activity, cloud demand, and connectivity.

It aims to calculate a readiness score for each metro and identify top-performing regions for future data center development — combining analytical reasoning, SQL skills, and business insight.

** Objectives

Database Setup: Create and populate a global data center market database.

Data Exploration: Explore metrics like power, demand, and connectivity for key metros.

Data Cleaning: Ensure accuracy by validating nulls, duplicates, and numeric ranges.

Data Analysis: Use SQL to compute metrics, correlations, and readiness scores.

Ranking & Insights: Rank metros by readiness and determine key influencing factors.

Visualization: Export results to Looker Studio or ArcGIS for geospatial representation.

## Project Structure
## 1. Database Setup
```sql
CREATE TABLE IF NOT EXISTS global_data_center_market(
  Metro VARCHAR(50),	
  Country VARCHAR(10),
  Power_Capacity_MW INT,
  Land_Cost_USD_per_sqft NUMERIC(10,2),	
  Vacancy_Percent NUMERIC(10,2),
  Hyperscaler_Activity VARCHAR(20),
  Cloud_Demand_Index INT,
  Connectivity_Score INT,
  Year INT
);
```


Dataset: 10 rows of global metros including Dallas, Tokyo, London, Singapore, and Mumbai.

## 2. Data Exploration & Cleaning

Count total rows and unique countries.

Identify metros with missing or inconsistent values.

Verify data types for numeric and categorical columns.

Example Queries:
```sql
SELECT COUNT(*) FROM global_data_center_market;
SELECT DISTINCT country FROM global_data_center_market;
```

## 3. Data Analysis

Key SQL queries include:

** a. Top metros by readiness
```sql
SELECT metro, readiness_score
FROM global_data_center_market
ORDER BY readiness_score DESC
LIMIT 3;
```

** b. Compute average readiness per country
```sql
SELECT country, ROUND(AVG(readiness_score),2) AS avg_readiness_score
FROM global_data_center_market
GROUP BY country;
```

** c. Correlation analysis
```sql
SELECT
  ROUND(CORR(readiness_score, cloud_demand_index)::numeric,3) AS corr_demand,
  ROUND(CORR(readiness_score, connectivity_score)::numeric,3) AS corr_connectivity,
  ROUND(CORR(readiness_score, land_cost_usd_per_sqft)::numeric,3) AS corr_land_cost,
  ROUND(CORR(readiness_score, vacancy_percent)::numeric,3) AS corr_vacancy
FROM global_data_center_market;
```

** d. Readiness formula
```sql
UPDATE global_data_center_market
SET readiness_score = 
  ROUND(
    (0.4 * cloud_demand_index)
    + (0.3 * connectivity_score)
    - (0.2 * (land_cost_usd_per_sqft / 2))
    - (0.1 * vacancy_percent),
  2);
```

## Findings

Top Metros: Dallas, Tokyo, and London lead with the highest readiness scores.

Key Drivers: Cloud demand (correlation ≈ 0.97) and connectivity (≈ 0.79) most strongly affect readiness.

Cost Impact: High land cost and vacancy negatively affect readiness.

Regional Insights: The U.S., Japan, and U.K. metros show strong infrastructure and hyperscaler maturity.

Business Insight: Metros with high demand and low cost provide optimal expansion potential.

## Reports & Visualizations

Looker Studio Dashboard:

Geo Map: Metros sized by readiness score.

Bar Chart: Readiness rank comparison.

Scatter Plot: Demand vs. Connectivity correlation.

Table: Metro-wise breakdown with key metrics.

## ArcGIS Map:

Latitude-longitude visualization with readiness-based color coding.

Dynamic popups showing metro, country, and readiness metrics.

## Findings Summary

Dallas has the highest readiness (62.13) driven by strong demand and connectivity.

Tokyo and London follow with competitive infrastructure strength.

Global readiness trends show that connectivity and demand are the most predictive factors.

Countries with Medium hyperscaler activity average ~56 readiness vs. High activity metros averaging ~61.

## Conclusion

This project highlights how SQL can be used to conduct real-world market analysis.
By integrating business logic into readiness modeling, it demonstrates how cloud demand, connectivity, cost, and vacancy can guide data-driven investment decisions for global data center expansion.

