


SELECT *
FROM portfolioproject..CovidDeaths
WHERE continent is not null 
ORDER by 3,4

--SELECT *
--FROM portfolioproject..CovidVaccinations
--ORDER by 3,4

-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
WHERE continent is not null 
ORDER by 1,2

--Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathsPercentage
From PortfolioProject..CovidDeaths
WHERE location like '%states%'
and continent is not null 
ORDER by 1,2



-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, population, total_cases, (total_cases/population)*100 as DeathsPercentage
From PortfolioProject..CovidDeaths
--WHERE location like '%Egypt%'
ORDER by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--WHERE location like '%Egypt%'
group by Location, population
ORDER by PercentPopulationInfected desc


-- showing Countries with Highest Death Count per Population
Select Location, MAX(Cast(Total_deaths as int)) as TotalDeathsCount 
From PortfolioProject..CovidDeaths
--WHERE location like '%Egypt%'
WHERE continent is not null 
group by Location
ORDER by TotalDeathsCount desc


-- LET'S BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(Cast(Total_deaths as int)) as TotalDeathsCount 
From PortfolioProject..CovidDeaths
--WHERE location like '%Egypt%'
WHERE continent is not null 
group by continent
ORDER by TotalDeathsCount desc



-- GLOBAL NUMBERS

	 Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
	From PortfolioProject..CovidDeaths
	--Where location like '%states%'
	where continent is not null 
	--Group By date
	order by 1,2


	-- Looking at Total Population vs Vaccinations

with PopvsVac (continent, location, date, population, New_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations vac
     On  dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
	 --order by 2,3
	 )

	 SELECT *, (RollingPeopleVaccinated/population)*100
	 FROM PopvsVac

	 -- USE CTE 
	 with PopvsVac


	 -- TEM TABLE 
	 DROP TABLE if exists #PercentPopulationVaccinated
	Create Table #PercentPopulationVaccinated
	(
	continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
	)

	
	INSERT into #PercentPopulationVaccinated

	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations vac
     On  dea.location = vac.location
	 and dea.date = vac.date
	--where dea.continent is not null
	 --order by 2,3

	 SELECT *, (RollingPeopleVaccinated/population)*100
	 FROM #PercentPopulationVaccinated




-- Creating View to store data for later visualizations
create view PercentPopulationVaccinated as 
	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations vac
     On  dea.location = vac.location
	 and dea.date = vac.date
	where dea.continent is not null
	 --order by 2,3

	 SELECT *
FROM PercentPopulationVaccinated

























