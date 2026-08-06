/*===========================================================
                WINDOW FUNCTION ANALYSIS
Brazilian Olist E-commerce Dataset



Author: Simple Dhillon
===========================================================*/
SELECT *
FROM olist_orders_dataset
SELECT *
FROM olist_order_items_dataset;
SELECT *
FROM olist_order_payments_dataset;
SELECT *
FROM olist_products_dataset;

SELECT TOP 10 order_id , SUM(payment_value) AS PAY_VAL , RANK() OVER(ORDER BY SUM(payment_value) DESC)
FROM olist_order_payments_dataset
GROUP BY order_id;


/* QUES 1 For each product category, rank products by revenue. Show only the Top 3 products in every category.*/


WITH CTE AS (
	SELECT P.product_category_name , P.product_id,
	SUM(O.price) AS TOTAL_REV ,
	RANK() OVER (PARTITION BY P.product_category_name ORDER BY SUM(O.price) DESC ) AS RANKS
	FROM olist_products_dataset AS P
	INNER JOIN olist_order_items_dataset AS O
	ON P.product_id=O.product_id
	GROUP BY P.product_category_name , P.product_id
)

SELECT *
FROM CTE 
WHERE RANKS<=3;


/* QUES 2 Show each order and the previous order placed by the same customer.*/
SELECT 
	customer_id,
	order_id,
	order_purchase_timestamp,
	LAG(order_id) OVER(PARTITION BY customer_id ORDER BY order_purchase_timestamp  )  AS PREV_ORDER
FROM olist_orders_dataset;

/* QUES 3 FOR NEXT ORDER */
SELECT 
	customer_id,
	order_id,
	order_purchase_timestamp,
	LEAD(order_id) OVER(PARTITION BY customer_id ORDER BY order_purchase_timestamp  )  AS PREV_ORDER
FROM olist_orders_dataset;


/* QUES 4 Show the cumulative (running) revenue over time.
sum of all previous rows plus the current row.
Calculate a sum without reducing the number of rows.
Calculate an average without reducing the number of rows. USING AVG INSTEAD OF SUM
"Calculate a count without reducing the number of rows." USING  COUNT*/
SELECT order_id ,
payment_value,
SUM(payment_value) OVER ( 
	ORDER BY order_id ) AS RUNNING_TOTAL
FROM olist_order_payments_dataset;
/*FUNCTION(...)
OVER(...)*/
--Apply this function over a moving window of rows

--FOR AVG
SELECT order_id ,
payment_value,
AVG(payment_value) OVER ( 
	ORDER BY order_id ) AS RUNNING_AVG
FROM olist_order_payments_dataset;

