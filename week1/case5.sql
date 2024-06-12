-- 5. Which item was the most popular for each customer?

WITH times as (SELECT customer_id, product_id, product_name, COUNT(*) as purchase_count, ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY COUNT(*) DESC) as pc

                          FROM
                              dannys_diner.sales
                          FULL JOIN
                              dannys_diner.menu
                          USING (product_id)
                          GROUP BY customer_id, product_id, product_name
                          ORDER BY customer_id
              )
SELECT  customer_id, product_id, product_name, purchase_count

FROM
	times
WHERE
	pc = 1
