-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT customer_id, SUM(CASE WHEN product_id = 1 THEN price * 20 ELSE price * 10 END) as points
FROM
	dannys_diner.members
FULL JOIN
	dannys_diner.sales
 USING (customer_id)
 FULL JOIN
 	dannys_diner.menu
 USING (product_id)
 GROUP BY customer_id