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

-- UNNEST toppings
ALTER TABLE pizza_runner.pizza_recipes
ALTER COLUMN toppings TYPE int[]
USING string_to_array(toppings, ',')::int[];


--1 What are the standard ingredients for each pizza?

WITH pizza_toppings AS
	(SELECT pizza_id, UNNEST(toppings) AS topping
	FROM pizza_runner.pizza_recipes)

SELECT topping_name
FROM pizza_runner.pizza_toppings
WHERE topping_id IN

(SELECT topping
FROM pizza_toppings
GROUP BY topping
HAVING COUNT(pizza_id) = (SELECT COUNT(DISTINCT(pizza_id)) FROM pizza_toppings))

