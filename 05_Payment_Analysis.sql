/*===========================================================
                PAYMENT ANALYSIS
Brazilian Olist E-commerce Dataset

Table Used:
olist_order_payments_dataset

Author: Simple Dhillon
===========================================================*/

SELECT * FROM olist_order_payments_dataset;

/*	QUES 1 How many payment records are there in the olist_order_payments_dataset table*/ 
SELECT COUNT(*) AS TOTAL_RECORDS FROM olist_order_payments_dataset;

/* QUES 2 Which payment methods are available, and how many times was each payment method used*/
SELECT payment_type AS TYPE_PAYMENT , COUNT(*) AS TOTAL_TRANSACTIONS 
FROM olist_order_payments_dataset
GROUP BY payment_type;

/* QUES 3 Which payment method is the most popular?*/
SELECT TOP 1 payment_type AS TYPE_PAYMENT , COUNT(*) AS TOTAL_TRANSACTIONS 
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY TOTAL_TRANSACTIONS DESC;

SELECT SUM(payment_value) AS TOTAL_MONEY FROM olist_order_payments_dataset;

/* QUES 4 Which payment method generated the highest total revenue?*/
SELECT TOP 1 payment_type AS TYPE_PAYMENT , SUM(payment_value) AS SUM_TOTAL
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY SUM_TOTAL DESC;

/* QUES 5 Find payment types where the total revenue is greater than 1 million.*/
SELECT payment_type AS TYPE_PAYMENT , SUM(payment_value) AS SUM_TOTAL
FROM olist_order_payments_dataset
GROUP BY payment_type
HAVING SUM(payment_value) > 1000000;

/* QUES 6 Classify each payment transaction into categories based on payment amount*/
SELECT payment_value,
CASE WHEN payment_value < 50 THEN 'LOW'
	WHEN payment_value > =50 AND payment_value<200 THEN 'MEDIUM'
	WHEN payment_value >=200 THEN 'HIGH'
END
FROM olist_order_payments_dataset;

/* QUES 7 How many payment transactions are in each payment category?*/
SELECT 
CASE WHEN payment_value < 50 THEN 'LOW'
	WHEN payment_value >=50 AND payment_value<200 THEN 'MEDIUM'
	WHEN payment_value >=200 THEN 'HIGH'
END AS CATEGORY , COUNT(*)
FROM olist_order_payments_dataset
GROUP BY CASE WHEN payment_value < 50 THEN 'LOW'
	WHEN payment_value >=50 AND payment_value<200 THEN 'MEDIUM'
	WHEN payment_value >=200 THEN 'HIGH'
END ;

/* QUES 8 For each payment type, show:Number of transactions
Total revenue
Average payment
Highest payment
Lowest payment*/	
SELECT payment_type AS payment_type,
COUNT(*) AS TOTAL_TRANS,
SUM(payment_value) AS TOTAL_REV,
AVG(payment_value) AS AVG_PAYMENT,
MAX(payment_value) AS MAXIMUM ,
MIN(payment_value) AS MINIMUM
FROM olist_order_payments_dataset
GROUP BY payment_type;
