-- Looking at total cases versus total deaths

Select location, date, total cases, total deaths, (total deaths/total cases)*100 as DeathPercentage
From CovidDeaths
Order by 1, 2
  
-- Specifying the country
  
Select location, date, total cases, total deaths, (total deaths/total cases)*100 as DeathPercentage
From CovidDeaths
Where location like '%kenya%'
Order by 1, 2
  
-- Total cases v/s population
  
Select location, date, total cases, population, (total cases/population)*100 as PercentageInfected
From CovidDeaths
Order by 1, 2
  
-- Looking at countries with the highest infection rate compared to population
  
Select location, population, MAX(total cases) as HighestInfectionCount, MAX(total cases/population)*100 as PercentPopulationInfected
From CovidDeaths
Group by location, population
Order by PercentPopulationInfected desc
  
-- Showing countries with highest death count per population
  
Select location, MAX(total_deaths) as TotalDeathCount
From CovidProject.dbo.CovidDeaths
Group by location
Order by TotalDeathCount desc
  
-- Recognizing total deaths column as an integer so that it can display the total death count in proper desc order/cast function
  
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidProject.dbo.CovidDeaths
Group by location
Order by TotalDeathCount desc
  
-- Some locations displayed are continents, because we had nulls in our continent fields, so it's picking up the continents as locations
-- To fix this, we specify with a where statement
  
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidProject.dbo.CovidDeaths
Where continent is not null
Group by location
Order by TotalDeathCount desc
  
-- Breaking things down by continent
  
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidProject.dbo.CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidProject.dbo.CovidDeaths
Where continent is null
Group by location
Order by TotalDeathCount desc

-- Global Numbers
-- Death percentage per day
  
Select date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From CovidProject.dbo.CovidDeaths
Where continent is not null
Group by date
Order by 1, 2

-- Total death percentage
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From CovidProject.dbo.CovidDeaths
Where continent is not null
Order by 1,2

-- Covid Vaccinations Table
Select *
From CovidProject.dbo.CovidVaccinations

-- Joining our two Tables (CovidDeaths and CovidVaccinations)
-- Using location and date
Select *
From CovidProject.dbo.CovidDeaths dea
Join CovidProject.dbo.CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date

-- Looking at total population v/s vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From CovidProject.dbo.CovidDeaths dea
Join CovidProject.dbo.CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Order by 1,2,3




