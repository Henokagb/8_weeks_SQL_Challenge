-- 7. Which item was purchased just before the customer became a member?

WITH pre_info as (
                        SELECT
                            customer_id, product_id, product_name, order_date, join_date, join_date::date - order_date::date as purchase_days_before_join, ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY  order_date::date - join_date::date DESC)
                         FROM
                            dannys_diner.members
                          FULL JOIN
                            dannys_diner.sales
                          USING (customer_id)
                          FULL JOIN
                            dannys_diner.menu
                          USING (product_id)
                          GROUP BY  customer_id, product_id, product_name, join_date, order_date
 						  HAVING join_date::date - order_date::date > 0
                          ORDER BY customer_id
)

SELECT customer_id, product_id, product_name, order_date,  join_date,  purchase_days_before_join
FROM pre_info
WHERE row_number = 1