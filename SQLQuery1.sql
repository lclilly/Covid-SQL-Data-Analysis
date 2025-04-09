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
--- CTE function
-- Running total of new vaccs for each location over time, alongside daily new vaccs & popln, filtering out entries where continent information is missing  
With PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
As
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidProject.dbo.CovidDeaths dea
Join CovidProject.dbo.CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
)
Select*
From PopvsVac
-- Display continent, location, population, new vaccinations, rolling people vaccinated and the percentage of the rolling people vaccinated from the whole population
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidProject.dbo.CovidDeaths dea
Join CovidProject.dbo.CovidVaccinations vac
On dea.location = vac.location and dea.date = vac.date
Where dea.continent is not null
)
Select*, (RollingPeopleVaccinated/Population)*100
From PopvsVac
-- Using temptables
-- Rolling percentage of the popln vacc'd for each location over time, based on data from Covid-19 deaths and vacc tables
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidProject.dbo.CovidDeaths dea
Join CovidProject.dbo.CovidVaccinations vac
On dea.location = vac.location and dea.date = vac.date
Where dea.continent is not null
Select*, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated
-- If you want to run the same query multiple times using the same table or alter the query a little bit, use Drop Table if exists
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidProject.dbo.CovidDeaths dea
Join CovidProject.dbo.CovidVaccinations vac
On dea.location = vac.location and dea.date = vac.date
Where dea.continent is not null
Select*, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated
-- Creating view to store data for later visualization
Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidProject.dbo.CovidDeaths dea
Join CovidProject.dbo.CovidVaccinations vac
On dea.location = vac.location and dea.date = vac.date
Where dea.continent is not null
-- A view is permanent, not like a temp table
Select*
From PercentPopulationVaccinated




