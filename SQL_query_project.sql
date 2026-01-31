CREATE TABLE retail_sales(
                transactions_id	INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age	INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			    );
	SELECT * from retail_sales;
	SELECT COUNT(*)FROM retail_sales;

---/* DATA CLEANING*/---

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
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

	ALTER TABLE retail_sales
	RENAME COLUMN quantiy to quantity;

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
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

---/* DATA EXPLORATION*/---
-- How many sales do we have---
SELECT COUNT(*)as total_sales from retail_sales;

-- How many unique customers do we have--
SELECT COUNT(DISTINCT customer_id)as customers from retail_sales;

-- Number od categories we have--
SELECT COUNT(DISTINCT category)as categories from retail_sales; 


---/* DATA ANALYSIS AND BUSINESS KEY PROBLEMS AND ANSWERS */---

--Q1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales 
WHERE sale_date='2022-11-05';

--Q2.Write a SQL query to retrieve all transactions where the cayegory is 'clothing'
--and the quantity sold is more than 4 in the month of Nov-2022
SELECT * FROM retail_sales 
WHERE 
category='Clothing'
AND
TO_CHAR(sale_date,'YYYY-MM')='2022-11'
AND 
quantity>=4;

--Q3. Write an SQL query to calculate total sales for each category
SELECT 
	category,
	SUM(total_sale)as net_sale,
	COUNT(*)as total_orders
	FROM retail_sales
	GROUP BY 1;
	
--Q4. Write a SQL query to find the average age of the customers who purchased items from the 'Beauty'category
SELECT
ROUND(AVG(age),2)as avg_age
FROM retail_sales
WHERE category ='Beauty'

--Q5. Write a SQL query to find out all the transactions where the total_sale is greater than 1000
SELECT * FROM retail_sales
WHERE total_sale>1000

--Q6. Write a SQL query to find the total number of transactions (transactions_id) made by each gender in each category
SELECT 
	category,
	gender,
	COUNT(*) as total_trans
	FROM retail_sales
GROUP
    BY
	  category,
	  gender
ORDER BY 1;

--Q7. Write a SQL query to calculate the average sale for each month.Find out best selling month in each year.
SELECT 
	year,
	month,
	avg_sale
FROM
(
SELECT
	EXTRACT(YEAR FROM sale_date)as year,
	EXTRACT(MONTH FROM sale_date)as month,
	AVG(total_sale) as avg_sale,
	RANK()OVER(
	PARTITION BY EXTRACT(YEAR FROM sale_date)
	ORDER BY AVG(total_sale)DESC)as rank
FROM retail_sales
GROUP BY 1,2
)as t1
WHERE rank=1

--Q8. Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
	customer_id,
	SUM(total_sale)as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q9. Write a SQL query to create ach shift and number of orders(Example Morning<=12,After
--between 12 & 17, evening> 17)
WITH hourly_sale
AS(
SELECT*,
CASE
	WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time)BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE'Evening'
	END as shift
	FROM retail_sales
	)
	SELECT 
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift

--Q10. Write a SQL query to find the number of unique customers who purchased item from each category
SELECT
	category,
	COUNT(DISTINCT customer_id)as count_unique_cs
	FROM retail_sales
	GROUP BY category

--------------------------- END OF PROJECT-----------------------------------------