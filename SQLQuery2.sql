select location, date, total_cases, new_cases, total_deaths,population
from CovidDeaths$
order by 1,2



-- looking at total cases vs total deaths
-- shows the likelihood to die from covid in your country (or any other country)

select (total_deaths / total_cases)*100 as precentage_of_deaths,location,total_cases,total_deaths,date 
from CovidDeaths$
where location like '%israel%'
order by date



-- looking at total cases vs population
-- shows the precentage of who was sick from the entire population
select location,total_cases,population,(total_cases/population)* 100 as covid_precentage, date
from CovidDeaths$
where location like '%israel%'
order by date


-- looking to countries with highest infecation rate compared to population 

select location, max(total_cases) as highest_cases, max((total_cases/population)* 100) as covid_precntage
from CovidDeaths$
group by location
order by covid_precntage desc 

-- showing the countries with the highest death count per population 

select max(cast(total_deaths as int) ) as total_deaths , location, population 
from CovidDeaths$
where continent is not null 
group by  location, population
order by total_deaths desc

-- showing the same for the continent

select max(cast(total_deaths as int) ) as total_deaths , continent 
from CovidDeaths$
where continent is not null
group by  continent
order by total_deaths desc



-- GLOBAL NUMBERS

SELECT  
    SUM(new_cases) AS total_new_cases, 
    SUM(CAST(new_deaths AS INT)) AS total_new_deaths, 
    CASE 
        WHEN SUM(new_cases) > 0 
        THEN (SUM(CAST(new_deaths AS INT)) / SUM(new_cases)) * 100
        ELSE 0
    END AS percentage_of_deaths
FROM CovidDeaths$
where continent is not null
order by 1,2 

-- looking at total population vs vaccinations 

WITH PopVsVacc (continent, location, date, population, new_vaccinations, rolling_peoples_vacc)
AS
(
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vacc.new_vaccinations,
        SUM(CAST(vacc.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS rolling_peoples_vacc
    FROM
        CovidVaccinations$ AS vacc
    JOIN
        CovidDeaths$ AS dea ON vacc.location = dea.location
            AND dea.date = vacc.date
    WHERE
        dea.continent IS NOT NULL
)
SELECT *, (rolling_peoples_vacc/population) * 100 as precenatage
FROM PopVsVacc;




-- creating views to store data for later 

-- Terminate the previous statement with a semicolon
;

-- Create the view with the CTE
CREATE VIEW PercentagePopulationVaccinated AS
WITH PopVsVacc (continent, location, date, population, new_vaccinations, rolling_peoples_vacc)
AS
(
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vacc.new_vaccinations,
        SUM(CAST(vacc.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS rolling_peoples_vacc
    FROM
        CovidVaccinations$ AS vacc
    JOIN
        CovidDeaths$ AS dea ON vacc.location = dea.location
            AND dea.date = vacc.date
    WHERE
        dea.continent IS NOT NULL
)
SELECT *, (rolling_peoples_vacc/population) * 100 AS percentage
FROM PopVsVacc;




-- creating another view for precentage of global death 

create view PrecentageGlobalDeath as 
(
SELECT  
    SUM(new_cases) AS total_new_cases, 
    SUM(CAST(new_deaths AS INT)) AS total_new_deaths, 
    CASE 
        WHEN SUM(new_cases) > 0 
        THEN (SUM(CAST(new_deaths AS INT)) / SUM(new_cases)) * 100
        ELSE 0
    END AS percentage_of_deaths
FROM CovidDeaths$
where continent is not null

);


-- creating antoher view 

create view TotalDeath_PerContinent as(
select max(cast(total_deaths as int) ) as total_deaths , continent 
from CovidDeaths$
where continent is not null
group by  continent
);

