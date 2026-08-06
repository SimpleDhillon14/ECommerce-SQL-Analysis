/*===========================================================
                PAYMENT AND ORDERS ANALYSIS
Brazilian Olist E-commerce Dataset

Table Used:
olist_order_payments_dataset

Author: Simple Dhillon
===========================================================*/
/* QUES 1 Show me every order along with its payment type and payment amount.*/
SELECT O.order_id, O.order_status,P.payment_type,P.payment_value
FROM olist_orders_dataset AS O
INNER JOIN olist_order_payments_dataset AS P
ON O.order_id=P.order_id;

/* QUES 2 How much revenue was generated from each order status*/
SELECT  O.order_status, SUM(P.payment_value)
FROM olist_orders_dataset AS O
INNER JOIN olist_order_payments_dataset AS P
ON O.order_id=P.order_id
GROUP BY O.order_status;

/* QUES 3 Which payment method generates the highest revenue for delivered orders only*/
SELECT TOP 1 P.payment_type, SUM(P.payment_value) AS TOTAL_REV
FROM olist_orders_dataset AS O
INNER JOIN olist_order_payments_dataset AS P
ON O.order_id=P.order_id
WHERE O.order_status= 'Delivered'
GROUP BY P.payment_type
ORDER BY SUM(P.payment_value) DESC;

/* QUES 4 For each order status, find:
Number of orders
Total revenue
Average payment*/
SELECT O.order_status ,COUNT(DISTINCT O.order_id), SUM(P.payment_value) AS TOTAL_REV , AVG(P.payment_value) AS AVERAGEP
FROM olist_orders_dataset AS O
INNER JOIN olist_order_payments_dataset AS P
ON O.order_id=P.order_id
GROUP BY O.order_status;


/* QUES 5Find the top 5 highest-value orders.*/
SELECT TOP 5 O.order_id , SUM(P.payment_value) AS TOTAL_REV 
FROM olist_orders_dataset AS O
INNER JOIN olist_order_payments_dataset AS P
ON O.order_id=P.order_id
GROUP BY O.order_id
ORDER BY SUM(P.payment_value) DESC;

/* QUES 6  Find the Top 5 customers who spent the most money*/
SELECT * FROM olist_orders_dataset;
SELECT * FROM olist_order_payments_dataset;
SELECT TOP 5 O.customer_id , SUM(P.payment_value) AS TOTAL_REV 
FROM olist_orders_dataset AS O
INNER JOIN olist_order_payments_dataset AS P
ON O.order_id=P.order_id
GROUP BY O.customer_id
ORDER BY SUM(P.payment_value) DESC;

/* QUES 7 Among customers who placed at least 3 orders, which 10 customers spent the most money*/
SELECT TOP 10 O.customer_id , COUNT(DISTINCT O.order_id),SUM(P.payment_value) AS TOTAL_REV 
FROM olist_orders_dataset AS O
INNER JOIN olist_order_payments_dataset AS P
ON O.order_id=P.order_id
GROUP BY O.customer_id
HAVING COUNT(DISTINCT O.order_id) >=3
ORDER BY SUM(P.payment_value) DESC;

/* QUES 8 To check indexes*/
EXEC sp_help 'olist_orders_dataset';
EXEC sp_help 'olist_order_payments_dataset';

/* QUES 9 Creating index
CREATE INDEX IX_Orders_OrderID
ON olist_orders_dataset(order_id);
CREATE INDEX IX_Payments_OrderID
ON olist_order_payments_dataset(order_id);*/


/* QUES 10  Classify orders into three categories based on their total value:
Low: Less than ₹100
Medium: ₹100 to ₹500
High: More than ₹500
Then show how many orders fall into each category.*/
SELECT 
    CATEGORY,
    COUNT(*) AS ORDER_COUNT
FROM
(
SELECT order_id , SUM(payment_value) AS TOTAL_VAL,
CASE WHEN SUM(payment_value) <100 THEN 'LOW'
	WHEN SUM(payment_value)<500 THEN 'MED'
	ELSE 'HIGH'
END AS CATEGORY
FROM olist_order_payments_dataset
GROUP BY order_id
) AS T
GROUP BY CATEGORY;

/*easy version*/
SELECT
    CASE
        WHEN TOTAL_VAL < 100 THEN 'LOW'
        WHEN TOTAL_VAL < 500 THEN 'MED'
        ELSE 'HIGH'
    END AS CATEGORY,
    COUNT(*) AS ORDER_COUNT
FROM
(
    SELECT 
        order_id,
        SUM(payment_value) AS TOTAL_VAL
    FROM olist_order_payments_dataset
    GROUP BY order_id
) AS T
GROUP BY
    CASE
        WHEN TOTAL_VAL < 100 THEN 'LOW'
        WHEN TOTAL_VAL < 500 THEN 'MED'
        ELSE 'HIGH'
    END;

/* QUES 11 Find the top 10 customers by total spending, but also show their rank among all customers.*/
SELECT TOP 10 O.customer_id , SUM(P.payment_value) AS TOTAL_SPENT , RANK() OVER(ORDER BY SUM(P.payment_value) DESC) AS RANKING
FROM olist_orders_dataset AS O
INNER JOIN olist_order_payments_dataset AS P
ON O.order_id = P.order_id
GROUP BY O.customer_id
ORDER BY SUM(P.payment_value) DESC;

/* QUES 12 Find the second highest spending customer*/
SELECT * 
FROM (SELECT O.customer_id , SUM(P.payment_value) AS TOTAL_SPENT , RANK() OVER(ORDER BY SUM(P.payment_value) DESC) AS RANKING
FROM olist_orders_dataset AS O
INNER JOIN olist_order_payments_dataset AS P
ON O.order_id = P.order_id
GROUP BY O.customer_id
) AS T
WHERE RANKING = 2;

/* QUES 13 Find the top 3 customers in each payment category.*/
SELECT * 
FROM (SELECT O.customer_id ,P.payment_type, SUM(P.payment_value) AS TOTAL_SPENT , ROW_NUMBER() OVER( PARTITION BY P.payment_type ORDER BY SUM(P.payment_value) DESC) AS RANKING
FROM olist_orders_dataset AS O
INNER JOIN olist_order_payments_dataset AS P
ON O.order_id = P.order_id
GROUP BY O.customer_id,P.payment_type) AS T
WHERE RANKING<=3;

/* QUES 14 Find customers who have placed more than one order and calculate their total number of orders and total spending.*/

