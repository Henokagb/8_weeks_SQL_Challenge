-- 1. What is the total amount each customer spent at the restaurant?

SELECT
    customer_id, SUM(price)
 FROM
 	dannys_diner.sales FULL JOIN
    dannys_diner.members
 	USING(customer_id)
 	FULL JOIN
    dannys_diner.menu
 	USING(product_id)
GROUP BY customer_id
ORDER BY customer_id