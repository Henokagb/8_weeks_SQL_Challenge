--Deal with null, NaN and empty values
UPDATE pizza_runner.customer_orders
SET exclusions = NULL
WHERE exclusions = 'null' OR exclusions = '' OR exclusions = 'NaN';

UPDATE  pizza_runner.customer_orders
SET extras = NULL
WHERE extras = 'null' OR extras = '' OR extras = 'NaN';

UPDATE pizza_runner.runner_orders
SET pickup_time = NULL
WHERE pickup_time = 'null' OR pickup_time = '' OR pickup_time = 'NaN';

UPDATE  pizza_runner.runner_orders
SET distance = NULL
WHERE distance = 'null' OR distance = '' OR distance = 'NaN';

UPDATE  pizza_runner.runner_orders
SET duration = NULL
WHERE duration = 'null' OR duration = '' OR duration = 'NaN';

UPDATE  pizza_runner.runner_orders
SET cancellation = NULL
WHERE cancellation = 'null' OR cancellation = '' OR cancellation = 'NaN';

--1 How many pizzas were ordered?

SELECT COUNT(pizza_id) 
FROM
	pizza_runner.customer_orders

--2 How many unique customer orders were made?

SELECT DISTINCT order_id 
FROM
	pizza_runner.customer_orders

--3 How many successful orders were delivered by each runner?

SELECT COUNT(*)
FROM
	pizza_runner.runner_orders
WHERE cancellation IS NULL

--4 How many of each type of pizza was delivered?

SELECT pizza_name, COUNT(pizza_name)
FROM
	pizza_runner.customer_orders
FULL JOIN
    pizza_runner.runner_orders
USING (order_id)
FULL JOIN
	pizza_runner.pizza_names
USING (pizza_id)
WHERE cancellation IS NULL
GROUP by pizza_name