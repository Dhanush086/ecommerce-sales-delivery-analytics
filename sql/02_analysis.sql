-- 1. Orders per month (all statuses, Sep 2016 to Aug 2018)
SELECT DATE_TRUNC('month', purchase_ts) AS order_month,
       COUNT(*) AS orders
FROM clean.orders
WHERE purchase_ts >= '2016-09-01' AND purchase_ts < '2018-09-01'
GROUP BY order_month
ORDER BY order_month;

-- 2. Monthly item sales (excludes canceled and unavailable orders)
SELECT DATE_TRUNC('month', o.purchase_ts) AS order_month,
       COUNT(DISTINCT o.order_id) AS orders,
       SUM(i.price) AS item_sales,
       SUM(i.freight_value) AS freight
FROM clean.orders o
JOIN clean.order_items i ON i.order_id = o.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
  AND o.purchase_ts >= '2016-09-01' AND o.purchase_ts < '2018-09-01'
GROUP BY order_month
ORDER BY order_month;

-- 3. Delivery: average days and late orders (valid delivered orders only)
SELECT COUNT(*) AS delivered_orders,
       ROUND(AVG(EXTRACT(EPOCH FROM (delivered_ts - purchase_ts)) / 86400)::numeric, 1) AS avg_delivery_days,
       COUNT(*) FILTER (WHERE delivered_ts > estimated_ts) AS late_orders
FROM clean.orders
WHERE is_delivery_valid;

-- 4. Late delivery by month
SELECT DATE_TRUNC('month', purchase_ts) AS order_month,
       COUNT(*) AS delivered_orders,
       COUNT(*) FILTER (WHERE delivered_ts > estimated_ts) AS late_orders,
       ROUND(100.0 * COUNT(*) FILTER (WHERE delivered_ts > estimated_ts) / COUNT(*), 1) AS late_pct
FROM clean.orders
WHERE is_delivery_valid
  AND purchase_ts >= '2016-09-01' AND purchase_ts < '2018-09-01'
GROUP BY order_month
ORDER BY order_month;

-- 5. Repeat customers (customer = customer_unique_id)
WITH per_customer AS (
    SELECT c.customer_unique_id,
           COUNT(DISTINCT o.order_id) AS orders
    FROM clean.orders o
    JOIN clean.customers c ON c.customer_id = o.customer_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable')
    GROUP BY c.customer_unique_id
)
SELECT COUNT(*) AS customers,
       COUNT(*) FILTER (WHERE orders >= 2) AS repeat_customers,
       ROUND(100.0 * COUNT(*) FILTER (WHERE orders >= 2) / COUNT(*), 2) AS repeat_pct,
       MAX(orders) AS max_orders_by_one_person
FROM per_customer;

-- 6. Payment types
SELECT payment_type,
       COUNT(DISTINCT order_id) AS orders,
       COUNT(*) AS payment_rows,
       SUM(payment_value) AS payment_value,
       ROUND(AVG(payment_installments), 1) AS avg_installments
FROM clean.order_payments
GROUP BY payment_type
ORDER BY orders DESC;

-- 7. Item sales by customer state, with share of total and rank
SELECT c.customer_state,
       SUM(i.price) AS item_sales,
       ROUND(100.0 * SUM(i.price) / SUM(SUM(i.price)) OVER (), 1) AS pct_of_total,
       RANK() OVER (ORDER BY SUM(i.price) DESC) AS sales_rank
FROM clean.orders o
JOIN clean.order_items i ON i.order_id = o.order_id
JOIN clean.customers c ON c.customer_id = o.customer_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY c.customer_state
ORDER BY item_sales DESC;

-- 8. Review score: late vs on-time delivered orders (one review per order, latest kept)
SELECT
    CASE WHEN o.is_late THEN 'Late' ELSE 'On time' END AS delivery,
    COUNT(*) AS orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    ROUND(100.0 * COUNT(*) FILTER (WHERE r.review_score <= 2) / COUNT(*), 1) AS pct_low_scores
FROM clean.orders o
JOIN clean.order_reviews r ON r.order_id = o.order_id
WHERE o.is_delivery_valid
GROUP BY 1
ORDER BY 1;

