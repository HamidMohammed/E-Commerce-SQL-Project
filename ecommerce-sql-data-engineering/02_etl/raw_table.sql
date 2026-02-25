IF OBJECT_ID('dbo.raw_table', 'U') IS NOT NULL
    DROP TABLE dbo.raw_table;
GO
-- staging table.
CREATE TABLE raw_table (
    empty_start_column VARCHAR(MAX),
    order_id VARCHAR(MAX),
    order_item_id VARCHAR(MAX),
    customer_id VARCHAR(MAX),
    customer_unique_id VARCHAR(MAX),
    customer_zip_code_prefix VARCHAR(MAX),
    customer_city VARCHAR(MAX),
    customer_state VARCHAR(MAX),
    product_id VARCHAR(MAX),
    product_category_name VARCHAR(MAX),
    product_name_length VARCHAR(MAX),      -- No more INT crash
    product_description_length VARCHAR(MAX),-- No more INT crash
    product_photos_qty VARCHAR(MAX),
    product_weight_g VARCHAR(MAX),
    product_length_cm VARCHAR(MAX),
    product_height_cm VARCHAR(MAX),
    product_width_cm VARCHAR(MAX),
    seller_id VARCHAR(MAX),
    seller_city VARCHAR(MAX),
    seller_state VARCHAR(MAX),
    seller_zip_code_prefix VARCHAR(MAX),
    payment_type VARCHAR(MAX),
    payment_sequential VARCHAR(MAX),
    payment_installments VARCHAR(MAX),
    price VARCHAR(MAX),
    freight_value VARCHAR(MAX),
    payment_value VARCHAR(MAX),
    shipping_limit_date VARCHAR(MAX),
    order_purchase_timestamp VARCHAR(MAX),
    order_approved_at VARCHAR(MAX),
    order_delivered_carrier_date VARCHAR(MAX),
    order_delivered_customer_date VARCHAR(MAX),
    order_estimated_delivery_date VARCHAR(MAX),
    day_of_purchase VARCHAR(MAX),
    month_of_purchase VARCHAR(MAX),
    year_of_purchase VARCHAR(MAX),
    month_year_of_purchase VARCHAR(MAX),
    order_status VARCHAR(MAX),
    order_unique_id VARCHAR(MAX)
);
go
-- load into raw table 
TRUNCATE TABLE raw_table;
BULK INSERT raw_table
FROM '\\Mac\Home\Documents\SQL Server Management Studio\Code Snippets\SQLPoject\Olist_Dataset\Brazilian E-Commerce Public Dataset by Olist.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n',
    TABLOCK
);
