SELECT * FROM portfolioproject.coviddeaths 
where continent is not null
order by 3,4;

##SELECT * FROM portfolioproject.covidvaccine order by 3,4;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM portfolioproject.coviddeaths
order by 1,2;

#looking at total cases vs total deaths
SELECT location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as death_per_case
FROM portfolioproject.coviddeaths
order by 1,2;

#looking at total cases vs population
SELECT location, date, population, total_cases, (total_cases/population)*100 as case_per_population
FROM portfolioproject.coviddeaths
WHERE location like '%malaysia%'
order by 1,2;

#looking at Countries with highest infection rate compared to population
SELECT location, population, max(total_cases) as HighestInfectedCount, max((total_cases/population))*100 as PercentPopulationInfected
FROM portfolioproject.coviddeaths
group by location, population
#having location like '%malaysia%'
order by  4 desc;

#showing countries with highest death count per population
SELECT location, population, max(total_cases) as number_of_death, max((total_deaths/population))*100 as DeathPopulationPercentage
FROM portfolioproject.coviddeaths
where continent is not null
group by location, population
order by 3 desc;

#Break down by continent
SELECT location, max(total_cases) as number_of_death
FROM portfolioproject.coviddeaths
where continent is null
group by location
order by 2 desc;

#select * from portfolioproject.coviddeaths;

#GlOBAL NUMBERS
SELECT  date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as death_per_case #total_deaths, (total_deaths/total_cases)*100 as death_per_case
FROM portfolioproject.coviddeaths
where continent is not null
group by date
order by 1;

#covidvaccination
#select * from portfolioproject.covidvaccine;
select continent, sum(new_tests) as total_tests
from portfolioproject.covidvaccine
where continent is not null
group by continent;

#join covid death & covid vaccine
select *
from portfolioproject.coviddeaths dea
join portfolioproject.covidvaccine vac
on dea.location = vac.location
and dea.date = vac.date;

#looking at total population vs total vaccination
select 
dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from portfolioproject.coviddeaths dea
join portfolioproject.covidvaccine vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null #and dea.location like '%malaysia%'
order by 2,3;

#use CTE
With PopVsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(select 
dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated #, (RollingPeopleVaccinated/population)*100
from portfolioproject.coviddeaths dea
join portfolioproject.covidvaccine vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null #and dea.location like '%malaysia%'
#order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100 as VaccinatedPopulationPercentange
from PopVsVac;

#creating view to store data for later visualization
CREATE VIEW portfolioproject.PercentPopulationVaccinated as
select 
dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated #, (RollingPeopleVaccinated/population)*100
from portfolioproject.coviddeaths dea
join portfolioproject.covidvaccine vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null #and dea.location like '%malaysia%'
#order by 2,3percentpopulationvaccinated





