create table IF NOT EXISTS global_data_center_market(
Metro varchar(50),	
Country	varchar(10),
Power_Capacity_MW INT,
Land_Cost_USD_per_sqft Numeric(10,2),	
Vacancy_Percent	Numeric(10,2),
Hyperscaler_Activity varchar(20),
Cloud_Demand_Index INT,
Connectivity_Score INT,
Year INT
);
select * from global_data_center_market;

--1.How many total rows are in your dataset?
SELECT COUNT(*) FROM global_data_center_market;

--2.List all metro names and their countries?
SELECT metro, country 
FROM global_data_center_market;

--3.Show only metros located in the USA?
SELECT metro, country 
FROM global_data_center_market 
WHERE country = 'USA';

--4.What is the average land cost per square foot across all metros?
SELECT ROUND(AVG(land_cost_usd_per_sqft), 2) AS avg_land_cost
FROM global_data_center_market;

--5.Which metro has the highest power capacity (MW)?
SELECT metro, power_capacity_mw
FROM global_data_center_market
ORDER BY power_capacity_mw DESC
LIMIT 1;

--6.Find metros where the vacancy rate is below 6%?
SELECT metro, vacancy_percent
FROM global_data_center_market
WHERE vacancy_percent < 6.00;

--7.What is the minimum and maximum power capacity in your dataset?
SELECT MIN(power_capacity_mw) AS min_capacity,
       MAX(power_capacity_mw) AS max_capacity
FROM global_data_center_market;

--8.Retrieve metros with medium hyperscaler activity?
SELECT metro, hyperscaler_activity
FROM global_data_center_market
WHERE hyperscaler_activity = 'Medium';

--9.Display all columns but only for year = 2024?
SELECT *
FROM global_data_center_market
WHERE year = 2024;

--10.Show all metros sorted by power capacity descending?
SELECT metro, power_capacity_mw
FROM global_data_center_market
ORDER BY power_capacity_mw DESC;

--11.Calculate the average vacancy rate per country?
SELECT country, 
       ROUND(AVG(vacancy_percent), 2) AS average_vacancy
FROM global_data_center_market
GROUP BY country
ORDER BY average_vacancy ASC;

--12.Which country has the lowest average land cost?
SELECT country,
       ROUND(AVG(land_cost_usd_per_sqft), 2) AS avg_land_cost
FROM global_data_center_market
GROUP BY country
ORDER BY avg_land_cost ASC
LIMIT 1;

--13.Find metros where cloud demand index > 90 and vacancy < 7?
SELECT metro, cloud_demand_index, vacancy_percent
FROM global_data_center_market
WHERE cloud_demand_index > 90
  AND vacancy_percent < 7.00;

--14.Count how many metros fall under each hyperscaler activity level?
SELECT hyperscaler_activity, COUNT(*) AS metro_count
FROM global_data_center_market
GROUP BY hyperscaler_activity
ORDER BY metro_count DESC;

--15.Which metros have a connectivity score greater than 85?
SELECT metro, connectivity_score
FROM global_data_center_market
WHERE connectivity_score > 85
ORDER BY connectivity_score DESC;

--16.Find metros that have both high demand and high connectivity?
SELECT metro, cloud_demand_index, connectivity_score
FROM global_data_center_market
WHERE cloud_demand_index > 90
  AND connectivity_score > 85
ORDER BY cloud_demand_index DESC, connectivity_score DESC;

--17.For each country, calculate total power capacity (MW)?
SELECT country, SUM(power_capacity_mw) AS total_capacity_mw
FROM global_data_center_market
GROUP BY country
ORDER BY total_capacity_mw DESC;

--18.Display metros where land cost < 25 and power capacity > 800?
SELECT metro, land_cost_usd_per_sqft, power_capacity_mw
FROM global_data_center_market
WHERE land_cost_usd_per_sqft < 25
  AND power_capacity_mw > 800
ORDER BY power_capacity_mw DESC;

--19.Find the top 3 countries by total power capacity?
SELECT country, SUM(power_capacity_mw) AS total_capacity_mw
FROM global_data_center_market
GROUP BY country
ORDER BY total_capacity_mw DESC
LIMIT 3;

--20.Get metros with vacancy below the average vacancy rate?
SELECT metro, vacancy_percent
FROM global_data_center_market
WHERE vacancy_percent < (
    SELECT AVG(vacancy_percent)
    FROM global_data_center_market
)
ORDER BY vacancy_percent ASC;

--21. Add new column name readiness_score?
ALTER TABLE global_data_center_market
ADD COLUMN readiness_score NUMERIC(10,2);

--22.Create a readiness score combining these factors?
UPDATE global_data_center_market
SET readiness_score = 
  ROUND(
    (0.4 * cloud_demand_index)
    + (0.3 * connectivity_score)
    - (0.2 * (land_cost_usd_per_sqft / 2))
    - (0.1 * vacancy_percent),
  2);

--22.Rank metros based on readiness score?
select 
   metro,
   country,
   readiness_score, 
   rank() over( order by readiness_score desc) as rank 
from global_data_center_market
order by readiness_score desc;

--23.Which metro ranks #1 for overall readiness?
select metro 
from global_data_center_market 
order by readiness_score desc limit 1;

--24.Which 3 metros would you recommend for new data center expansion? 
select metro 
from global_data_center_market 
order by readiness_score desc limit 3;

--25.Calculate the average readiness score per country?
select 
  ROUND(avg(readiness_score),2) AS avg_readiness_score, country 
from global_data_center_market 
group by country
order by avg_readiness_score desc;

--26.Find metros where readiness_score > 80?
select 
   metro, 
   readiness_score 
from global_data_center_market 
   where readiness_score > 60;

--27.Which factor (demand, cost, or connectivity) most influences high readiness?
SELECT
  ROUND(CORR(readiness_score, cloud_demand_index)::numeric, 3) AS corr_demand,
  ROUND(CORR(readiness_score, connectivity_score)::numeric, 3) AS corr_connectivity,
  ROUND(CORR(readiness_score, land_cost_usd_per_sqft):: numeric, 3) AS corr_land_cost,
  ROUND(CORR(readiness_score, vacancy_percent):: numeric, 3) AS corr_vacancy
FROM global_data_center_market;

--28. Compare the average readiness between metros with 'High' vs 'Medium' hyperscaler activity?
select
    hyperscaler_activity, 
	Round(avg(readiness_score), 2) as avg_readiness_score, 
	count(*) as total_metros
from global_data_center_market 
group by hyperscaler_activity 
order by avg_readiness_score desc;

--29.Find the correlation between demand and connectivity?
SELECT 
   ROUND(CORR(cloud_demand_index, connectivity_score)::numeric, 3) AS corr_demand_connectivity
FROM global_data_center_market;

--30.Write a short insight summary?
--Summary (no query; explained in README)