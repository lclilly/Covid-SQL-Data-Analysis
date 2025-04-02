-- Selecting data we're going to use

Select location, date, total_cases, new_cases, total_deaths, population
From CovidProject.dbo.CovidDeaths
Order by 1,2
-- Looking at total_cases v/s total_deaths- Likelihood of dying if you contract Covid
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidProject.dbo.CovidDeaths
Order by 1,2
-- Specifying location
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidProject.dbo.CovidDeaths
Where location like '%states%'
Order by 1,2
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidProject.dbo.CovidDeaths
Where location like '%kenya%'
Order by 1,2

-- Total cases v/s population
-- Shows what percentage of population got Covid
Select location, date, population, total_cases, (total_cases/population)*100 as CovidPercentage
From CovidProject.dbo.CovidDeaths
Where location like '%kenya%'
Order by 1,2

-- Countries with highest infection rates compared to population
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
From CovidProject.dbo.CovidDeaths
Group by location, population
Order by PercentPopulationInfected desc
