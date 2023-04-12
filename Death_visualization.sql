/* The data that used in this project went from 2020-01-01 to 2023-04-10*/

-- The data that are used 
select location,date, total_cases,new_cases,total_deaths,population
from Portfolio_Project..coviddeaths$
order by location,date;

-- Change the datatype of  total_cases,total_deaths nvarchar to float
ALTER TABLE Portfolio_Project..coviddeaths$ ALTER COLUMN total_cases float;
ALTER TABLE Portfolio_Project..coviddeaths$ ALTER COLUMN total_deaths float;

--Total Cases vs Total Deaths
--The percentage of deaths in India During Pandemic

select location,date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Portfolio_Project..coviddeaths$
where location = 'India'
order by location,date;

--Total Cases vs Population
--Percentage  of population that infected by Covid

select location,date, population,total_cases, (total_cases/population)*100 as 'InfectedPercentage'
from Portfolio_Project..coviddeaths$
where location = 'India'
order by location,date;

--Country with highest infection rate
select location, population,MAX(total_cases), MAX((total_cases/population))*100 as 'HighestInfectedPercentage'
from Portfolio_Project..coviddeaths$
where continent is not null
group by location,population
order by HighestInfectedPercentage desc;

--Highest death count by Country name
select location,MAX(total_deaths) as 'Total Death Count'
from Portfolio_Project..coviddeaths$
where continent is not null
group by location
order by 'Total Death Count' desc;

--Total death count by Continent
select continent,sum(total_deaths) as 'Total Death Count'
from Portfolio_Project..coviddeaths$
where continent is not  null
group by continent
order by 'Total Death Count' desc;

--Total number of new cases day by day
select date,sum(new_cases) as Totalnewcases,sum(new_deaths) as TotalNewDeaths,(sum(new_deaths)/nullif(sum(new_cases),0)) as DeathPercentage
from Portfolio_Project..coviddeaths$
where continent is not  null 
group by date
order by 1,2;

--Total cases till date
select sum(new_cases) as Totalnewcases,sum(new_deaths) as TotalNewDeaths,(sum(new_deaths)/nullif(sum(new_cases),0)) as DeathPercentage
from Portfolio_Project..coviddeaths$
order by 1,2;


