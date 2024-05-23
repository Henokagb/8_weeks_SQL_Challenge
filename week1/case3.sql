-- 3. What was the first item from the menu purchased by each customer?
WITH ranked as (SELECT
                            customer_id, order_date, product_name ,ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) as times
                            FROM
                            dannys_diner.sales FULL JOIN
                            dannys_diner.members
                            USING(customer_id)
                            FULL JOIN
                            dannys_diner.menu
                            USING(product_id)
 )
 SELECT customer_id, order_date, product_name
 
 FROM ranked
 
 WHERE times = 1