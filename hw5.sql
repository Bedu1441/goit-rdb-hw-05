USE goit_rdb_hw_03;

-- 1. SELECT з вкладеним запитом у SELECT

SELECT
    od.*,
    (
        SELECT o.customer_id
        FROM orders AS o
        WHERE o.id = od.order_id
    ) AS customer_id
FROM order_details AS od;

-- 2. SELECT з вкладеним запитом у WHERE (shipper_id = 3)

SELECT
    od.*
FROM order_details AS od
WHERE od.order_id IN (
    SELECT o.id
    FROM orders AS o
    WHERE o.shipper_id = 3
);

-- 3. Підзапит у FROM: quantity > 10 + AVG(quantity) група за order_id

SELECT
    t.order_id,
    AVG(t.quantity) AS avg_quantity
FROM (
    SELECT
        order_id,
        quantity
    FROM order_details
    WHERE quantity > 10
) AS t
GROUP BY t.order_id;

-- 4. Те саме через WITH (CTE temp)

WITH temp AS (
    SELECT
        order_id,
        quantity
    FROM order_details
    WHERE quantity > 10
)
SELECT
    order_id,
    AVG(quantity) AS avg_quantity
FROM temp
GROUP BY order_id;

-- 5. Функція divide_float + застосування

DROP FUNCTION IF EXISTS divide_float;

DELIMITER //

CREATE FUNCTION divide_float(
    p_value   FLOAT,
    p_divisor FLOAT
)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    IF p_divisor = 0 THEN
        RETURN NULL;
    END IF;

    RETURN p_value / p_divisor;
END //

DELIMITER ;

-- Використання функції до quantity - 2

SELECT
    od.order_id,
    od.product_id,
    od.quantity,
    divide_float(od.quantity, 2.0) AS quantity_divided
FROM order_details AS od;
