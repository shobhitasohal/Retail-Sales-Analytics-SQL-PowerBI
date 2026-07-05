
/*=========================================================================================
Phase 1 - Exploratory Data Analysis(EDA) - Understand shape, quality, and range of 
          all 3  tables - Sales, Customers and Products
===========================================================================================*/

-- 1. Database Dimensions & columns

select count(*) as sales_data from [gold].[fact_sales];
select count(*) as customers_data from [gold].[dim_customers];
select count(*) as product_data from [gold].[dim_products];

select top 100 * from [gold].[fact_sales];
select top 100 * from [gold].[dim_customers];
select top 100 * from [gold].[dim_products];

-- 2. Investigating Sale data - Date Range and Sales Span

select
 min(order_date) as earliest_order_date,
 max(order_date) as latest_order_date,
 count(distinct order_date) as active_trading_days
from [gold].[fact_sales];

Select year(order_date) as year,
	count(distinct month(order_date)) as month_count
FROM  [gold].[fact_sales]
group by year(order_date)
order by year(order_date);

/* Based on earliest date and latest date we will exclude year 2010 and year 2014 as we have have full year data for these years
   There is missing order dates as well*/


-- 3. Investigating Customer Profile Check

Select
	count(*) as total_records,
	count(distinct customer_number) as customer_count,
	count(distinct country) as countries,
	count(*) - count(birthdate) as missing_dob
from [gold].[dim_customers];

/* No duplications in customer_number and there are 17 missiing dob*/

--4. Product Catalogue Check

SELECT
    COUNT(*) AS total_products,
    COUNT(DISTINCT category)    AS categories,
    COUNT(DISTINCT subcategory) AS subcategories,
FROM gold.dim_products;

-- 5. Sales Data Quality Check (nulls & orphans)

SELECT
    COUNT(*)                                                AS total_rows,
    SUM(CASE WHEN s.sales_amount IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN s.quantity     IS NULL THEN 1 ELSE 0 END) AS null_qty,
    SUM(CASE WHEN c.customer_key IS NULL THEN 1 ELSE 0 END) AS orphan_customers,
    SUM(CASE WHEN p.product_key  IS NULL THEN 1 ELSE 0 END) AS orphan_products
FROM [gold].[fact_sales] s
LEFT JOIN [gold].[dim_customers] c ON s.customer_key = c.customer_key
LEFT JOIN [gold].[dim_products]  p ON s.product_key  = p.product_key;




