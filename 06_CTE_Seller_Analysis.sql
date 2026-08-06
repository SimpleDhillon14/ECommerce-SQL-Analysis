/*===========================================================
                SELLER ANALYSIS
Brazilian Olist E-commerce Dataset

Table Used:
olist_sellers_dataset

Author: Simple Dhillon
===========================================================*/

SELECT COUNT(*)
FROM olist_sellers_dataset;

SELECT *
FROM olist_sellers_dataset;
SELECT *
FROM olist_order_items_dataset;
/*UNIQUE OR NOT */
SELECT COUNT(DISTINCT seller_id)
FROM olist_sellers_dataset;
--CONCLUDES THAT EVERY SELLER IS UNIQUE

/* QUES 1 Which states have the highest number of sellers?*/
SELECT TOP 5 seller_state , COUNT(*) AS NO_SELLER
FROM olist_sellers_dataset
GROUP BY seller_state
ORDER BY NO_SELLER DESC;

/* QUES 2 Which sellers have generated the highest revenue?*/
SELECT TOP 5 S.seller_id , SUM(O.price) AS TOTAL_REV
FROM olist_sellers_dataset AS S
INNER JOIN olist_order_items_dataset AS O
ON S.seller_id = O.seller_id
GROUP BY S.seller_id
ORDER BY TOTAL_REV DESC;

/* QUES 3 Which sellers have sold the highest number of items?*/
SELECT TOP 10 S.seller_id , COUNT(O.product_id) AS ITEM_SOLD
FROM olist_sellers_dataset AS S
INNER JOIN olist_order_items_dataset AS O
ON S.seller_id = O.seller_id
GROUP BY S.seller_id
ORDER BY ITEM_SOLD DESC;
-- OR 
SELECT TOP 10
    seller_id,
    COUNT(*) AS ITEM_SOLD
FROM olist_order_items_dataset
GROUP BY seller_id
ORDER BY ITEM_SOLD DESC;


/* QUES 4 Find sellers who have both:
High revenue
High number of items sold*/
SELECT seller_id , 
    SUM(price) AS TOTAL_REV ,
    COUNT(*) ITEM_SOLD
FROM olist_order_items_dataset 
GROUP BY seller_id
ORDER BY TOTAL_REV DESC , ITEM_SOLD DESC;


/* QUES 6 Which seller has the highest average selling price?*/
SELECT seller_id , 
    AVG(price) AS AVG_REV 
FROM olist_order_items_dataset 
GROUP BY seller_id
ORDER BY AVG_REV DESC ;


/* QUES 7 Find sellers whose total revenue is greater than the average revenue of all sellers.*/
WITH CTE AS(
    SELECT  
        seller_id,
        SUM(price) AS TOTAL_REV 
        FROM olist_order_items_dataset 
        GROUP BY seller_id
)

SELECT seller_id , TOTAL_REV
FROM CTE 
WHERE TOTAL_REV > (
    SELECT AVG(TOTAL_REV)
    FROM CTE
)
ORDER BY TOTAL_REV DESC;
--COMPARISON BW 2 AGGREGATE AGAIN

/* QUES 8 Which seller has sold products in the highest number of distinct orders?*/
SELECT  TOP 5 seller_id , COUNT(DISTINCT order_id) AS TOTAL_ORDERS
FROM olist_order_items_dataset
GROUP BY seller_id
ORDER BY TOTAL_ORDERS DESC;

/* QUES 9 Find the Top 5 sellers with:
Total Revenue
Items Sold
Distinct Orders Fulfilled
Average Selling Price*/

SELECT TOP 5 seller_id, 
SUM(price) AS TOTAL_REV ,
COUNT(*) AS ITEM_SOLD ,
COUNT(DISTINCT order_id) AS TOTAL_ORDERS,
AVG(price) AS AVG_PRICE
FROM olist_order_items_dataset
GROUP BY seller_id
ORDER BY SUM(price) DESC;

