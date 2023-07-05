select *
from coviddeaths
where continent is not null
order by 3,4

--select *
--from covidvacination
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from coviddeaths
order by 1,2

---looking at total cases vs total deaths

select location,date,total_cases,total_deaths,(total_deaths/total_cases) as death_percentage
from coviddeaths
order by 1,2

select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as deathpercentage
from coviddeaths
where location like'%states%' and continent is not null
order by 1,2


---looking at total cases Vs population
select location, date, total_cases, population,(cast(total_cases as float)/population)*100 as percentpopulationinfected
from coviddeaths
where continent is not null
--where location like'%states%'
order by 1,2

---looking at countries with highest infection rate compared to population

select location,population,max(cast(total_cases as int)) as highestinfectioncount, max(cast(total_cases as float)/population)*100 as percentpopulationinfected
from coviddeaths
where continent is not null
group by location,population
order by percentpopulationinfected desc

--Showing Countries With Highest Death Count per Population

Select Location,Max(cast(Total_deaths as INT)) as Totaldeathcount
from coviddeaths
where continent is not null
group by location
order by Totaldeathcount desc


---let"s break thing down by continent
Select continent,Max(cast(Total_deaths as INT)) as Totaldeathcount
from coviddeaths
where continent is not null
group by Continent
order by Totaldeathcount desc


---let"s break thing down by continent
---Showing continent with the Highest death count per population

Select continent,Max(cast(Total_deaths as INT)) as Totaldeathcount
from coviddeaths
where continent is not null
group by Continent
order by Totaldeathcount desc


--Global Numbers

select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,sum(new_deaths)/sum(nullif(new_cases,0))*100 as deathpercentage
from coviddeaths
where continent is not null
---group by date
order by 1,2

---looking at total population Vs vacinations

---USE CTE

with PopvsVac(continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float))over (partition by dea.location order by dea.location,dea.date)as rollingpeoplevaccinated
--(rollingpeoplevaccinated/population)*100
from coviddeaths dea
join covidvacination vac
on dea.location =vac.location and
dea.date=vac.date
where dea.continent is not null
---order by 2,3
)
 select *,(rollingpeoplevaccinated/population)*100 from
 PopvsVac

---TEMP TABLE

Drop Table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
rollingpeoplevaccinated numeric
)

insert into #percentpopulationvaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float))over (partition by dea.location order by dea.location,dea.date)as rollingpeoplevaccinated
--(rollingpeoplevaccinated/population)*100
from coviddeaths dea
join covidvacination vac
on dea.location =vac.location and
dea.date=vac.date
---where dea.continent is not null
---order by 2,3
select *,(rollingpeoplevaccinated/population)*100 from
 #percentpopulationvaccinated


 ---Creating View to Store DAta for later Visualization

 create view percentpopulationvaccianated as 
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float))over (partition by dea.location order by dea.location,dea.date)as rollingpeoplevaccinated
--(rollingpeoplevaccinated/population)*100
from coviddeaths dea
join covidvacination vac
on dea.location =vac.location and
dea.date=vac.date
where dea.continent is not null
---order by 2,3


