# Total records

SELECT COUNT(*) FROM cap07.covid_mortes;
SELECT COUNT(*) FROM cap07.covid_vacinacao;

# Changing the date to the proper format

SET SQL_SAFE_UPDATES = 0;

UPDATE cap07.covid_mortes 
SET date = str_to_date(date,'%d/%m/%y');

UPDATE cap07.covid_vacinacao 
SET date = str_to_date(date,'%d/%m/%y');

SET SQL_SAFE_UPDATES = 1;

# Average deaths by country

SELECT location,
       ROUND(AVG(total_deaths),2) AS MediaMortos
FROM cap07.covid_mortes 
GROUP BY location
ORDER BY MediaMortos DESC;

# Proportion of deaths in relation to total cases in Brazil

SELECT date,
       location, 
       total_cases,
       total_deaths,
       (total_deaths / total_cases) * 100 AS PercentualMortes
FROM cap07.covid_mortes  
WHERE location = "Brazil" 
ORDER BY 1 DESC;

# Average proportion between the total number of cases and the population of each locality

SELECT location,
       AVG((total_cases / population) * 100) AS PercentualPopulacao
FROM cap07.covid_mortes  
GROUP BY location
ORDER BY PercentualPopulacao DESC;

# Countries with the highest number of deaths?

SELECT location, 
       MAX(CAST(total_deaths AS UNSIGNED)) AS MaiorContagemMortes
FROM cap07.covid_mortes 
WHERE continent IS NOT NULL 
GROUP BY location
ORDER BY MaiorContagemMortes DESC;

# Percentage of deaths per day

SELECT date,
       SUM(new_cases) as total_cases, 
       SUM(CAST(new_deaths AS UNSIGNED)) as total_deaths, 
       (SUM(CAST(new_deaths AS UNSIGNED)) / SUM(new_cases)) * 100 as PercentMortes
FROM cap07.covid_mortes 
WHERE continent IS NOT NULL 
GROUP BY date 
ORDER BY 1,2;

# Number of new vaccinates and the moving average of new vaccinates over time by location (South America)

SELECT mortos.continent,
       mortos.location,
       mortos.date,
       vacinados.new_vaccinations,
       AVG(CAST(vacinados.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY mortos.location ORDER BY mortos.date) as MediaMovelVacinados
FROM cap07.covid_mortes mortos 
JOIN cap07.covid_vacinacao vacinados
ON mortos.location = vacinados.location 
AND mortos.date = vacinados.date
WHERE mortos.continent = 'South America'
ORDER BY 2,3;

