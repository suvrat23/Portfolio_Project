select * 
from Project_Portfolio..CovidDeaths
order by 3,4

--select * from Project_Portfolio..CovidVaccinations
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from Project_Portfolio..CovidDeaths 
order by 1,2

-- Looking a Total Cases vs Total Deaths
-- Shows the percentage of dying if you contract covid in any country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Project_Portfolio..CovidDeaths 
where location = 'United States' and continent is not null
order by 1,2

-- Looking at the Total Cases vs Population
-- Shows what percentage of population got covid

select location, date, total_cases, population, (total_cases/population)*100 as PercentagePopulationInfected
from Project_Portfolio..CovidDeaths 
--where location = 'India'
order by 1,2

-- Looking at countries with highest infection rate compared to population

select location, max(total_cases) as HighestInfectionCount, population, max((total_cases/population))*100 as PercentagePopulationInfected
from Project_Portfolio..CovidDeaths 
--where location = 'India'
Group by location, population
order by PercentagePopulationInfected desc


-- Showing countries with the highest death count per population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from Project_Portfolio..CovidDeaths 
--where location = 'India'
Where continent is not null
Group by location
order by TotalDeathCount desc

-- Breaking Total Death count by Continents

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from Project_Portfolio..CovidDeaths 
--where location = 'India'
Where continent is not null
Group by continent
order by TotalDeathCount desc


-- Showing the continents with the highest death count per population

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from Project_Portfolio..CovidDeaths 
--where location = 'India'
Where continent is not null
Group by continent
order by TotalDeathCount desc


-- Global numbers

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,  (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
from Project_Portfolio..CovidDeaths 
where continent is not null

Order by 1,2


-- Looking at Total Population  vs Vaccination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERt(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated

From Project_Portfolio..CovidDeaths dea
Join Project_Portfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 1, 2, 3

-- USE CTE
With PopvsVac (continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as  (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERt(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated

From Project_Portfolio..CovidDeaths dea
Join Project_Portfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)

Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac


-- TEMP TABLE


-- Creating View to store date for later visuals

Create View PercentPopulatedVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERt(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated

From Project_Portfolio..CovidDeaths dea
Join Project_Portfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select *
From PercentPopulatedVaccinated