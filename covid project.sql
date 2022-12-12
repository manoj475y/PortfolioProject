use portfolio_project;
select * from coviddeaths
order by 3,4;
-- select * from covidvaccinations
-- order by 3,4;
-- select data that we are going to be using

select location, date, total_cases,new_cases, total_deaths, population
from coviddeaths
order by 1,2;
-- looking at total cases vs total deaths
-- shows likelihood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (total_cases/total_deaths)*100 death_percentage
from coviddeaths
where location like '%states%'
order by 1,2;
-- looking at total cases vs population

select location, date, total_cases, population, (total_cases/population)*100 percentpopulationinfected
from coviddeaths
where location like '%states%'
order by 1,2;
-- looking at countries with highest infection rate compared to population

select location,population,  max(total_cases) highestinfectedrate ,  max((total_cases/population))*100 percentpopulationinfected
from coviddeaths
group by location, population
order by percentpopulationinfected desc;

-- showing countries with highest death count per population


select location, max(total_deaths) totaldeathcount
from coviddeaths
where continent is not null
group by location
order by totaldeathcount desc;

-- let break things down by continent
-- showing continents with highest death count per population

select continent, max(total_deaths) totaldeathcount
from coviddeaths
where continent is not null
group by continent
order by totaldeathcount desc;

-- global numbers

select sum(new_cases) total_cases, sum(new_deaths) total_deaths, (sum(new_deaths)/sum(new_cases))*100 deathpercentage
from coviddeaths
where continent is not null
order by 1,2;

-- looking at total populations vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) RollingPeopleVaccinated,
(RollingPeopleVaccinated/population)*100
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null 
 order by dea.location, dea.date asc;
 
 -- use cte
 
 with popvsvac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
 as
 ( select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null 
 order by dea.location, dea.date asc
 )
 select *, (RollingPeopleVaccinated/population)*100 from popvsvac;
 
 -- temp table
 drop table if exists PercentPopulationVaccinated
 create table PercentPopulationVaccinated
 (
 continent varchar(255),
 location varchar(255),
 date text,
 population numeric,
 new_vaccinations numeric,
 RollingPeopleVaccinated numeric
 );
 insert into PercentPopulationVaccinated
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location
 and dea.date = vac.date
 -- where dea.continent is not null 
 order by dea.location, dea.date asc;
  select *, (RollingPeopleVaccinated/population)*100 from PercentPopulationVaccinated;
  
  -- creating view to store date for later visualisations
  
  create view vPercentPopulationVaccinated as
   select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null 
 order by dea.location, dea.date asc;
 select continent from vPercentPopulationVaccinated;
 


 

 























