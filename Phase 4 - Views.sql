
/*=========================================================================================
Phase 4 - SQL Report Views - Views that Power BI connects to — single source of truth
===========================================================================================*/



---VIEW 1: Reporting Product_performance

CREATE OR ALTER VIEW product_performance AS
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
        when total_revenue > category_avg_revenue then 'Above Average'
        when total_revenue < category_avg_revenue then 'Below Average'
        else 'Average'
    end as performance_tag
from product_sales_with_avg
option (recompile, maxdop 4);

GO


-- VIEW 2: Reporting_customer_segmentation

CREATE OR ALTER VIEW customer_segmentation AS
with aggregated_sales as (
    select 
        customer_key,
        sum(sales_amount) as total_spend,
        count(distinct order_number) as total_orders,
		min(order_date) as First_Purchase,
        max(order_date) as last_purchase_date
    from [gold].[fact_sales]
    where order_date between '2011-01-01' and '2013-12-31'
    group by customer_key
)
select
	First_Purchase as join_date,
	c.customer_key,
    c.first_name, 
    c.last_name, 
    c.gender,
    datediff(year, c.birthdate, '2013-12-31') as age,
    case
        when datediff(year, c.birthdate, '2013-12-31') < 30 then 'Under 30'
        when datediff(year, c.birthdate, '2013-12-31') < 45 then '30-44'
        when datediff(year, c.birthdate, '2013-12-31') < 60 then '45-59'
        else '60+'
    end as age_group,
    f.total_spend,
    f.total_orders,
    f.last_purchase_date,
    case 
        when f.total_orders = 1 
         and datediff(month, f.last_purchase_date, '2013-12-31') >= 10 then 'Churned One-Time'
        when f.total_orders = 1 then 'One-Time Buyer'
        when datediff(month, f.last_purchase_date, '2013-12-31') >= 10 then 'Churned'
        else 'Active'
    end as customer_status
from [gold].[dim_customers] c
join aggregated_sales f on c.customer_key = f.customer_key;

GO



-- VIEW 3: Reporting.revenue_monthly (UPDATED - includes order metrics)
CREATE OR ALTER VIEW Reporting.revenue_monthly AS
with monthly_metrics as 
(
    select
        year(f.order_date) as yr,
        month(f.order_date) as mnth,
        datefromparts(year(f.order_date), month(f.order_date), 1) as month_date,
        sum(f.sales_amount) as monthly_revenue,
        count(distinct f.order_number) as total_orders,
        count(distinct f.customer_key) as total_customers,
        sum(f.sales_amount) / count(distinct f.order_number) as avg_order_value,
        sum(f.sales_amount) / count(distinct f.customer_key) as revenue_per_customer
    from [gold].[fact_sales] f
    where f.order_date is not null
    group by year(f.order_date), month(f.order_date)
)
select 
    month_date,
    yr,
    mnth,
    monthly_revenue,
    total_orders,
    total_customers,
    avg_order_value,
    revenue_per_customer,
    sum(monthly_revenue) over (order by yr, mnth) as cumulative_revenue,
    avg(monthly_revenue) over (order by yr, mnth rows between 2 preceding and current row) as moving_avg_3m
from monthly_metrics
where yr between 2011 and 2013;
 
GO
 
-- VIEW 4: Reporting category_annual
-- Purpose: All category-level annual metrics in one view (revenue, share %, YoY change, YoY growth %)
-- Reduces CSV exports and simplifies Power BI data model
 
CREATE OR ALTER VIEW Reporting.category_annual AS
with category_yearly as (
    select
        year(s.order_date) as yr,
        p.category,
        sum(s.sales_amount) as category_revenue
    from [gold].[fact_sales] s
    join [gold].[dim_products] p on p.product_key = s.product_key
    where s.order_date >= '2011-01-01' and s.order_date < '2014-01-01'
    group by year(s.order_date), p.category
),
category_with_totals as (
    select *,
        sum(category_revenue) over (partition by yr) as yearly_total_revenue,
        lag(category_revenue) over (partition by category order by yr) as prev_year_revenue
    from category_yearly
)
select
    yr,
    category,
    category_revenue,
    yearly_total_revenue,
    concat(cast(round((cast(category_revenue as float) / yearly_total_revenue) * 100.0, 2) as varchar(10)),'%') as revenue_share_pct,
    prev_year_revenue,
    (category_revenue - prev_year_revenue) as yoy_change,
    round(
        (category_revenue - prev_year_revenue) * 100.0
        / nullif(prev_year_revenue, 0)
    , 2) as yoy_growth_pct
from category_with_totals
where yr between 2011 and 2013
order by yr, category;
 
GO
 
-- VIEW 5: Reporting.product_cost_segment
-- Purpose: Show cumulative product portfolio growth by cost segment over time
-- Answers: How has our product portfolio expanded in each cost tier year-over-year?
 
CREATE OR ALTER VIEW Reporting.product_cost_segment AS
with product_costs as (
    select
        year(p.start_date) as Year,
        p.product_key,
        p.product_name,
        p.cost,
        case
            when p.cost < 100  then 'Low Cost (< $100)'
            when p.cost < 500  then 'Mid Cost ($100-499)'
            when p.cost < 1500 then 'High Cost ($500-1499)'
            else                    'Premium (>= $1500)'
        end as cost_segment
    from [gold].[dim_products] p
    where p.start_date is not null and  year(p.start_date) between '2011' and '2013'
),
yearly_additions as (
    select
        Year,
        cost_segment,
        count(distinct product_key) as products_added_this_year
    from product_costs
    group by Year, cost_segment
)
select
    Year,
    cost_segment,
    products_added_this_year,
    sum(products_added_this_year) over (partition by cost_segment order by Year) as cumulative_portfolio_size
from yearly_additions
order by Year, cost_segment;