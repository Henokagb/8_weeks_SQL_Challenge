--1 How many pizzas were ordered?

SELECT COUNT(pizza_id) 
FROM
	pizza_runner.customer_orders

--2 How many unique customer orders were made?

SELECT DISTINCT order_id 
FROM
	pizza_runner.customer_orders

--3 