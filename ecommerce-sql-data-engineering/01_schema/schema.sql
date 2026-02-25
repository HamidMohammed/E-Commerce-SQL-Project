/*
===============================================================================
DDL Script: Create Normalized Tables (3NF Schema)
===============================================================================
Script Purpose:
    This script creates the normalized relational tables for the e-commerce
    analytical database. Existing tables are dropped before creation to allow
    safe re-execution.

Schema Overview:
    - customer
    - seller
    - product
    - orders
    - shipping
    - order_item
    - payment

Execution Notes:
    - Run this script before loading data.
    - All primary and foreign key constraints are defined.
    - Designed for SQL Server.
===============================================================================
*/
use SQLTask
go
IF OBJECT_ID('dbo.customer', 'U') IS NOT NULL
    DROP TABLE dbo.customer;
GO
CREATE TABLE customer (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50) NOT NULL ,   -- not unique adding UNIQUE causing error while inserting
    customer_zip_code_prefix VARCHAR(10) NOT NULL,
    customer_city VARCHAR(100) NOT NULL,
    customer_state VARCHAR(50) NOT NULL
);

GO
IF OBJECT_ID('dbo.orders', 'U') IS NOT NULL
    DROP TABLE dbo.orders;
GO
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    order_status VARCHAR(50) NOT NULL,
    order_purchase_timestamp DATETIME2  NULL,
    order_approved_at DATETIME2 NULL,
    order_delivered_carrier_date DATETIME2 NULL,
    order_delivered_customer_date DATETIME2 NULL,
    order_estimated_delivery_date DATETIME2 NULL,
    
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
GO
GO
IF OBJECT_ID('dbo.product', 'U') IS NOT NULL
    DROP TABLE dbo.product;
GO
CREATE TABLE product (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100) NOT NULL,
    product_name_length INT NOT NULL,
    product_description_length INT NOT NULL,
    product_photos_qty INT NOT NULL,
    product_weight_g INT NOT NULL,
    product_length_cm DECIMAL(10,2) NOT NULL,
    product_height_cm DECIMAL(10,2) NOT NULL,
    product_width_cm DECIMAL(10,2) NOT NULL
);
go
IF OBJECT_ID('dbo.order_item', 'U') IS NOT NULL
    DROP TABLE dbo.order_item;
GO

IF OBJECT_ID('dbo.seller', 'U') IS NOT NULL
    DROP TABLE dbo.seller;
GO
CREATE TABLE seller (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10) NOT NULL,
    seller_city VARCHAR(100) NOT NULL,
    seller_state VARCHAR(50) NOT NULL
);

GO
CREATE TABLE order_item (
    order_id VARCHAR(50) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    seller_id VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    freight_value DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (order_id, order_item_id),

    FOREIGN KEY (order_id) REFERENCES orders(order_id) 
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (seller_id) REFERENCES seller(seller_id)
);


GO

IF OBJECT_ID('dbo.payment', 'U') IS NOT NULL
    DROP TABLE dbo.payment;
GO
CREATE TABLE payment (
    order_id VARCHAR(50) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(50) NOT NULL,
    payment_installments INT  NULL,
    payment_value DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (order_id, payment_sequential),

    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE 
);

GO
IF OBJECT_ID('dbo.shipping', 'U') IS NOT NULL
    DROP TABLE dbo.shipping;
GO
CREATE TABLE shipping (
    order_id VARCHAR(50) PRIMARY KEY,
    shipping_limit_date DATETIME2  NULL,
    order_delivered_carrier_date DATETIME2 NULL,
    order_delivered_customer_date DATETIME2 NULL,
    order_estimated_delivery_date DATETIME2  NULL,

    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

GO

