/*
===============================================================================
ETL Script: Load Data from Raw Table into 3NF Schema
===============================================================================
Script Purpose:
    This script extracts data from the denormalized 'raw_table'
    and loads it into the normalized schema using controlled
    INSERT INTO ... SELECT logic.

Data Validation Strategy:
    - Duplicate detection performed using GROUP BY diagnostics.
    - SELECT DISTINCT used only after conflict verification.
    - Financial data validated to prevent row multiplication errors.

Loading Order:
    1. customer
    2. product
    3. seller
    4. orders 
    5. shipping
    6. order_item
    7. payment

Execution Notes:
    - Ensure raw_table is populated before execution.
    - Foreign key dependencies require strict execution order.
===============================================================================
*/

Create PROC sp_LoadOlistData
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Customers (Uses GROUP BY to deduplicate and NOT EXISTS to avoid 2627 errors)
        INSERT INTO customer (customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
        SELECT customer_id, MAX(customer_unique_id), MAX(customer_zip_code_prefix), MAX(customer_city), MAX(customer_state)
        FROM raw_table r
        WHERE customer_id IS NOT NULL 
          AND NOT EXISTS (SELECT 1 FROM customer c WHERE c.customer_id = r.customer_id)
        GROUP BY customer_id;

        -- 2. Products (Double Cast for decimals like '58.0' and NULLIF for empty strings)
        INSERT INTO product (product_id, product_category_name, product_name_length, product_description_length, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm)
        SELECT product_id, MAX(product_category_name), 
               CAST(CAST(NULLIF(MAX(product_name_length), '') AS DECIMAL(18,2)) AS INT),
               CAST(CAST(NULLIF(MAX(product_description_length), '') AS DECIMAL(18,2)) AS INT),
               CAST(CAST(NULLIF(MAX(product_photos_qty), '') AS DECIMAL(18,2)) AS INT),
               CAST(CAST(NULLIF(MAX(product_weight_g), '') AS DECIMAL(18,2)) AS INT),
               CAST(NULLIF(MAX(product_length_cm), '') AS DECIMAL(18,2)),
               CAST(NULLIF(MAX(product_height_cm), '') AS DECIMAL(18,2)),
               CAST(NULLIF(MAX(product_width_cm), '') AS DECIMAL(18,2))
        FROM raw_table r
        WHERE product_id IS NOT NULL 
          AND NOT EXISTS (SELECT 1 FROM product p WHERE p.product_id = r.product_id)
          GROUP BY product_id;

		-- 3. seller
		INSERT INTO seller (
			seller_id,
			seller_zip_code_prefix,
			seller_city,
			seller_state
		)
		SELECT DISTINCT
			seller_id,
			seller_zip_code_prefix,
			seller_city,
			seller_state
		FROM raw_table
		WHERE seller_id IS NOT NULL;

        -- 4. Orders (TRY_CAST fixes Msg 241 by handling bad date formats as NULL)
        INSERT INTO orders (order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at)
        SELECT order_id, MAX(customer_id), MAX(order_status), 
               TRY_CAST(MAX(order_purchase_timestamp) AS DATETIME2), 
               TRY_CAST(MAX(order_approved_at) AS DATETIME2)
        FROM raw_table r
        WHERE order_id IS NOT NULL 
          AND NOT EXISTS (SELECT 1 FROM orders o WHERE o.order_id = r.order_id)
        GROUP BY order_id;

        -- 5. Shipping (Handling all date columns with TRY_CAST)
        INSERT INTO shipping (order_id, shipping_limit_date, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date)
        SELECT order_id, 
               TRY_CAST(MAX(shipping_limit_date) AS DATETIME2),
               TRY_CAST(MAX(order_delivered_carrier_date) AS DATETIME2),
               TRY_CAST(MAX(order_delivered_customer_date) AS DATETIME2),
               TRY_CAST(MAX(order_estimated_delivery_date) AS DATETIME2)
        FROM raw_table r
        WHERE order_id IS NOT NULL 
          AND NOT EXISTS (SELECT 1 FROM shipping s WHERE s.order_id = r.order_id)
        GROUP BY order_id;

        -- 6. Order Items
		INSERT INTO order_item (
			order_id,
			order_item_id,
			product_id,
			seller_id,
			price,
			freight_value
		)
		SELECT DISTINCT
			order_id,
			CAST(order_item_id AS INT),
			product_id,
			seller_id,
			CAST(price AS DECIMAL(10,2)),
			CAST(freight_value AS DECIMAL(10,2))
		FROM raw_table
		WHERE order_id IS NOT NULL;

		-- 7. payment
			INSERT INTO payment (
			order_id,
			payment_sequential,
			payment_type,
			payment_installments,
			payment_value
		)
		SELECT 
			order_id,
			TRY_CAST(payment_sequential AS INT),
			MAX(payment_type),
			TRY_CAST(MAX(payment_installments) AS INT),
			TRY_CAST(MAX(payment_value) AS DECIMAL(10,2))
		FROM raw_table
		WHERE order_id IS NOT NULL
		GROUP BY order_id, payment_sequential;

        COMMIT TRANSACTION;
        PRINT 'SUCCESS: Data loaded and converted without crashing.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNum, ERROR_MESSAGE() AS Msg, ERROR_LINE() AS Line;
    END CATCH
END;
GO
exec sp_LoadOlistData

