create database restaurent

CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');

  CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);


INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');


  CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');



select * from sales
select * from menu
select * from members

--Q1 What is the total amount each customer spent at the restaurant?

select customer_id as Customer , sum(price) as Bill 
from sales s inner join menu m 
on s.product_id = m.product_id
group by customer_id

-- 2. How many days has each customer visited the restaurant?

select customer_id as customer , COUNT(order_date) 'days'
from sales group by customer_id

--3. What was the first item from the menu purchased by each customer?

select distinct customer_id, first_value(product_name) 
over(partition by customer_id order by customer_id ) as item
from sales s inner join menu m 
on s.product_id = m.product_id

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?


SELECT customer_id, menu.product_name, 
CASE 
	WHEN product_name = 'curry' THEN COUNT(product_name) 
	WHEN product_name = 'sushi' THEN COUNT(product_name) 
	WHEN product_name = 'ramen' THEN COUNT(product_name)
	ELSE 0 
END AS Food_counts 
FROM sales JOIN menu 
ON sales.product_id = menu.product_id 
GROUP BY customer_id, product_name
ORDER BY customer_id, food_counts DESC

-- 5. Which item was the most popular for each customer?

SELECT customer_id, menu.product_name, 
CASE 
	WHEN product_name = 'curry' THEN COUNT(product_name) 
	WHEN product_name = 'sushi' THEN COUNT(product_name) 
	WHEN product_name = 'ramen' THEN COUNT(product_name) 
	ELSE 0 
END AS Food_counts 
FROM sales JOIN menu ON sales.product_id = menu.product_id 
GROUP BY customer_id, product_name
ORDER BY customer_id, food_counts DESC

-- 6. Which item was purchased first by the customer after they became a member?
 

SELECT customer_id, FIRST_VALUE(product_name) 
OVER(PARTITION BY customer_id order by order_date) AS First_item_AfterJoin 
FROM sales JOIN menu ON sales.product_id = menu.product_id 
WHERE Order_date >= '2021-01-07' AND customer_id = 'A' OR order_date >= '2021-01-09' AND customer_id = 'B' 
GROUP BY customer_id, order_date, product_name

-- 7. Which item was purchased just before the customer became a member?

SELECT customer_id, FIRST_VALUE(product_name) 
OVER(PARTITION BY customer_id order by customer_id) AS First_item_JustBefore
FROM sales JOIN menu ON sales.product_id = menu.product_id 
WHERE Order_date < '2021-01-07' AND customer_id = 'A'
OR order_date < '2021-01-09' AND customer_id = 'B' 
GROUP BY customer_id, order_date, product_name

-- 8. What is the total items and amount spent for each member before they became a member?

SELECT sales.customer_id, COUNT(order_date) AS Items, SUM(price) AS Total
FROM sales JOIN menu ON sales.product_id = menu.product_id 
WHERE order_date < '2021-01-07' AND customer_id = 'A'
OR order_date < '2021-01-09' AND customer_id = 'B' 
GROUP BY customer_id




































