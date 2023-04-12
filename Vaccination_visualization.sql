select * from Portfolio_Project..CovidVaccination$

--total population vs vaccinatination
select *
from Portfolio_Project..CovidVaccination$ as vac
join Portfolio_Project..coviddeaths$ as dea
on vac.location=dea.location and vac.date =dea.date;

--total population vs new vaccinatination per day
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from Portfolio_Project..CovidVaccination$ as vac
join Portfolio_Project..coviddeaths$ as dea
on vac.location=dea.location and vac.date =dea.date
where dea.continent is not null
order by 2,3;


--Total no of vaccination per day
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date) as TotalNewVaccination
from Portfolio_Project..CovidVaccination$ as vac 
join Portfolio_Project..coviddeaths$ as dea
on vac.location=dea.location and vac.date =dea.date
where dea.continent is not null and dea.location ='India'
order by 2,3;

--Vaccination rate over total population
--with CTEs
with PopvsVac (Continent,Location,Date,Population,NewVaccination,Totalnew)
as(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date) as TotalNewVaccination
from Portfolio_Project..CovidVaccination$ as vac 
join Portfolio_Project..coviddeaths$ as dea
on vac.location=dea.location and vac.date =dea.date
where dea.continent is not null )

select *,(Totalnew/Population)*100 as Vacrate
from PopvsVac

--with temporary table
drop table if exists #popvsvaccTemp
CREATE TABLE #popvsvaccTemp(
Continent varchar(100),
Location varchar(100),
Date date,
Population numeric,
NewVaccination numeric,
Totalnew numeric
)

INSERT INTO  #popvsvaccTemp
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date) as TotalNewVaccination
from Portfolio_Project..CovidVaccination$ as vac 
join Portfolio_Project..coviddeaths$ as dea
on vac.location=dea.location and vac.date =dea.date
where dea.continent is not null

Select *,(Totalnew/Population)*100 as Vacrate
from #popvsvaccTemp
order by Location



--Creating view for further visuliazation
create view popvsvaccTemp as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date) as TotalNewVaccination
from Portfolio_Project..CovidVaccination$ as vac 
join Portfolio_Project..coviddeaths$ as dea
on vac.location=dea.location and vac.date =dea.date
where dea.continent is not null