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

--Deal with distance values
UPDATE pizza_runner.runner_orders
SET distance =  CAST (SUBSTRING(distance FROM 1 FOR LENGTH(distance) - 2) AS NUMERIC)
WHERE SUBSTRING(distance FROM LENGTH(distance) - 1 FOR LENGTH(distance)) = 'km';


--1 How many pizzas were ordered?

SELECT COUNT(pizza_id) 
FROM
	pizza_runner.customer_orders

--2 How many unique customer orders were made?

SELECT COUNT (DISTINCT order_id) 
FROM
	pizza_runner.customer_orders

--3 How many successful orders were delivered by each runner?

SELECT runner_id, COUNT(*)
FROM
	pizza_runner.runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id

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

--5 How many Vegetarian and Meatlovers were ordered by each customer?

SELECT customer_id, pizza_name, COUNT(pizza_name)
FROM
	pizza_runner.customer_orders
FULL JOIN
    pizza_runner.runner_orders
USING (order_id)
FULL JOIN
	pizza_runner.pizza_names
USING (pizza_id)
WHERE cancellation IS NULL
GROUP BY customer_id, pizza_name
ORDER BY customer_id

--6 What was the maximum number of pizzas delivered in a single order?

SELECT order_id, COUNT(*)
FROM
	pizza_runner.customer_orders
FULL JOIN
    pizza_runner.runner_orders
USING (order_id)
WHERE cancellation IS NULL
GROUP BY order_id
ORDER BY count DESC
LIMIT 1

--7 For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT customer_id, COUNT(*) AS "number of pizzas changed"
FROM
	pizza_runner.customer_orders
FULL JOIN
    pizza_runner.runner_orders
USING (order_id)
WHERE cancellation IS NULL AND (exclusions IS NOT NULL OR extras IS NOT NULL)
GROUP BY customer_id

--8 How many pizzas were delivered that had both exclusions and extras?

SELECT COUNT(*) AS "number of pizzas with both exclusions and extras"
FROM
	pizza_runner.customer_orders
FULL JOIN
    pizza_runner.runner_orders
USING (order_id)
WHERE cancellation IS NULL AND (exclusions IS NOT NULL AND extras IS NOT NULL)
GROUP BY customer_id

--9 What was the total volume of pizzas ordered for each hour of the day?

SELECT EXTRACT(HOUR FROM order_time) AS hour, COUNT(*) AS "number of pizzas per hour"
FROM
	pizza_runner.customer_orders
 GROUP BY hour
 ORDER BY hour

--10 What was the volume of orders for each day of the week?

SELECT EXTRACT(DAY FROM order_time) AS day, COUNT(*) AS "number of pizzas per day"
FROM
	pizza_runner.customer_orders
 GROUP BY day
 ORDER BY day
 
