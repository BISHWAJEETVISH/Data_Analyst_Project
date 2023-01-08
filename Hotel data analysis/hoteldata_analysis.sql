------------------HOTEL REVENUE HISTORY DATA ANALYSIS-----------------
with hotels as(
select *
from portfolio_project.dbo.['2018$']
UNION
select *
from portfolio_project.dbo.['2019$']
UNION
select *
from portfolio_project.dbo.['2020$'] )

select *
from hotels

----------Total revenue every year-------------------
select 
arrival_date_year,sum((stays_in_week_nights+stays_in_weekend_nights)*adr) AS REVENUE
from hotels
group by arrival_date_year

------------Total revenue every year by Hotel type -------------------
with hotels as(
select *
from portfolio_project.dbo.['2018$']
UNION
select *
from portfolio_project.dbo.['2019$']
UNION
select *
from portfolio_project.dbo.['2020$'] )

select
arrival_date_year,hotel,round(sum((stays_in_week_nights+stays_in_weekend_nights)*adr),2) AS REVENUE
from hotels
group by arrival_date_year,hotel


-----------Joining the other market and meal tables-----------------------

with hotels as(
select *
from portfolio_project.dbo.['2018$']
UNION
select *
from portfolio_project.dbo.['2019$']
UNION
select *
from portfolio_project.dbo.['2020$'] )

select * from hotels
left join portfolio_project.dbo.market_segment$
on hotels.market_segment= market_segment$.market_segment
left join portfolio_project.dbo.meal_cost$
on meal_cost$.meal=hotels.meal