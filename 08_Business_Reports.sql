/*===========================================================
                FINAL ANALYSIS
Brazilian Olist E-commerce Dataset

Table Used:
ALL

Author: Simple Dhillon
===========================================================*/
SELECT *
FROM olist_products_dataset;
SELECT *
FROM olist_order_items_dataset;
SELECT *
FROM olist_customers_dataset;
SELECT *
FROM olist_orders_dataset;
SELECT *
FROM olist_order_payments_dataset;

/* QUES 1 Which 10 product categories generated the highest revenue?*/
SELECT TOP 10 P.product_category_name , SUM(O.price) AS TOTAL_REV
FROM olist_products_dataset AS P
INNER JOIN olist_order_items_dataset AS O
ON P.product_id=O.product_id
GROUP BY P.product_category_name
ORDER BY TOTAL_REV DESC;


/* QUES 2 Which product categories are popular (high sales volume) but have relatively low average selling price?*/
SELECT TOP 5 P.product_category_name , 
	AVG(O.price) AS AVG_PRICE ,
	COUNT(*) AS ITEM_SOLD
FROM olist_products_dataset AS P
INNER JOIN olist_order_items_dataset AS O
ON P.product_id=O.product_id
GROUP BY P.product_category_name
ORDER BY ITEM_SOLD DESC;


/* QUES 3 Which sellers generated above-average revenue?*/
WITH CTE AS (
SELECT seller_id ,
    SUM(price) AS TOTAL_REV
FROM olist_order_items_dataset
GROUP BY seller_id )

SELECT *
FROM CTE 
WHERE TOTAL_REV >
	( SELECT AVG(TOTAL_REV)
		FROM CTE	)

/* QUES 4 Find the top 3 sellers in each seller state based on total revenue
SELLER WITH ORDER ITEMS
GROUP BY SELLER ID , SELLER STATE,
PARTITION BY SELLER STATE ORDER BY TOTAL_REV ,
USE OF CTE BCOZ AFTER USING RANK WINDOW FN I WILL CLARIFY THAT RANKS<=3*/


/* QUES 5 Find customers who have placed more than one order and calculate their total spending. Rank them by total spending (highest first).*/

