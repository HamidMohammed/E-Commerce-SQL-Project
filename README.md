# 🛒 E-Commerce SQL Data Engineering Project

![SQL Server](https://img.shields.io/badge/Database-SQL%20Server-blue)
![Normalization](https://img.shields.io/badge/Normalization-3NF-success)
![ETL](https://img.shields.io/badge/ETL-Production--Style-orange)
![Analytics](https://img.shields.io/badge/Analytics-Window%20Functions-purple)

---

## 📌 Project Overview

This project demonstrates a complete end-to-end SQL data engineering workflow using a denormalized e-commerce dataset.

The work includes:

- Full normalization to **Third Normal Form (3NF)**
- Data quality validation and conflict detection
- Production-style ETL pipeline
- Primary and Foreign Key enforcement
- Advanced analytical SQL queries
- Window functions for time-series revenue growth analysis

The goal of this project was not only to write SQL queries, but to design and implement a robust relational database system from a raw flat file.

---

## 🧱 Database Architecture

### 🔹 Raw Layer
- `raw_table` — Flat CSV import containing 39 columns from multiple entities

### 🔹 Normalized 3NF Schema
The dataset was decomposed into the following entities:

- `customer`
- `seller`
- `product`
- `orders`
- `shipping`
- `order_item`
- `payment`

All tables include:

- Proper Primary Keys
- Foreign Key constraints
- Cascading rules where appropriate
- Correct data types

---

## 🔄 ETL Strategy

The ETL process includes:

### ✅ Data Quality Diagnostics
- Duplicate detection using `GROUP BY`
- Conflict detection for composite keys
- Validation of payment consistency
- Handling denormalization artifacts

### ✅ Conflict Resolution
- `DISTINCT` used where safe
- `GROUP BY` aggregation used where required (e.g., payment duplicates)
- Deterministic rules using `MAX()` for collapsing duplicate rows

### ✅ Referential Integrity
- Enforced foreign keys
- Controlled loading order to avoid FK violations

---

## 📊 Business Analytical Queries Implemented

The project answers the following business questions:

1. Top 10 customers by total spending  
2. Total revenue per seller state  
3. Top 5 sellers by revenue  
4. Monthly revenue trend  
5. Top 5 product categories by number of orders  
6. Customers with more than 3 orders  
7. Orders with highest freight-to-product price ratio  
8. Payment method distribution (percentage)  
9. Average delivery time per state  
10. Top 3 product categories by month-over-month revenue growth  

---

## 📈 Key Business Insights

### 💰 Revenue Concentration
Revenue is highly concentrated in São Paulo (SP), which dominates seller performance and benefits from the fastest delivery times. This indicates strong operational centralization.

### 👥 Customer Retention Opportunity
A small segment of repeat customers exists, with the most loyal customer placing 14 orders. However, repeat purchasing appears limited, suggesting strong potential for retention strategies and loyalty programs.

### 🛒 Product Demand Patterns
Household and personal care categories (e.g., cama_mesa_banho, beleza_saude) lead in order volume, indicating high-frequency consumer demand.

### 💳 Payment Behavior
Credit cards account for 74% of transactions, showing heavy reliance on card-based payments. Minor data inconsistencies were detected, emphasizing the importance of validation in production systems.

### 🚚 Regional Delivery Disparity
Delivery time varies significantly by state (8–29 days), revealing logistics inequality between developed and remote regions.

### 📈 Revenue Growth Dynamics
Certain product categories experienced explosive month-over-month growth (>21x), indicating emerging demand or campaign-driven spikes. Further stability analysis is recommended.

## 📘 Detailed Business Analysis

See full analytical interpretation here:
👉 [Business Analysis Summary](04_documentation/business_analysis_summary.md)

Advanced SQL concepts used:

- `COUNT(DISTINCT)`
- `DATEFROMPARTS`
- `LAG()` window function
- `ROW_NUMBER()`
- `SUM() OVER()`
- Defensive aggregation logic

---

## 🧠 Advanced Highlight: Revenue Growth Using Window Functions

Month-over-month revenue growth per category was calculated using:

- Monthly aggregation
- `LAG()` for previous month comparison
- Growth computation
- Ranking logic

This demonstrates analytical SQL capability beyond basic aggregation.

---

## 📂 Project Structure


## Project Structure

```text
ecommerce-sql-data-engineering/
├── 01_schema/
│   └── schema.sql                  # Database DDL (Tables, Keys)
├── 02_etl/
│   ├── raw_table.sql               # Staging area for raw data
│   ├── load_data.sql               # Transformation logic
│   └── data_quality_checks.sql     # Validation scripts
├── 03_analytics/
│   └── queries.sql                 # Business KPIs & Analytics
├── 04_documentation/
│   └── normalization_explanation.pdf # ERD and normalization logic
└── README.md                       # Execution guide
```


## 🛠 Technologies Used

- SQL Server
- T-SQL
- Relational Modeling
- Window Functions
- Data Normalization (3NF)
- ETL Pipeline Design
- Data Quality Validation

---

## 🎯 Key Learning Outcomes

- Translating a flat dataset into a structured relational schema
- Identifying and resolving functional dependencies
- Detecting partial and transitive dependencies
- Designing composite primary keys
- Avoiding revenue inflation due to improper joins
- Building scalable analytical SQL logic
- Writing production-style SQL scripts

---

## 🚀 Future Improvements

- Index optimization strategy
- Query performance benchmarking
- Stored procedures for analytics
- Dashboard integration (Power BI / Tableau)
- Automation of ETL process

---

## 👨‍💻 Author

Your Name  
SQL | Data Engineering | Analytics
