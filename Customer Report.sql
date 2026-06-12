/*
=============================================================================================
Customer Report
=============================================================================================
Purpose:
    This report consolidates key customer metrices and behaviours

Highlights:
    1. Gather essential fields such as names, ages and transaction details.
    2. Aggregate customer-level metrices:
        - total orders
        - total sales
        - total quantity purchased
        - lifespan (in months)
	3. Segment customer into categories such as VIP, Regular and New and age groups.
    4. Calculate KPIs:
        - recency (months since last order)
        - average order value
        - average monthly spend
=============================================================================================
*/

CREATE VIEW customer_report AS

/*=========================================================================================
Step 1 - Sales Aggregations
===========================================================================================*/

WITH sales_aggregations AS
(
    SELECT
        DATEPART(YEAR, s.order_date) AS _Year
        , s.customer_key
        , COUNT(s.order_number) AS total_orders
        , SUM(s.sales_amount) AS total_sales
        , SUM(s.quantity) AS total_quantity_purchased
        , MAX(s.order_date) AS last_order_date
        , MIN(s.order_date) AS first_order_date
        , DATEDIFF(month, MIN(s.order_date), MAX(s.order_date)) AS lifespan
    FROM dbo.sales s
    WHERE s.order_date IS NOT NULL
    GROUP BY DATEPART(YEAR, s.order_date), s.customer_key
),

/*=========================================================================================
Step 2 - Customer Aggregations
===========================================================================================*/

customer_aggregations AS
(
    SELECT
        sa._Year
        , sa.customer_key
        , c.customer_id
        , CONCAT(c.first_name, ' ', c.last_name) AS customer_name
        , DATEDIFF(year, c.birthdate, GETDATE()) AS age
        , sa.total_orders
        , sa.total_sales
        , sa.total_quantity_purchased
        , sa.last_order_date
        , sa.first_order_date
        , sa.lifespan
    FROM sales_aggregations sa
    INNER JOIN gold.dim_customers c ON sa.customer_key = c.customer_key
)

/*=========================================================================================
Step 3 - Final Query - Customer Segmentation and KPI Calculations
===========================================================================================*/

SELECT
    _Year
    , customer_key
    , customer_id
    , customer_name
    , age
    -- Segment data into different age groups
    , CASE
        WHEN age < 20                   THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29      THEN '20-29'
        WHEN age BETWEEN 30 AND 39      THEN '30-39'
        WHEN age BETWEEN 40 AND 49      THEN '40-49'
        ELSE '50 and Above'
      END AS age_group
    -- Segment customers based on spending and lifespan of their membership
    , CASE
        WHEN lifespan >= 12 AND total_sales > 5000  THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
      END AS customer_segment
    , total_orders
    , total_sales
    , total_quantity_purchased
    , last_order_date
    , first_order_date
    , lifespan
    , DATEDIFF(month, COALESCE(last_order_date, GETDATE()), GETDATE())  AS months_since_last_order
    -- Calculate Average Order Value
    , CASE
        WHEN total_orders = 0   THEN 0
        ELSE total_sales / total_orders
      END AS avg_order_value
    -- Calculate Average Monthly Spend
    , CASE
        WHEN lifespan = 0       THEN total_sales
        ELSE total_sales / lifespan
      END AS avg_monthly_spend
FROM customer_aggregations;