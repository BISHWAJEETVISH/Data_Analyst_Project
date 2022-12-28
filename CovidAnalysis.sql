
--COVID DATA ANALYSIS
--
select *
from portfolio_project..CovidVaccinations$
order by 3,4

select *
from portfolio_project..['coviddeaths-1$']
order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from portfolio_project..['coviddeaths-1$']
order by 1,2

--total cases vs total deaths
--shows likelyhood of dying if you contract covid in your country
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathsPercentage
from portfolio_project..['coviddeaths-1$']
where location like '%ndia%'         --(For INDIA)
order by 1,2

--Looking at Total cases vs Population
--shows what percentage of population got Covid
select location,date,population,total_cases,(total_cases/population)*100 as CovidPercentage
from portfolio_project..['coviddeaths-1$']
where location like '%ndia%'         --(For INDIA)
order by 1,2

--Looking at countries with Highest Infection Rate compared to population
select location,population,MAX(total_cases) as HighestInfectioncount,MAX((total_cases/population))*100 as PercentagePopulationInfected
from portfolio_project..['coviddeaths-1$']
GROUP BY  location,population
order by PercentagePopulationInfected DESC

--Showing the countries with Highest Death Count per Popultaion
select location,MAX(cast((total_deaths)as int)) as TotalDeathCount
from portfolio_project..['coviddeaths-1$']
where continent is not null
GROUP BY  location
order by TotalDeathCount DESC

--Lets break down Things By continent showing the continent with Highest Death Count per Popultaion
select location,MAX(cast((total_deaths)as int)) as TotalDeathCount
from portfolio_project..['coviddeaths-1$']
where continent is  null
GROUP BY  location
order by TotalDeathCount DESC

--GLOBAL NUMBERS
--Based on Date
select date,SUM(new_cases) as total_cases,SUM(cast((new_deaths)as int)) as total_deaths,(SUM(cast((new_deaths)as int))/SUM(new_cases))*100 as DeathPercentage
from portfolio_project..['coviddeaths-1$']
where continent is not null
GROUP BY date
order by 1,2

--world deaths and percentage
select SUM(new_cases) as total_cases,SUM(cast((new_deaths)as int)) as total_deaths,(SUM(cast((new_deaths)as int))/SUM(new_cases))*100 as DeathPercentage
from portfolio_project..['coviddeaths-2$']
where continent is not null
--GROUP BY date
order by 1,2


--Looking at total vaccinations vs population

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from portfolio_project..['coviddeaths-1$'] dea JOIN portfolio_project..CovidVaccinations$ vac
   ON dea.location=vac.location
   and dea.date=vac.date
where dea.continent is not null
order by 2,3

--partition by sum of vaccinations 

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(convert(int,vac.new_vaccinations)) OVER(partition by dea.location 
                 order by dea.location,dea.date) as RollingPeopleVaccinated
from portfolio_project..['coviddeaths-2$'] dea JOIN portfolio_project..CovidVaccinations$ vac
   ON dea.location=vac.location
   and dea.date=vac.date
where dea.continent is not null
order by 2,3

--USE CTE
with PopVsVac(continent,Location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(convert(int,vac.new_vaccinations)) OVER(partition by dea.location 
                 order by dea.location,dea.date) as RollingPeopleVaccinated
from portfolio_project..['coviddeaths-2$'] dea JOIN portfolio_project..CovidVaccinations$ vac
   ON dea.location=vac.location
   and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/population)*100
from PopVsVac