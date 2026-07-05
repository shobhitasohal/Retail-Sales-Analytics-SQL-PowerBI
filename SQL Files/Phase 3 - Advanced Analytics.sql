
/*=========================================================================================
Phase 3 - Advanced Analytics to measure Product performance, customer profiling, and 
          comparative analysis
===========================================================================================*/

-- 1.  Product Performance vs. Average

with product_sales as (
    select
        year(f.order_date)             as yr,
        p.category,
        p.subcategory,
		p.product_name,
        p.cost,
        sum(f.sales_amount)            as total_revenue,
        count(distinct f.order_number) as total_orders
    from [gold].[fact_sales] f
    join [gold].[dim_products] p on f.product_key = p.product_key
    where f.order_date >= '2011-01-01' and f.order_date < '2014-01-01'
    group by year(f.order_date), p.product_name, p.category, p.subcategory, p.cost
),

product_sales_with_avg as (
    select *,
        avg(total_revenue) over (partition by yr, category) as category_avg_revenue
    from product_sales
)

select *,
    case
        when total_revenue > category_avg_revenue then 'above average'
        when total_revenue < category_avg_revenue then 'below average'
        else 'average'
    end as performance_tag
from product_sales_with_avg
--order by yr, category, total_revenue desc
option (recompile, maxdop 4); -- recompile flushes the bad cached plan; maxdop 4 forces sql server to use up to 4 cpu cores to calculate the count(distinct) simultaneously


--2. Customer Age Segmentation

with aggregated_sales as (
   
    select 
        customer_key,
        sum(sales_amount) as total_spend,
		count(distinct order_number) as total_orders,
		max(order_date) as last_purchase_date
    from [gold].[fact_sales]
	where order_date between '2011-01-01' and '2013-12-31'
    group by customer_key
)

select
    c.customer_key,
    c.first_name, 
    c.last_name, 
    c.gender,
    datediff(year, c.birthdate, '2013-12-31') as age,
    case
        when datediff(year, c.birthdate, '2013-12-31') < 30 then 'under 30'
        when datediff(year, c.birthdate, '2013-12-31') < 45 then '30-44'
        when datediff(year, c.birthdate, '2013-12-31') < 60 then '45-59'
        else '60+'
    end as age_group,
    f.total_spend,
	f.total_orders,
	f.last_purchase_date,
	case 
		when f.total_orders = 1 and datediff(month, f.last_purchase_date, '2013-12-31') >= 10 then 'Churned One-Time'
		when f.total_orders = 1 then 'One-Time Buyer'
		when datediff(month, f.last_purchase_date, '2013-12-31') >= 10 then 'Churned'
    else 'Active'
	end as customer_status
from [gold].[dim_customers] c
join aggregated_sales f on c.customer_key = f.customer_key
order by f.total_spend desc;


-- 3. Product Cost Segmentation
SELECT
    product_name, cost,
    CASE
        WHEN cost < 100  THEN 'Low Cost (< $100)'
        WHEN cost < 500  THEN 'Mid Cost ($100-499)'
        WHEN cost < 1500 THEN 'High Cost ($500-1499)'
        ELSE                  'Premium (>= $1500)'
    END AS cost_segment
FROM gold.dim_products;


-- 4. Top 10 Customers by Revenue

with aggregated_sales as (
    
    select 
        customer_key,
        sum(sales_amount) as total_revenue,
        max(order_date) as last_purchase_date,
        count(distinct order_number) as total_orders
    from [gold].[fact_sales]
    where order_date is not null 
      and order_date between '2011-01-01' and '2013-12-31'
    group by customer_key
)


select top 10
    c.customer_key,
    c.first_name + ' ' + c.last_name as name,
    f.total_revenue,
    f.total_orders
from [gold].[dim_customers] c
join aggregated_sales f on c.customer_key = f.customer_key
where datediff(month, f.last_purchase_date, '2013-12-31') >= 12 
  and f.total_orders > 1
order by f.total_revenue desc;
