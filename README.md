# Retail Mart Analytics

An end-to-end SQL analytics project transforming three years of raw retail transactional data into KPIs, customer segments, and product insights — surfaced through an interactive three-page Power BI dashboard.

**Tools used:** Microsoft SQL Server (SQL) · Power BI

---

## About This Project

End-to-end solo project covering exploratory data analysis, KPI calculations, advanced customer and product analytics, and dashboard design. SQL was executed in four structured phases across 17,975 customers, 219 products, and three years of sales data. Results were connected to Power BI via SQL views as a single source of truth — no CSV exports or intermediate files were used.

---

## Business Problem

A retail business operating across three product categories (Bikes, Accessories, Clothing) had three years of transactional data but no structured analytical framework to answer critical business questions:

1. **Revenue trends** — Is revenue growing year-over-year and which categories are driving growth?
2. **Customer behaviour** — Who are the most valuable customers and which ones are at risk of churning?
3. **Product performance** — Which products are performing above or below category average?
4. **Portfolio growth** — How has the product portfolio expanded over time across cost segments?

Without answers to these questions, leadership could not prioritize retention efforts, optimize product mix, or make informed investment decisions.

---

## Approach

The analysis was structured across four phases in Microsoft SQL Server:

- **Phase 1 — Exploratory Data Analysis** — validated dataset dimensions, confirmed date range (2011–2013, excluding incomplete years 2010 and 2014), identified 17,975 unique customers, and checked for null values, orphaned records, and referential integrity across fact and dimension tables
- **Phase 2 — KPI Calculations** — calculated total revenue, orders, and volume by year; monthly revenue with a 3-month moving average using rolling window functions; year-over-year revenue growth using `LAG()`; and category revenue share per year
- **Phase 3 — Advanced Analytics** — built product performance vs category average using `AVG() OVER(PARTITION BY)`; segmented 17,975 customers into 4 age bands and 4 status categories (Active, Churned, One-Time Buyer, Churned One-Time); classified products into 4 cost tiers; and identified top 10 customers by revenue
- **Phase 4 — SQL Views** — created 5 optimized views as the data layer for Power BI: `product_performance`, `customer_segmentation`, `revenue_monthly`, `category_annual`, and `product_cost_segment`

---

## Dashboard Preview

**Page 1 — Executive Overview**

> Total Revenue ($29.3M) · Total Orders (58.4K) · Total Customers (18K) · Avg Order Value ($69.4K) · Revenue by Year with 3-Month Moving Average · Revenue Share by Category · YoY Revenue by Category

**Page 2 — Customer Analysis**

> Customer Retention Funnel · Lifetime Spend vs Order Frequency · Customer Profiles Ranked by Total Spend · Customer Spend by Age and Gender

**Page 3 — Product Performance**

> Product Performance vs Category Average · Sub-Category Revenue Contribution · Product Portfolio by Cost Segment

Year and Product Category slicers enable dynamic cross-filtering across all three pages.

---

## Key Findings

**Revenue and Growth**
- $29.3M in total revenue tracked across 58,400 orders and 17,975 customers (2011–2013)
- Revenue grew 179.5% from 2012 to 2013 ($5.8M to $16.3M) — the strongest growth period in the dataset
- Bikes drove 93.9% of 2013 revenue ($15.4M of $16.3M total), with Road Bikes ($14.5M) leading all sub-categories

**Customer Insights**
- 9,778 customers (54.4%) are One-Time Buyers — the single largest retention opportunity identified for targeted re-engagement campaigns
- 6,228 Active customers generating repeat revenue — highest-value segment for loyalty and upsell programs
- Age group 30–44 drives the most revenue ($15.7M combined across genders) — primary target demographic for marketing investment
- 1,969 churned customers (1,555 Churned One-Time and 414 Churned) — candidates for win-back campaigns

**Product Insights**
- 76 products tagged Above Average and 143 Below Average — enabling targeted portfolio rationalization decisions
- Premium products (above $1,500) grew from 13 to 63 in the portfolio between 2011 and 2013 — the fastest-growing cost segment
- Mountain-200 Silver-38 is the top individual product with 596 orders and $1.34M in revenue

---

## Repository Contents

| File / Folder | Description |
|---|---|
| `SQL Files/Phase 1 - EDA.sql` | Exploratory data analysis — shape, quality, and date range validation |
| `SQL Files/Phase 2 - KPIs Calculations.sql` | Core KPI calculations — revenue, YoY growth, category share, moving average |
| `SQL Files/Phase 3 - Advanced Analytics.sql` | Advanced analytics — product performance, customer segmentation, cost tiers |
| `SQL Files/Phase 4 - Views.sql` | SQL views as single source of truth for Power BI |
| `Final Output/Monthly Revenue.csv` | Monthly revenue with cumulative totals and moving average |
| `Final Output/Customer report.csv` | Full customer segmentation report with status and age group |
| `Final Output/Product_Report.csv` | Product performance report with above/below average tags |
| `Final Output/Category Share Report.csv` | Category revenue share and YoY growth by year |
| `Final Output/Product Segment.xlsx` | Product portfolio by cost segment with cumulative growth |
| `Raw Data/gold.fact_sales.csv` | Raw sales transactions fact table |
| `Raw Data/gold.dim_products.csv` | Raw product dimension table |
| `Retail Mart Report.pbix` | Interactive 3-page Power BI dashboard |
| `Retail_Mart_Analytics.pptx` | Project presentation with SQL walkthrough and key findings |

---

## Connect

[LinkedIn](http://www.linkedin.com/in/shobhitasohal)
