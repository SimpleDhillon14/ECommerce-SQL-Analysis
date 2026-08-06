/*===========================================================
				CREATING A NEW DATABASE

Author: Simple Dhillon
===========================================================*/
CREATE DATABASE ECOMMERCE_BUSINESS;
USE ECOMMERCE_BUSINESS;
CREATE TABLE ORDERS(
	order_id  VARCHAR(50) PRIMARY KEY,
	customer_id VARCHAR(50) NOT NULL,
	order_status VARCHAR(50) NOT NULL,
	order_purchase_timestamp DATETIME NOT NULL ,
	order_approved_at DATETIME NULL,
	order_delivered_carrier_date DATETIME NULL,
	order_delivered_customer_date DATETIME NULL,
	order_estimated_delivery_date DATETIME NOT NULL
)

/*===========================================================
                ORDER ANALYSIS
Brazilian Olist E-commerce Dataset

Table Used:
olist_order_dataset

Author: Simple Dhillon
===========================================================*/
SELECT * FROM olist_orders_dataset;
SELECT COUNT(*) FROM olist_orders_dataset
WHERE order_status != 'delivered';
SELECT order_status,COUNT(*) AS COUNTI FROM olist_orders_dataset
GROUP BY order_status
ORDER BY COUNTI DESC;

SELECT DISTINCT YEAR(order_purchase_timestamp) 
FROM olist_orders_dataset;

SELECT YEAR(order_purchase_timestamp) AS YEAR_NO, COUNT(*) AS TOTAL_ORDERS
FROM olist_orders_dataset
WHERE order_status = 'delivered'
GROUP BY YEAR(order_purchase_timestamp);

SELECT YEAR(order_purchase_timestamp) AS YEAR_NO, COUNT(*) AS TOTAL_ORDERS
FROM olist_orders_dataset
WHERE order_status = 'canceled'
GROUP BY YEAR(order_purchase_timestamp);


SELECT TOP 1 YEAR(order_purchase_timestamp) AS YEAR_NO, COUNT(*) AS TOTAL_ORDERS
FROM olist_orders_dataset
WHERE order_status = 'canceled'
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY  TOTAL_ORDERS DESC;

SELECT MIN(order_purchase_timestamp) 
FROM olist_orders_dataset;

SELECT MAX(order_purchase_timestamp) 
FROM olist_orders_dataset;



