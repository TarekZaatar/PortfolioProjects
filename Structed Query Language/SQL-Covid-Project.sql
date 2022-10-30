select *
from PortfolioProjects..CovidDeaths
where continent is not null
order by 3,4


--select *
--from PortfolioProjects..CovidVac
--order by 3,4

select Location, Date, total_cases, new_cases, total_deaths , population
from PortfolioProjects..CovidDeaths
where continent is not null
order by 1,2

-- Total cases vs Total Deaths

Select Location, Date,total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProjects..CovidDeaths
where continent is not null
order by 1,2


Select Location, Date,total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProjects..CovidDeaths
where location like '%Arab%'
and continent is not null
order by 1,2

-- Total cases vs Population
Select Location, Date,population, total_cases,  (total_cases/population)*100 as CasesPercentage
from PortfolioProjects..CovidDeaths
where location like '%North% Korea' and continent is not null
order by 1,2


-- Total cases vs Population
Select Location, Date,population, total_cases,  (total_cases/population)*100 as CasesPercentage
from PortfolioProjects..CovidDeaths
where location like '%United Arab%' and continent is not null
order by 1,2


-- countries with highest infection rate compared to population

Select Location, population, MAX(total_cases) as HighestInfectionCount,  (MAX(total_cases)/population)*100 as PercentagePopulationInfection
from PortfolioProjects..CovidDeaths
where continent is not null
Group by Location, population
order by PercentagePopulationInfection desc


-- countries with highest death rate compared to population

Select Location, population, MAX(cast(total_deaths as bigint)) as HighestDeathCount,  (MAX(total_deaths)/population)*100 as PercentageDeath
from PortfolioProjects..CovidDeaths
where continent is not null
Group by Location, population
order by PercentageDeath desc


Select location, population, MAX(cast(total_deaths as bigint)) as HighestDeathCount, MAX(total_cases) as MaxCases
from PortfolioProjects..CovidDeaths
where continent is null
Group by location, population


--continent info

Select location, population, MAX(cast(total_deaths as bigint)) as HighestDeathCount,  (MAX(total_deaths)/population)*100 as PercentageDeath
from PortfolioProjects..CovidDeaths
where continent is null
Group by location, population
order by PercentageDeath desc



Select continent, MAX(cast(total_deaths as bigint)) as TotalDeathCount
from PortfolioProjects..CovidDeaths
where continent is not null
Group by continent
order by  TotalDeathCount desc

-- Global

select date, Sum(new_cases) as TotalCases, sum(cast(new_deaths as bigint)) as TotalDeaths, sum(cast(new_deaths as bigint)) / Sum(new_cases)*100 as DeathPercentage
from PortfolioProjects..CovidDeaths
where continent is not null
Group by date
order by 1,2

-- joinning two tables togoether

select * 
from PortfolioProjects..CovidDeaths as Deaths join PortfolioProjects..CovidVac as Vacc
on Deaths.location = Vacc.location and Deaths.date = Vacc.date


-- population vs vaccination

select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, Vacc.new_vaccinations
from PortfolioProjects..CovidDeaths as Deaths join PortfolioProjects..CovidVac as Vacc
on Deaths.location = Vacc.location and Deaths.date = Vacc.date
where Deaths.continent is not null
order by 2,3


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, Vacc.new_vaccinations
, SUM(CONVERT(bigint,Vacc.new_vaccinations)) OVER (Partition by Deaths.Location)
from PortfolioProjects..CovidDeaths as Deaths join PortfolioProjects..CovidVac as Vacc
on Deaths.location = Vacc.location and Deaths.date = Vacc.date
where Deaths.continent is not null
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, Vacc.new_vaccinations
, SUM(CONVERT(int,Vacc.new_vaccinations)) OVER (Partition by Deaths.Location ORDER BY Deaths.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProjects..CovidDeaths as Deaths join PortfolioProjects..CovidVac as Vacc
on Deaths.location = Vacc.location and Deaths.date = Vacc.date
where Deaths.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac




--DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, Deaths.new_vaccinations
, SUM(CONVERT(int,Vacc.new_vaccinations)) OVER (Partition by Deaths.Location Order by Deaths.location, Deaths.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProjects..CovidDeaths as Deaths join PortfolioProjects..CovidVac as Vacc
on Deaths.location = Vacc.location and Deaths.date = Vacc.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select Deaths.continent, Deaths.location, Deaths.date, Deaths.population, Vacc.new_vaccinations
, SUM(CONVERT(int,Vacc.new_vaccinations)) OVER (Partition by Deaths.Location Order by Deaths.location, Deaths.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProjects..CovidDeaths as Deaths join PortfolioProjects..CovidVac as Vacc
on Deaths.location = Vacc.location and Deaths.date = Vacc.date

where Deaths.continent is not null 