/*===========================================================
                PRODUCT ANALYSIS
Brazilian Olist E-commerce Dataset

Table Used:
olist_products_dataset

Author: Simple Dhillon
===========================================================*/
SELECT *
FROM olist_products_dataset;
SELECT *
FROM olist_order_items_dataset;

/* QUES 1 "How many different products were sold?"*/
SELECT COUNT(DISTINCT product_id)
FROM olist_order_items_dataset;

/* QUES 2 Which are the Top 10 most sold products?*/
SELECT TOP 10 product_id , COUNT(*) AS TIMES_SOLD
FROM olist_order_items_dataset
GROUP BY product_id
ORDER BY COUNT(*) DESC;

/* QUES 3 Which are the Top 10 highest revenue-generating products?*/
SELECT TOP 10 product_id, SUM(price) AS TOTAL_REV
FROM olist_order_items_dataset
GROUP BY product_id
ORDER BY SUM(price) DESC;

/* QUES 4 Which product categories generate the highest revenue?*/
SELECT P.product_category_name , SUM(O.price) AS TOTAL_REV
FROM olist_products_dataset AS P
INNER JOIN olist_order_items_dataset AS O
ON P.product_id=O.product_id 
GROUP BY P.product_category_name
ORDER BY SUM(O.price) DESC;

/* QUES 5 Which product categories have the highest average selling price?*/
SELECT P.product_category_name , AVG(O.price) AS TOTAL_AVG_REV
FROM olist_products_dataset AS P
INNER JOIN olist_order_items_dataset AS O
ON P.product_id=O.product_id 
GROUP BY P.product_category_name
ORDER BY AVG(O.price) DESC;

/* QUES 6 Which product categories sold the highest number of items?*/
SELECT P.product_category_name , COUNT(*) AS TOTAL_ITEMS_SOLD
FROM olist_products_dataset AS P
INNER JOIN olist_order_items_dataset AS O
ON P.product_id=O.product_id 
GROUP BY P.product_category_name
ORDER BY COUNT(*) DESC;

/* QUES 7 Which products have the highest average selling price?*/
SELECT TOP 5 P.product_id , AVG(O.price) AS TOTAL_AVG_REV
FROM olist_products_dataset AS P
INNER JOIN olist_order_items_dataset AS O
ON P.product_id=O.product_id 
GROUP BY P.product_id
ORDER BY AVG(O.price) DESC;
--OR
SELECT TOP 5
    product_id,
    AVG(price) AS AVG_PRICE
FROM olist_order_items_dataset
GROUP BY product_id
ORDER BY AVG(price) DESC;

/* QUES 8 Which product categories generate both high revenue and high sales volume?*/
SELECT TOP 5 P.product_category_name ,COUNT(*) AS ITEMS_SOLD, SUM(O.price) AS TOTAL_REV
FROM olist_products_dataset AS P
INNER JOIN olist_order_items_dataset AS O
ON P.product_id=O.product_id 
GROUP BY P.product_category_name
ORDER BY TOTAL_REV DESC;

/* QUES 9 Find products that have been sold more than the average number of times.*/
SELECT product_id, TIME_SOLD
FROM (
    SELECT  P.product_id , COUNT(*) AS TIME_SOLD
    FROM olist_products_dataset AS P
    INNER JOIN olist_order_items_dataset AS O
    ON P.product_id=O.product_id 
    GROUP BY P.product_id
) AS T
WHERE TIME_SOLD > (
    SELECT AVG(TIME_SOLD) AS AVE_TIME_SOLD
    FROM  (
        SELECT  P.product_id , COUNT(*) AS TIME_SOLD
        FROM olist_products_dataset AS P
        INNER JOIN olist_order_items_dataset AS O
        ON P.product_id=O.product_id 
        GROUP BY P.product_id
    ) AS X
);
--OR USING CTE
WITH ProductSales AS
(
    SELECT
        product_id,
        COUNT(*) AS TIME_SOLD
    FROM olist_order_items_dataset
    GROUP BY product_id
)

SELECT *
FROM ProductSales
WHERE TIME_SOLD >
(
    SELECT AVG(TIME_SOLD)
    FROM ProductSales
);