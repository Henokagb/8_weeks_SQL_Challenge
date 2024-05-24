-- 8. What is the total items and amount spent for each member before they became a member?

WITH pre_info as (
                        SELECT
                            customer_id, product_id, price
                         FROM
                            dannys_diner.members
                          FULL JOIN
                            dannys_diner.sales
                          USING (customer_id)
                          FULL JOIN
                            dannys_diner.menu
                          USING (product_id)
                          GROUP BY  customer_id, product_id, price, join_date, order_date
 						  HAVING join_date::date - order_date::date > 0
                          ORDER BY customer_id
)

SELECT customer_id, COUNT(product_id), SUM(price)
FROM pre_info
GROUP BY customer_id