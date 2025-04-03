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


Select continent
From CovidProject.dbo.CovidDeaths


