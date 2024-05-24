-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT  product_id, product_name, COUNT(*) as "number of times purchased"

FROM
	dannys_diner.sales
FULL JOIN
	dannys_diner.menu
USING (product_id)

GROUP BY product_id, product_name

ORDER BY "number of times purchased" DESC

LIMIT 1