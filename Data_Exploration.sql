--Winter Olympics Data Analysis

--This document contains a comprehensive analysis of Winter Olympics data using PostgreSQL queries. The analysis explores athlete participation, medal distribution, and performance metrics across countries and disciplines.

--1.Basic Data Exploration

--First, let's examine the structure of our datasets:


-- View the complete medals dataset
SELECT * FROM medals;

-- View the complete athletes dataset
SELECT * FROM athletes;

--2. Medal Winners Analysis
-- Count of unique athletes who received medals
SELECT COUNT(DISTINCT name) FROM medals;
-- Result: 551 athletes received medals


--3. Country Performance Analysis
-- Country with the highest medal count
SELECT 
    country, 
    COUNT(country) AS total_number_of_medals 
FROM medals
GROUP BY country
ORDER BY total_number_of_medals DESC
LIMIT 1;
--This query identifies the country that won the most medals overall in the Winter Olympics.


--Countries with the lowest medal counts
SELECT 
    country, 
    COUNT(country) AS total_number_of_medals 
FROM medals
GROUP BY country
ORDER BY total_number_of_medals ASC
LIMIT 10;
--This query lists the 10 countries with the fewest medals, highlighting nations with emerging Winter Olympic programs.


-- Country with the most gold medals
SELECT 
    country, 
    COUNT(*) AS total_number_of_gold 
FROM medals
WHERE medal_type = 'Gold'
GROUP BY country
ORDER BY total_number_of_gold DESC
LIMIT 1;
-- Result: USA has the most gold medals


--4. Athlete Participation Analysis
--Country with the highest athlete participation
SELECT 
    country, 
    COUNT(country) AS number_of_participants 
FROM athletes
GROUP BY country
ORDER BY number_of_participants DESC
LIMIT 1;

--This query identifies which country sent the most athletes to the Winter Olympics.

## 5. Efficiency Analysis


-- Medal-to-athlete ratio by country
SELECT 
    m.country,
    COUNT(*) AS total_medals,
    a.total_athletes,
    ROUND(COUNT(*) * 100.0 / a.total_athletes, 2) AS medal_to_athlete_percentage
FROM medals m
JOIN (
    SELECT 
        country, 
        COUNT(*) AS total_athletes
    FROM athletes
    GROUP BY country
) a ON m.country = a.country
GROUP BY m.country, a.total_athletes
ORDER BY medal_to_athlete_percentage DESC;

--This efficiency analysis calculates what percentage of a country's athletes won medals, showcasing which nations maximize their medal outcomes relative to team size.

--6. Medal Distribution Analysis


-- Total number of countries that received medals
SELECT COUNT(DISTINCT(country)) FROM medals;
```

--This query shows the breadth of medal distribution across participating nations.


-- Complete medal breakdown by country and type
SELECT 
    country, 
    medal_type, 
    COUNT(medal_type) AS medal_count 
FROM medals
GROUP BY country, medal_type
ORDER BY country, medal_type ASC;

--This comprehensive breakdown shows each country's distribution of gold, silver, and bronze medals.

--7. Age Distribution Analysis


-- Age distribution of athletes in 5-year buckets
SELECT 
    FLOOR((EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birth_date))/5)*5 AS age_bucket,
    COUNT(*) AS athlete_count
FROM athletes
GROUP BY age_bucket
ORDER BY age_bucket;
```

--This analysis groups athletes into 5-year age ranges to identify the most common age groups in Winter Olympic competition.

--8. Geographic Medal Analysis

-- Medal distribution by country code for visualization
SELECT 
    country,
    COUNT(*) AS total_medals,
    SUM(CASE WHEN medal_type = 'Gold' THEN 1 ELSE 0 END) AS gold
FROM medals
GROUP BY country;


--This query prepares data for geographic visualization, showing total and gold medals by country code.

--9. Gender Analysis
-- Medal distribution by gender category
SELECT 
    CASE
        WHEN sex LIKE '%W%' THEN 'Women'
        WHEN sex LIKE '%M%' THEN 'Men'
        WHEN event LIKE '%W+M%' THEN 'Mixed'
        ELSE 'Unspecified'
    END AS gender_category,
    medal_type,
    COUNT(*) AS medal_count
FROM medals
GROUP BY gender_category, medal_type
ORDER BY gender_category, medal_type;


--This analysis examines medal distribution across gender categories, revealing patterns in men's, women's, and mixed events.

--10. Comprehensive Medal Efficiency Analysis
-- Detailed medal-to-athlete ratio analysis

SELECT 
    m.country,
    COUNT(*) AS total_medals,
    a.total_athletes,
    ROUND(COUNT(*) * 100.0 / a.total_athletes, 2) AS medal_to_athlete_percentage
FROM medals m
JOIN (
    SELECT 
        country, 
        COUNT(*) AS total_athletes
    FROM athletes
    GROUP BY country
) a ON m.country = a.country
GROUP BY m.country, a.total_athletes
ORDER BY medal_to_athlete_percentage DESC;

--This comprehensive efficiency analysis shows which countries are most successful at converting athlete participation into medals won.