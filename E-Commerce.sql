create database eco;
use eco;

#1. Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics
SELECT 
    CASE
        WHEN DAYOFWEEK(o.order_purchase_timestamp) IN (1,7) THEN 'Weekend' 
        ELSE 'Weekday'
    END AS Day, 
    SUM(ROUND(p.payment_value)) AS SUM_PAYMENT_VALUE,
    ROUND(AVG(ROUND(p.payment_value)), 2) AS AVG_PAYMENT_VALUE, 
    MIN(ROUND(p.payment_value)) AS MIN_PAYMENT_VALUE,
    MAX(ROUND(p.payment_value)) AS MAX_PAYMENT_VALUE
FROM 
    olist_orders_dataset o
JOIN 
    olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY 
    Day
ORDER BY 
    Day;
    
#2. Number of Orders with review score 5 and payment type as credit card.
SELECT 
    pmt.payment_type,
    r.review_score,
    COUNT(*) AS Total_Orders
FROM 
    olist_order_reviews_dataset r
INNER JOIN 
    olist_order_payments_dataset pmt ON r.order_id = pmt.order_id
WHERE  
    r.review_score = 5
    AND pmt.payment_type = 'credit_card'
GROUP BY 
    pmt.payment_type, r.review_score;

#3. Average number of days taken for order_delivered_customer_date for pet_shop
SELECT 
    p.product_category_name,
    COUNT(*) AS Total_Orders,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp))) AS Avg_Delivery_Days
FROM 
    olist_orders_dataset o
JOIN 
    olist_order_items_dataset it ON o.order_id = it.order_id
JOIN 
    olist_products_dataset p ON it.product_id = p.product_id
WHERE 
    p.product_category_name = 'pet_shop'
GROUP BY 
    p.product_category_name;
    
    
#4. Average price and payment values from customers of sao paulo city
WITH orderItemsAvg AS (
    SELECT cust.customer_city, ROUND(AVG(item.price)) AS avg_order_item_price
    FROM olist_order_items_dataset item
    JOIN olist_orders_dataset ord ON item.order_id = ord.order_id
    JOIN olist_customers_dataset cust ON ord.customer_id = cust.customer_id
    WHERE cust.customer_city = 'Sao Paulo'
)

SELECT 
    cust.customer_city,(SELECT avg_order_item_price FROM orderItemsAvg) AS avg_order_item_price,
    ROUND(AVG(pmt.payment_value)) AS avg_payment_value
FROM 
    olist_order_payments_dataset pmt
JOIN 
    olist_orders_dataset ord ON pmt.order_id = ord.order_id
JOIN 
    olist_customers_dataset cust ON ord.customer_id = cust.customer_id
WHERE 
    cust.customer_city = 'Sao Paulo';


#5. Relationship between shipping days (order_delivered_customer_date- order_purchase_timestamp) Vs review scores.
select
    r.review_score,
    round(avg(datediff(o.order_delivered_customer_date, o.order_purchase_timestamp))) as Avg_shipping_days
    from olist_orders_dataset o
    join olist_order_reviews_dataset r
    on r.order_id = o.order_id 
	group by r.review_score
	order by r.review_score;
