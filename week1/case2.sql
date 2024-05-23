-- 2. How many days has each customer visited the restaurant?
SELECT
    customer_id, COUNT(DISTINCT order_date)
 FROM
 	dannys_diner.sales FULL JOIN
    dannys_diner.members
 	USING(customer_id)
GROUP BY customer_id
ORDER BY customer_id