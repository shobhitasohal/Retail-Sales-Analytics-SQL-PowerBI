# 🛒 Retail Mart Analytics | Advanced SQL + Power BI

## 📋 Project Summary

| | |
|---|---|
| **Business Context** | A retail business with 3 years of sales data (2011–2013) had no structured analytics to monitor revenue trends, understand customer behaviour, or evaluate product performance across categories |
| **Objective** | Build a structured 4-phase SQL analytics pipeline to transform raw transactional data into KPIs, customer segments, and product insights — then surface findings through an interactive 3-page Power BI dashboard |
| **Solution** | Executed a 4-phase SQL pipeline (EDA → KPIs → Advanced Analytics → Views) across 17,975 customers, 219 products, and 3 years of sales data — connected to Power BI via SQL views as a single source of truth |
| **Business Outcome** | Delivered $29.3M in tracked revenue across 58.4K orders, identified 9,778 one-time buyers as the top retention opportunity, and surfaced Bikes as the dominant category driving 93.9% of 2013 revenue |

---

## 🔍 Business Problem

A retail business operating across three product categories (Bikes, Accessories, Clothing) had three years of transactional data but no structured analytical framework to answer critical business questions:

- Is revenue growing year-over-year and which categories are driving growth?
- Who are the most valuable customers and which ones are at risk of churning?
- Which products are performing above or below category average?
- How has the product portfolio expanded over time across cost segments?

Without answers to these questions, leadership could not prioritize retention efforts, optimize product mix, or make informed investment decisions.

---

## 💡 Solution

A structured **4-phase SQL analytics pipeline** was designed and executed in Microsoft SQL Server, culminating in a 3-page interactive Power BI dashboard:

### Phase 1 — Exploratory Data Analysis (EDA)
Investigated the shape, quality, and range of all 3 tables (Sales, Customers, Products):
- Validated dataset dimensions and identified date range: **2011–2013** (excluding incomplete years 2010 and 2014)
- Confirmed **17,975 unique customers** across multiple countries with 17 missing date-of-birth records
- Checked for null values, orphaned records, and referential integrity across fact and dimension tables

### Phase 2 — KPI Calculations
Calculated core business KPIs using aggregations and window functions:
- **Revenue, Orders & Volume KPIs** by year — total sales, units sold, avg order value, revenue per customer
- **Monthly revenue with 3-month moving average** — smoothed trend analysis using rolling window functions
- **Year-over-Year revenue growth** — using `LAG()` to compute YoY change and growth % by year
- **Category revenue share** — proportion of total revenue contributed by each product category per year

### Phase 3 — Advanced Analytics
Built deeper analytical queries for segmentation and comparative analysis:
- **Product performance vs. category average** — tagged each product as Above Average, Average, or Below Average using `AVG() OVER(PARTITION BY)`
- **Customer age segmentation** — grouped 17,975 customers into 4 age bands and 4 status categories (Active, Churned, One-Time Buyer, Churned One-Time)
- **Product cost segmentation** — classified all products into 4 cost tiers (Low, Mid, High, Premium)
- **Top 10 customers by revenue** — identified highest-value customers with multiple orders and recent activity

### Phase 4 — SQL Views (Single Source of Truth for Power BI)
Created 5 optimized SQL views as the data layer for Power BI — eliminating ad hoc CSV exports:
- `product_performance` — product revenue vs. category average with performance tags
- `customer_segmentation` — full customer profile with age group, spend, and status
- `revenue_monthly` — monthly revenue with cumulative totals and 3-month moving average
- `category_annual` — category revenue, share %, YoY change, and YoY growth %
- `product_cost_segment` — cumulative portfolio growth by cost tier over time

**SQL Concepts Applied:** CTEs · Window Functions (LAG, RANK, AVG OVER, SUM OVER) · Self-JOIN · CASE Statements · Aggregations · Views · Date Functions · String Manipulation · Data Quality Checks

### Power BI Dashboard (3 Pages)

| Page | Content |
|---|---|
| **Executive Overview** | Total Revenue ($29.3M), Total Orders (58.4K), Total Customers (18K), Avg Order Value ($69.4K), Revenue by Year with 3-Month Moving Average, Revenue Share by Category, YoY Revenue by Category |
| **Customer Analysis** | Customer Retention Funnel, Lifetime Spend vs. Order Frequency, Customer Profiles Ranked by Total Spend, All Customer Spend by Age & Gender |
| **Product Performance** | Product Performance vs. Category Average table, Sub-Category Revenue Contribution, Product Portfolio by Cost Segment |

**Interactivity:** Year and Product Category slicers enable dynamic cross-filtering across all 3 dashboard pages

---

## 📊 Business Outcome

The analytics pipeline and dashboard delivered the following measurable insights:

**Revenue & Growth:**
- 💰 **$29.3M in total revenue** tracked across 58,400 orders and 17,975 customers (2011–2013)
- 📈 **Revenue grew 179.5% from 2012 to 2013** ($5.8M → $16.3M) — the strongest growth period
- 🚲 **Bikes drove 93.9% of 2013 revenue** ($15.4M of $16.3M total) — dominant category with Road Bikes ($14.5M) leading all sub-categories

**Customer Insights:**
- 🔴 **9,778 customers (54.4%) are One-Time Buyers** — the single largest retention opportunity identified for targeted re-engagement campaigns
- ✅ **6,228 Active customers** generating repeat revenue — highest-value segment for loyalty and upsell programs
- 👥 **Age group 30–44 drives the most revenue** ($15.7M combined across genders) — primary target demographic for marketing investment
- 🚨 **1,969 churned customers** (1,555 Churned One-Time + 414 Churned) — candidates for win-back campaigns

**Product Insights:**
- ⬆️ **76 products tagged Above Average**, **143 Below Average** — enabling targeted portfolio rationalization decisions
- 📦 **Premium products (≥$1,500) grew from 13 to 63 in portfolio** between 2011 and 2013 — fastest-growing cost segment
- 🏔️ **Mountain-200 Silver-38 is the top individual product** with 596 orders and $1.34M in revenue

---

## 📁 Repository Contents

| File | Description |
|---|---|
| `Phase_1_-_EDA.sql` | Exploratory data analysis — shape, quality, and date range validation |
| `Phase_2_-_KPIs_Calculations.sql` | Core KPI calculations — revenue, YoY growth, category share, moving average |
| `Phase_3_-_Advanced_Analytics.sql` | Advanced analytics — product performance, customer segmentation, cost tiers |
| `Phase_4_-_Views.sql` | SQL views as single source of truth for Power BI |
| `Final_Output_-_Monthly_Revenue.csv` | Monthly revenue with cumulative totals and moving average |
| `Final_Output_-_Customer_report.csv` | Full customer segmentation report with status and age group |
| `Final_Output-_Product_Report.csv` | Product performance report with above/below average tags |
| `Final_Output_-_Category_Share.csv` | Category revenue share and YoY growth by year |
| `Final_Output_-_Product_Segment.xlsx` | Product portfolio by cost segment with cumulative growth |
| `Retail_Mart_Report.pbix` | Interactive 3-page Power BI dashboard (Executive Overview, Customer Analysis, Product Performance) |

---

## 🔗 Connect

[LinkedIn](http://www.linkedin.com/in/shobhitasohal) 
