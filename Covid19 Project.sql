/*

Covid19 Data Exploration

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

-- select * From MyPortfolioProject1..CovidDeaths
-- Order By 3, 4

-- Testing Data
-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From MyPortfolioProject1..CovidDeaths
Where continent is not null 
order by 1,2


-- Looking at Total Cases vs Total Deaths and Death Percentage

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From MyPortfolioProject1..CovidDeaths
Order By 1,2

-- Death Percentage by Specific Location

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentageByLoc
From MyPortfolioProject1..CovidDeaths
Where location like 'Asia'
Order By 1,2


-- Looking at Total Cases vs Population

Select location, date, total_cases, total_deaths, (total_cases/population)*100 as PercentPopulationInfected
From MyPortfolioProject1..CovidDeaths
Where location like 'Asia'
Order By 1,2
      
-- Countries with Highest Infection Rate compared to Population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From MyPortfolioProject1..CovidDeaths
--Where location like 'Asia'
Group By location, population
Order By PercentPopulationInfected Desc

-- Countries with Highest Death Count per Population

Select location, population, MAX(total_deaths) as TotalDeathCount
From MyPortfolioProject1..CovidDeaths
-- Where location like 'Asia'
Group By location, population
Order By TotalDeathCount Desc



-- Contintents with the Highest Death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From MyPortfolioProject1..CovidDeaths
--Where location like 'Asia'
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select SUM(total_cases), SUM(cast(total_deaths as int)), SUM(cast(total_deaths as int))/SUM(total_cases*100) as DeathPercentage
From MyPortfolioProject1..CovidDeaths
Where continent is not null
Order By 1,2 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From MyPortfolioProject1..CovidDeaths
where continent is not null 
order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(CONVERT(int, vac.new_vaccinations)) OVER ( Partition By dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated
From MyPortfolioProject1..CovidDeaths dea
Join MyPortfolioProject1..CovidVaccinations vac
     On dea.location=vac.location
	 And dea.date=vac.date
where dea.continent is not Null
Order By 1,2


-- Using CTE to perform Calculation on Partition By in previous query


With PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(CONVERT(int, vac.new_vaccinations)) OVER ( Partition By dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated
From MyPortfolioProject1..CovidDeaths dea
Join MyPortfolioProject1..CovidVaccinations vac
     On dea.location=vac.location
	 And dea.date=vac.date
where dea.continent is not Null
)
Select *, (RollingPeopleVaccinated/population)*100 PercentofRollingpeoplevaccinated
From PopVsVac	


-- Using Temp Table to perform Calculation on Partition By in previous query


Drop Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(CONVERT(int, vac.new_vaccinations)) OVER ( Partition By dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated
From MyPortfolioProject1..CovidDeaths dea
Join MyPortfolioProject1..CovidVaccinations vac
     On dea.location=vac.location
	 And dea.date=vac.date
where dea.continent is not Null

Select *, (RollingPeopleVaccinated/population)*100 as PercentofRollingpeoplevaccinated
From PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentpeopleVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(CONVERT(int, vac.new_vaccinations)) OVER ( Partition By dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated
From MyPortfolioProject1..CovidDeaths dea
Join MyPortfolioProject1..CovidVaccinations vac
     On dea.location=vac.location
	 And dea.date=vac.date
where dea.continent is not Null

Create View TotalDeathCountPerlocation as 
Select location, population, MAX(total_deaths) as TotalDeathCount
From MyPortfolioProject1..CovidDeaths
Group By location, population

Create View TotalDeathCountPerContinent as
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From MyPortfolioProject1..CovidDeaths
--Where location like 'Asia'
Where continent is not null 
Group by continent


