--Clean pickup time
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

--Clean distance
UPDATE pizza_runner.runner_orders
SET distance =  SUBSTRING(distance FROM 1 FOR LENGTH(distance) - 2)
WHERE distance LIKE '%km';

--Clean duration
UPDATE pizza_runner.runner_orders
SET duration =  SUBSTRING(duration FROM 1 FOR LENGTH(duration) - 7)
WHERE duration LIKE '%minutes' OR duration LIKE '%minute';

UPDATE pizza_runner.runner_orders
SET duration =  SUBSTRING(duration FROM 1 FOR LENGTH(duration) - 4)
WHERE duration LIKE '%mins';


--1 How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT  EXTRACT(WEEK FROM registration_date + 3) AS week, COUNT(*)
FROM pizza_runner.runners
GROUP BY week
ORDER BY week

--2 What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT runner_id, AVG(TO_TIMESTAMP(pickup_time, 'YYYY-MM-DD HH24:MI:SS') - order_time) AS "average pickup_time"
FROM
	pizza_runner.customer_orders
FULL JOIN
    pizza_runner.runner_orders
USING (order_id)
WHERE cancellation IS NULL
GROUP BY runner_id


--4 What was the average distance travelled for each customer?

SELECT customer_id, AVG(CAST(distance AS NUMERIC))
FROM
pizza_runner.customer_orders
FULL JOIN
pizza_runner.runner_orders
USING (order_id)
WHERE cancellation IS NULL
GROUP BY customer_id


--5 What was the difference between the longest and shortest delivery times for all orders?

SELECT MAX(CAST(duration AS NUMERIC)) - MIN(CAST(duration AS NUMERIC)) AS diff
FROM  pizza_runner.runner_orders