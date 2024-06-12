-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

SELECT customer_id, SUM(
  	CASE
  	WHEN (product_id = 1) OR order_date::date BETWEEN join_date::date AND (join_date::date + INTERVAL '6 days') THEN
  		price * 20
  	ELSE
  		price * 10
  	END
) AS points

FROM
	dannys_diner.members
FULL JOIN
    dannys_diner.sales
USING(customer_id)
FULL JOIN
	dannys_diner.menu
 USING(product_id)
 
 WHERE customer_id = 'A' OR customer_id = 'B'
 
 GROUP BY customer_id
 ORDER BY customer_id