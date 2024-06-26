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


--1 What are the standard ingredients for each pizza?

WITH pizza_toppings AS 
	(
    SELECT pizza_id, UNNEST(string_to_array) AS topping
	  FROM (
			SELECT pizza_id, string_to_array(toppings, ',')::int[]
			FROM pizza_runner.pizza_recipes
  			) AS arrayed
        )

SELECT topping, COUNT(pizza_id)
FROM pizza_toppings
GROUP BY topping
HAVING COUNT(pizza_id) = (
  							SELECT COUNT(DISTINCT(pizza_id))
  							FROM pizza_runner.pizza_recipes
						 )

--2 What was the most commonly added extra?
WITH extra_added AS
(
SELECT UNNEST(string_to_array) AS extra_id
FROM (
			SELECT string_to_array(extras, ',')::int[]
			FROM pizza_runner.customer_orders
			WHERE extras IS NOT NULL
  			) AS extra
  )
  
  SELECT pt.topping_name, extra_id, COUNT(extra_id)
  FROM extra_added, pizza_runner.pizza_toppings AS pt
  WHERE pt.topping_id = extra_id
  GROUP BY extra_id, pt.topping_name
  ORDER BY count DESC
  LIMIT 1

--3 What was the most common exclusion?
WITH exclu_added AS
(
SELECT UNNEST(string_to_array) AS exclu_id
FROM (
			SELECT string_to_array(exclusions, ',')::int[]
			FROM pizza_runner.customer_orders
			WHERE exclusions IS NOT NULL
  			) AS exclu
  )

  SELECT pt.topping_name, exclu_id, COUNT(exclu_id)
  FROM exclu_added, pizza_runner.pizza_toppings AS pt
  WHERE pt.topping_id = exclu_id
  GROUP BY exclu_id, pt.topping_name
  ORDER BY count DESC
  LIMIT 1

--4 Generate an order item for each record in the customers_orders table in the format of one of the following:
/*
Meat Lovers
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
*/

WITH
new_arrayed AS (
SELECT order_id, pizza_id, string_to_array(exclusions, ',')::int[] AS exclusion, 					string_to_array(extras, ',')::int[] AS extra
 FROM pizza_runner.customer_orders
 ORDER BY order_id
  ),
  
 unarrayed AS (
    SELECT order_id, pizza_id, UNNEST(exclusion) AS exclusion, UNNEST(extra) AS extra
    FROM new_arrayed
    	UNION ALL
    SELECT  order_id, pizza_id, exclusions::INTEGER, extras::INTEGER
    FROM pizza_runner.customer_orders
    WHERE exclusions IS NULL AND extras IS NULL
     
  ),

pre_items AS (
	SELECT order_id,
 				(
                  SELECT pizza_name FROM pizza_runner.pizza_names WHERE pizza_id = unarrayed.pizza_id
                ),
 				(
                SELECT topping_name AS exclusion FROM pizza_runner.pizza_toppings WHERE topping_id = unarrayed.exclusion
                 ),      
				(
                SELECT topping_name AS extra FROM pizza_runner.pizza_toppings WHERE topping_id = unarrayed.extra
                 )
 	FROM unarrayed
)

SELECT order_id, pizza_name, ' - Exclude' || ' '||  string_agg(exclusion, ', ') AS exclusion, ' - Extra' || ' '|| string_agg(extra, ', ') AS extra
FROM pre_items 
GROUP BY order_id, pizza_name