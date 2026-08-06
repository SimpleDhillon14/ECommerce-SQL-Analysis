/*===========================================================
               CUSTOMER ANALYSIS
Brazilian Olist E-commerce Dataset

Table Used:
olist_customers_dataset

Author: Simple Dhillon
===========================================================*/

SELECT TOP 5 * FROM olist_customers_dataset;
SELECT * FROM olist_orders_dataset;
/* QUES 1 How many unique customers does the company have*/
SELECT COUNT(DISTINCT customer_unique_id)
FROM olist_customers_dataset;

/* QUES 2 How many customers placed more than one order*/
SELECT COUNT(*)
FROM 
(
SELECT C.customer_unique_id,Count(O.order_id) AS TOTAL_ORDERS
FROM olist_customers_dataset AS C
INNER JOIN olist_orders_dataset AS O
ON C.customer_id=O.customer_id
GROUP BY C.customer_unique_id
HAVING COUNT(O.order_id) > 1
) AS T;

/* QUES 3 Which customers have placed the highest number of orders?*/
SELECT TOP 3 C.customer_unique_id,Count(O.order_id) AS TOTAL_ORDERS
FROM olist_customers_dataset AS C
INNER JOIN olist_orders_dataset AS O
ON C.customer_id=O.customer_id
GROUP BY C.customer_unique_id
ORDER BY COUNT(O.order_id) DESC;

/* QUES 4 Which states generate the highest revenue?*/
SELECT C.customer_state , SUM(P.payment_value) AS TOTAL_REV
FROM olist_customers_dataset AS C
INNER JOIN olist_orders_dataset AS O
ON C.customer_id = O.customer_id
INNER JOIN olist_order_payments_dataset AS P
ON O.order_id = P.order_id
GROUP BY C.customer_state
ORDER BY SUM(P.payment_value) DESC;

/* QUES 5 Find the Top 5 cities by revenue in the entire country..*/
SELECT TOP 5 C.customer_state ,C.customer_city, SUM(P.payment_value) AS TOTAL_REV
FROM olist_customers_dataset AS C
INNER JOIN olist_orders_dataset AS O
ON C.customer_id = O.customer_id
INNER JOIN olist_order_payments_dataset AS P
ON O.order_id = P.order_id
GROUP BY C.customer_state,C.customer_city
ORDER BY SUM(P.payment_value) DESC;

/* QUES 6 Find the Top 5 cities by revenue within each state.*/
/*USED SUBQUERY FOR RANKS CONSTRAINT*/
SELECT *
FROM (
	SELECT  C.customer_state ,C.customer_city, SUM(P.payment_value) AS TOTAL_REV, RANK() OVER(PARTITION BY C.customer_state ORDER BY SUM(P.payment_value) DESC ) AS RANKS
FROM olist_customers_dataset AS C
INNER JOIN olist_orders_dataset AS O
ON C.customer_id = O.customer_id
INNER JOIN olist_order_payments_dataset AS P
ON O.order_id = P.order_id
GROUP BY C.customer_state, C.customer_city
) AS T
WHERE RANKS <=5;

/* QUES 7 Classify customers into three segments based on their total spending:
Low Value: Total spending < 100
Medium Value: Total spending between 100 and 500
High Value: Total spending > 500
Then count how many customers belong to each segment.*/
SELECT 
	CATEGORY,
	COUNT(*) AS CUST_COUNT
FROM (
	SELECT 
	C.customer_unique_id, 
	SUM(P.payment_value) AS TOTAL_SPENT,
	CASE 
	WHEN SUM(P.payment_value) < 100 THEN 'LOW'
	WHEN SUM(P.payment_value) < 500 THEN 'MED'
	ELSE 'HIGH'
END AS CATEGORY
FROM olist_customers_dataset AS C
INNER JOIN olist_orders_dataset AS O
ON C.customer_id = O.customer_id
INNER JOIN olist_order_payments_dataset AS P
ON O.order_id = P.order_id
GROUP BY C.customer_unique_id
) AS T
GROUP BY CATEGORY;
 
/* QUES 8 Find customers who spent more than the average customer spending*/
SELECT *
FROM
(
    SELECT 
        C.customer_unique_id,
        SUM(P.payment_value) AS TOTAL_SPENT
    FROM olist_customers_dataset AS C
    INNER JOIN olist_orders_dataset AS O
        ON C.customer_id = O.customer_id
    INNER JOIN olist_order_payments_dataset AS P
        ON O.order_id = P.order_id
    GROUP BY C.customer_unique_id
) AS CUSTOMER_SPENDING
WHERE TOTAL_SPENT >
(
    SELECT AVG(TOTAL_SPENT)
    FROM
    (
        SELECT 
            C.customer_unique_id,
            SUM(P.payment_value) AS TOTAL_SPENT
        FROM olist_customers_dataset AS C
        INNER JOIN olist_orders_dataset AS O
            ON C.customer_id = O.customer_id
        INNER JOIN olist_order_payments_dataset AS P
            ON O.order_id = P.order_id
        GROUP BY C.customer_unique_id
    ) AS AVG_SPENDING
);
