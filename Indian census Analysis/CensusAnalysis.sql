select * from portfolio_project..Data1 
select * from portfolio_project..Data2

--Count Number of rows in Data

select count(*) from portfolio_project..Data1
select count(*) from portfolio_project..Data2

--dataset for Jharkhand and bihar---

select * from portfolio_project..Data1
where  state in ('Jharkhand','Bihar') 

--Population Of India

select sum(population) as Population from portfolio_project..Data2

--avg growth for country

select avg(growth)*100 as avg_growth 
from portfolio_project..Data1

---Avg growth by state
select state,avg(growth)*100 as avg_growth 
from portfolio_project..Data1
group by state

--Average Sex ratio
select state,round(avg(Sex_Ratio),0) as avg_sex_ratio
from portfolio_project..Data1
group by state
order by avg_sex_ratio Desc

--Average Literacy RAte
select state,round(avg(Literacy),0) as avg_LITERACY_RATE
from portfolio_project..Data1
group by state
having round(avg(Literacy),0)>90
order by avg_LITERACY_RATE Desc

--Top 3 States showing Highest Growth ratio----------
select top 3 state,avg(growth)*100 as avg_growth 
from portfolio_project..Data1
group by state
order by avg_growth  Desc 

--Bottom 3 states showing Lowest Sex RAtio
select top 3 state,round(avg(Sex_Ratio),0) as avg_sex_ratio
from portfolio_project..Data1
group by state
order by avg_sex_ratio 

--Top and Bottom 3 states showing Litercay rate
drop table if exists #topstates
create table #topstates(
      state nvarchar(255),
	  topstate float
	  )
insert into #topstates
select state,round(avg(Literacy),0) as avg_LITERACY_RATE
from portfolio_project..Data1
group by state
order by avg_LITERACY_RATE Desc

select top 3 * from #topstates order by topstate Desc

drop table if exists #bottomstates
create table #bottomstates(
      state nvarchar(255),
	  bottomstate float
	  )
insert into #bottomstates
select state,round(avg(Literacy),0) as avg_LITERACY_RATE
from portfolio_project..Data1
group by state
order by avg_LITERACY_RATE Desc

select top 3 * from #bottomstates order by bottomstate 

-----Union Operator for getting bottom and top states
select * from(
select top 3 * from #topstates order by topstate Desc) a

union

select * from(
select top 3 * from #bottomstates order by bottomstate ) b

----States Starting with Letter a & b

select distinct(state) from portfolio_project..Data1 
Where lower(state) like 'a%' or lower(state) like 'b%'

select distinct(state) from portfolio_project..Data1 
Where lower(state) like 'a%' and lower(state) like '%m'           --% indicates letter ending with m and staring with a

--Joining Both The tables

---Total males and females-----
select d.state,sum(d.males) males,sum(d.females) females  from
(select c.district,c.state,round(c.population/(c.sex_ratio+1),0) as males,round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,a.sex_ratio/1000 as sex_ratio,b.population
from portfolio_project..Data1 a inner join portfolio_project..Data2 b on a.district=b.district) c )d
group by d.state

-----------Total Litercay rate------------

select d.state,sum(d.literate_people) Literate_people,sum(d.illiterate_people) as Illiterate_people from
(select c.district,c.state,round((c.literacy_rate * c.population),0) literate_people, round(((1-c.literacy_rate) * c.population),0) illiterate_people from
(select a.district,a.state,a.Literacy/100 as literacy_rate,b.population
from portfolio_project..Data1 a inner join portfolio_project..Data2 b on a.district=b.district) c) d
group by state

----------Population_In_previos census--------------------

select e.state,round(sum(e.prev_census_pop),0) prev_census_pop,sum(e.current_population) current_population from
(select d.district,d.state,d.population/(1+d.growth) prev_census_pop,d.population current_population from
(select a.district,a.state,a.Growth as growth,b.population
from portfolio_project..Data1 a inner join portfolio_project..Data2 b on a.district=b.district) d ) e
group by e.state

------Population VS Area --------------

select q.*,r.* from
(select '1' as keyy, n.* from
(select sum(m.prev_census_pop) prev_census_pop,sum(m.current_population) current_population from 
(select e.state,round(sum(e.prev_census_pop),0) prev_census_pop,sum(e.current_population) current_population from
(select d.district,d.state,d.population/(1+d.growth) prev_census_pop,d.population current_population from
(select a.district,a.state,a.Growth as growth,b.population
from portfolio_project..Data1 a inner join portfolio_project..Data2 b on a.district=b.district) d ) e
group by e.state) m ) n ) q inner join (

select '1' as keyy,z.* from 
( select sum(area_km2) total_area from portfolio_project..Data2 )z ) r on q.keyy=r.keyy

------------ Window Functions -------------------
--------Output Top 3 distrcits from each state with high literacy rate-----------

select a.* from
(select district,state,literacy,rank() over (partition by state order by literacy desc)rnk from portfolio_project..Data1) a
where a.rnk in (1,2,3) 
order by state




