-- Builds the clean layer (real data types) from the raw staging tables.
-- Rebuilds the clean layer from staging. Safe to rerun.
DROP SCHEMA IF EXISTS clean CASCADE;
CREATE SCHEMA IF NOT EXISTS clean;

CREATE TABLE clean.orders AS
SELECT
    order_id,
    customer_id,
    order_status,
    NULLIF(order_purchase_timestamp, '')::timestamp       AS purchase_ts,
    NULLIF(order_approved_at, '')::timestamp              AS approved_ts,
    NULLIF(order_delivered_carrier_date, '')::timestamp   AS carrier_ts,
    NULLIF(order_delivered_customer_date, '')::timestamp  AS delivered_ts,
    NULLIF(order_estimated_delivery_date, '')::timestamp  AS estimated_ts,
    (order_status = 'delivered'
       AND NULLIF(order_delivered_customer_date, '') IS NOT NULL) AS is_delivery_valid,
    (order_status = 'delivered'
       AND NULLIF(order_delivered_customer_date, '') IS NOT NULL
       AND NULLIF(order_delivered_customer_date, '')::timestamp
         > NULLIF(order_estimated_delivery_date, '')::timestamp) AS is_late
FROM staging.orders;

CREATE TABLE clean.order_items AS
SELECT
    order_id,
    order_item_id::int                          AS order_item_id,
    product_id,
    seller_id,
    NULLIF(shipping_limit_date, '')::timestamp  AS shipping_limit_ts,
    price::numeric(12,2)                        AS price,
    freight_value::numeric(12,2)                AS freight_value
FROM staging.order_items;

CREATE TABLE clean.order_payments AS
SELECT
    order_id,
    payment_sequential::int       AS payment_sequential,
    payment_type,
    payment_installments::int     AS payment_installments,
    payment_value::numeric(12,2)  AS payment_value
FROM staging.order_payments;

CREATE TABLE clean.customers AS
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    INITCAP(TRIM(customer_city)) AS customer_city,
    UPPER(TRIM(customer_state))  AS customer_state
FROM staging.customers;

CREATE TABLE clean.order_reviews AS
SELECT DISTINCT ON (order_id)
       order_id,
       review_id,
       review_score::int AS review_score,
       NULLIF(review_creation_date, '')::timestamp AS review_created_ts
FROM staging.order_reviews
ORDER BY order_id, NULLIF(review_creation_date, '')::timestamp DESC NULLS LAST, review_id;

ALTER TABLE clean.orders ADD PRIMARY KEY (order_id);
ALTER TABLE clean.customers ADD PRIMARY KEY (customer_id);
ALTER TABLE clean.order_reviews ADD PRIMARY KEY (order_id);
ALTER TABLE clean.order_items ADD PRIMARY KEY (order_id, order_item_id);
ALTER TABLE clean.order_payments ADD PRIMARY KEY (order_id, payment_sequential);
