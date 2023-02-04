select * from portfolio_project..shark

--------------------Total Episodes---------------
select count(distinct epno) , max(epno)
from portfolio_project..shark

-------Pitchers-------

select count(distinct Brand) from portfolio_project..shark

----Pitchers converted------

select sum(b.converted_not_converted) funding_received , count (*) Pitches_made from 
(select AmountInvestedLakhs , case when AmountInvestedLakhs>0 then 1 else 0 end as converted_not_converted 
from portfolio_project..shark) b

-----------Total MAle  and females---------

select sum(male) total_males, sum(female) total_females from portfolio_project..shark

--Gender RAtio----------
select sum(female)/sum(male)*100 gender_ratio from portfolio_project..shark

---TOTAL INVESTED AMOUNT------------

select sum(AmountInvestedLakhs) TOtal_amount_invested from portfolio_project..shark

--------Average equity taken--------

select avg(a.[Equity Taken %]) from
(select * from portfolio_project..shark 
where [Equity Taken %]>0) a

---------Highest deal taken--------

select max(AmountInvestedLakhs) Highest_deal from portfolio_project..shark

--------HIghest equity taken--------
select max([Equity Taken %]) from portfolio_project..shark

--------Startups having atleast women--------------

select sum(a.Female_count) from
(select Female, case when Female>0 then 1 else 0 end as Female_count from portfolio_project..shark)a

---------Pitches converted having atleast one women-------

select sum(b.Female_count) as ptch_converted_of_women from
(select  case when a.Female>0 then 1 else 0 end as Female_count, a.* from
(select * from portfolio_project..shark where deal!='NO DEAL') a )b

-----------Amount invested per Deal-----------

select avg(a.AmountInvestedLakhs) amount_invested_per_deal from
(select * from portfolio_project..shark where deal!='NO DEAL')a

------------max age group cnts of teams-----

select [Avg age],count([Avg age]) cnt from
portfolio_project..shark
group by [Avg age]
order by  cnt  desc

---Location group of contestants---------


select Location,count(Location) cnt from
portfolio_project..shark
group by Location
order by  cnt  desc

----Most startups from which sector-----

select Sector,count(Sector) cnt from
portfolio_project..shark
group by Sector
order by  cnt  desc

-------------Partner deals----------

select Partners,count(Partners) cnt from portfolio_project..shark where partners!='-'
group by partners 
order by cnt desc

----------

select count([Ashneer Amount Invested]) ashneer_invetsments from portfolio_project..shark where [Ashneer Amount Invested] is not null and [Ashneer Amount Invested]>0


select sum(c.[Ashneer Amount Invested]) total_ashneer_invest,AVG(c.[Ashneer Equity Taken %]) avg_ashneer_equity FROM  
(select * from portfolio_project..shark where [Ashneer Equity Taken %]>0 and [Ashneer Amount Invested]>0) c

-----------Startup in which highest amount invested-----------------

select c.* from
(select Brand,Sector,AmountInvestedLakhs,rank() over (partition by sector order by AmountInvestedLakhs desc) rnk
from portfolio_project..shark ) c
where c.rnk=1



