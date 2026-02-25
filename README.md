# 🛒 E-Commerce SQL Data Engineering Project

## 📌 Project Overview
This project demonstrates full database normalization (3NF), ETL processing, and analytical SQL queries using a denormalized e-commerce dataset.

The project includes:

- Data modeling & normalization
- Data quality validation
- ETL pipeline (raw → normalized schema)
- Business analytics queries
- Window functions for advanced analysis

---

## 🧱 Database Architecture

### Raw Layer
- `raw_table` (Flat CSV import)

### Normalized Layer (3NF)
- customer
- seller
- product
- orders
- shipping
- order_item
- payment

---

## 🔄 ETL Strategy

- Conflict detection using GROUP BY diagnostics
- Controlled use of DISTINCT
- Aggregation collapse for duplicated payment records
- Primary and Foreign Key enforcement

---

## 📊 Analytical Queries Implemented

- Top customers by spending
- Revenue by state
- Seller performance
- Monthly revenue trends
- Payment distribution
- Delivery performance
- Revenue growth (Window functions)

---

## 🛠 Technologies Used
- SQL Server
- T-SQL
- Window Functions (LAG, ROW_NUMBER)
- GROUP BY Aggregations
- Date handling (DATEFROMPARTS)

---
ecommerce-sql-project/
│
├── README.md
│
├── 01_schema/
│   └── schema.sql
│
├── 02_etl/
│   ├── raw_table.sql
│   ├── load_data.sql
│   └── data_quality_checks.sql
│
├── 03_analytics/
│   └── queries.sql
│
└── 04_documentation/
    └── normalization_explanation.pdf
 ---
 
## 👨‍💻 Author
hamid mohamed
