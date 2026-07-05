
/*=========================================================================================
Phase 2 - Calculating Core KPIs
===========================================================================================*/

-- 1. Revenue, Orders & Volume KPIs over Years

Select
	YEAR(Order_date) as year,
	Count(distinct order_number) as total_orders,
	sum(sales_amount) as total_sales,
	sum(quantity) as total_units_sold,
	AVG(sales_amount)              AS avg_order_value,
    SUM(sales_amount) / COUNT(DISTINCT customer_key) AS revenue_per_customer
FROM gold.fact_sales
where order_date is not null
GROUP BY YEAR(order_date)
ORDER BY year;

-- 2. Monthly revenue with moving average
with monthly_rev as 
(
	Select
		YEAR(Order_date) as year,
		MONTH(order_date) as month,
		sum(sales_amount) as monthly_revenue
	from gold.fact_sales
	where order_date is not null
	GROUP BY YEAR(order_date), MONTH(order_date)
)

Select 
 year,
 month,
 monthly_revenue,
 sum(monthly_revenue) over (order by year, month) as cumulative_revenue,
 avg(monthly_revenue) over (order by year, month rows between 2 preceding and current row) as moving_average_3m
 from monthly_rev
 where year between '2011' and '2013'
 order by year, month;


 --3. Y-o-Y Revenue Growth

 with yearly as (
    select
        year(order_date)  as yr,
        sum(sales_amount) as revenue
    from gold.fact_sales
    group by year(order_date)
)
select
    yr,
    revenue,
    lag(revenue) over (order by yr)  as prev_year_revenue,
    revenue - lag(revenue) over (order by yr) as yoy_change,
    round(
      (revenue - lag(revenue) over (order by yr)) * 100.0
      / nullif(lag(revenue) over (order by yr), 0), 2
    ) as yoy_growth_pct
from yearly
where (yr between '2011' and '2013') and (yr is not null)
order by yr;


-- 4. Category Revenue Share


with revenue as
(
	Select year(s.order_date)  as yr,
		p.category as category,
		sum(s.sales_amount) as total_cat_sales,
		sum(sum(s.sales_amount)) over (partition by year(s.order_date)) as yearly_sales_total
	from gold.fact_sales s
	join [gold].[dim_products] p on p.product_key=s.product_key
	group by year(s.order_date), p.category
	
)

select 
	yr,
	category,
	total_cat_sales,
	concat(cast(round((CAST(total_cat_sales as float) /yearly_sales_total)*100.0,2)as varchar(10)),'%') as category_share_pct
from revenue
where (yr is not null) and yr between 2011 and 2013
order by yr;




