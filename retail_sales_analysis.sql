--SQL Retail Sales Analysis
--Create table 
CREATE TABLE retail_sales
          (
               transactions_id INT PRIMARY KEY,
               sale_date DATE,
               sale_time TIME,
               customer_id	INT,
               gender VARCHAR(15),
               age INT,
			   category	VARCHAR(15),
               quantiy INT,
			   price_per_unit FLOAT,	
               cogs	FLOAT,
               total_sale FLOAT
          );
SELECT * FROM retail_sales
LIMIT 20

SELECT COUNT(*) FROM retail_sales
-- data cleaing
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE customer_id IS NULL

SELECT * FROM retail_sales
WHERE gender IS NULL

SELECT * FROM retail_sales
WHERE 
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 customer_id IS NULL
	 OR
	 gender IS NULL
	 OR
     age IS NULL
	 OR
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR
	 price_per_unit IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL
-- replacing the null with avarage value
SELECT * FROM retail_sales
WHERE age IS NULL

SELECT age FROM retail_sales

SELECT ROUND(AVG(age)) FROM retail_sales

UPDATE retail_sales
SET age = (
    SELECT ROUND(AVG(age))::INT
    FROM retail_sales
)
WHERE age IS NULL;

SELECT * FROM retail_sales
WHERE age IS NULL

--
DELETE FROM retail_sales
WHERE 
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 customer_id IS NULL
	 OR
	 gender IS NULL
	 OR
     age IS NULL
	 OR
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR
	 price_per_unit IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL
--Data Exploration

--how many sales we have?
SELECT COUNT(*) as total_sales FROM retail_sales

--how many unique customres we have?
SELECT COUNT(DISTINCT customer_id) as total_sales FROM retail_sales

--how many unique category we have?
SELECT DISTINCT category as total_sales FROM retail_sales

--Data Analysis & Business key problems & answers

-- my analysis and findings
-- Q1 write sql query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2 write a sql query to retrieve all transactions where the category is 'clothing' and the quatity sold is more than 4 in the month of nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01'
  AND quantiy >= 4
  
-- Q3 write a sql query to calculate the total sales for each category
SELECT category, 
SUM(total_sale) AS net_sale, 
COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category

-- Q4 write a sql query to find the average age of customers who purchased items from the 'beauty' category
SELECT ROUND(AVG(age),2) AS Avg_age From retail_sales
WHERE category = 'Beauty'

-- Q5 write a sql query to find all transactions where the total_sales is greater then 1000
SELECT transactions_id FROM retail_sales
WHERE total_sale > 1000

-- Q6 write a sql query to find the totl number of transactios made by each gender in each category
SELECT 
	  category,
	  gender,
	  COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category,
         gender
ORDER BY category

-- Q7 write a sql query to calculate the average sale for each month find out best selling month in each year
SELECT year,
       month
FROM
(
SELECT 
       EXTRACT(year FROM sale_date) as year,
       EXTRACT(month FROM sale_date) as month, 
	   AVG(total_sale) as Avg_sale,
	   RANK() OVER(PARTITION BY EXTRACT(year FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1,2
) AS t1
where rank = 1


-- Q8 write a sql query to find the top 5 customers based on the highest total sales
SELECT 
       customer_id , SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5

-- Q9 write a sql query to find the number of unique customers who purchased items from ecah category

SELECT 
	  category ,
      COUNT(DISTINCT customer_id) AS count_unique_customers
FROM retail_sales
GROUP BY category
LIMIT 5

-- Q10 write a sql query to create ecah shift and number of orders( example mrng <= 12 , afternon btw 12 & 17, eveng >17)
WITH hourly_sales
AS 
(
SELECT * ,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'MORNING'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		ELSE 'EVENING'
	END AS shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift

-- end of project