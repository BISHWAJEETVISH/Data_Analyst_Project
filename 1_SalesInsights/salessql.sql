select count(*) from sales.customers;

select count(*) from sales.transactions;

select count(*) from sales.transactions where market_code='Mark001';


select * from sales.transactions where currency='USD';

select * from sales.transactions inner join sales.date on sales.transactions.order_date= sales.date.date where sales.date.year=2019;

select sum(sales.transactions.sales_amount) from sales.transactions inner join sales.date on sales.transactions.order_date= sales.date.date where sales.date.year=2019;
 
select sum(sales.transactions.sales_amount) from sales.transactions inner join sales.date on sales.transactions.order_date= sales.date.date 
where sales.date.year=2019 and sales.transactions.market_code='Mark001'; 


