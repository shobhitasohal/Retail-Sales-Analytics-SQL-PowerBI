# 📊 Retail Data Analysis & Reporting in SQL

## 🔍 Business Problem

Retail businesses generate large volumes of sales and customer data but often struggle to extract actionable insights from it. Without structured reporting, leadership cannot track product performance, identify high-value customers, monitor sales trends, or understand market share shifts across their retail operations.

**The goal:** Use SQL Server to analyze retail sales and customer data and produce two structured analytical reports — a **Product Report** and a **Customer Report** — that enable data-driven business decisions across performance, segmentation, and trend analysis.

---

## 🛠️ How It Was Solved

Two dedicated SQL reports were built covering different business lenses:

### 📦 Product Report
Analyzes retail product-level performance across the business:

| Analysis | Description |
|---|---|
| Trend & Seasonality | Identified retail sales patterns over time to support forecasting |
| Performance Analysis | Ranked products by revenue, volume, and growth |
| Market Share Analysis | Measured each product's contribution to total retail sales |
| Year-over-Year Comparison | Tracked performance changes across periods |

### 👥 Customer Report
Analyzes retail customer behaviour and value:

| Analysis | Description |
|---|---|
| Customer Segmentation | Grouped retail customers by purchase behaviour and value |
| Recency, Frequency & Spend | Identified high-value vs. dormant customers |
| Trend Analysis | Tracked customer activity and purchasing patterns over time |
| Lifetime Value Indicators | Highlighted customers with highest long-term revenue potential |

### SQL Concepts Applied

- Window Functions (`ROW_NUMBER`, `RANK`, `LAG`, `LEAD`)
- CTEs (Common Table Expressions) for modular query building
- Aggregations (`SUM`, `AVG`, `COUNT`, `GROUP BY`)
- `CASE` statements for segmentation logic
- Subqueries and derived tables
- Date functions for trend and seasonality analysis
- JOINs across multiple tables

---

## 📊 Output

Two clean, structured CSV reports ready for business use or dashboard integration:

- 📋 **Customer Report** — segmented retail customer data with spend, frequency, and recency metrics
- 📦 **Product Report** — retail product performance data with market share, rankings, and YoY trends

These reports can be directly loaded into Power BI, Excel, or any BI tool for visualization.
