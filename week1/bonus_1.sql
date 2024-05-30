--Join All The Things

SELECT customer_id,	order_date,	product_name, price,
				CASE
                WHEN
                	order_date >= join_date THEN 'Y'
                ELSE 'N'
                END AS member

FROM
	dannys_diner.members
FULL JOIN
	dannys_diner.sales
 USING (customer_id)
 FULL JOIN
 	dannys_diner.menu
 USING (product_id)
 
 ORDER BY customer_id, order_date