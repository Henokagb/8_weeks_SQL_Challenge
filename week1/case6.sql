-- 6. Which item was purchased first by the customer after they became a member?

WITH pre_info as (
                        SELECT
                            customer_id, product_id, product_name, join_date, order_date, order_date::date - join_date::date as days_before_first_purchase, ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY  order_date::date - join_date::date)
                         FROM
                            dannys_diner.members
                          FULL JOIN
                            dannys_diner.sales
                          USING (customer_id)
                          FULL JOIN
                            dannys_diner.menu
                          USING (product_id)
                          GROUP BY  customer_id, product_id, product_name, join_date, order_date
 						  HAVING order_date::date - join_date::date >= 0
                          ORDER BY customer_id
)

SELECT customer_id, product_id, product_name, join_date, order_date, days_before_first_purchase
FROM pre_info
WHERE row_number = 1