use bank_churn_analysis;

SELECT * FROM customer_churn;

-- Checking for duplicates

SELECT 
    customer_id, COUNT(*)
FROM
    customer_churn
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- CHECKING FOR UNIQUE CUSTOMER

CREATE VIEW distinct_customer_view AS
SELECT 
    COUNT(DISTINCT (customer_id)) AS distinct_customer
FROM
    customer_churn;


-- 1. Descriptive Analysis: Understanding Your Data

--	What is the overall churn rate (Customer_Status)?
CREATE VIEW Churn_rate AS
SELECT 
    ROUND(SUM(CASE
                WHEN customer_status = 'Attrited Customer' THEN 1
                ELSE 0
            END) / COUNT(*) * 100,
            2) AS Churn_rate
FROM
    customer_churn;


-- What is the distribution of customers by age group, gender, education level, and marital status?

-- Age Group--
SELECT 
    CASE
        WHEN Age BETWEEN 26 AND 35 THEN '26-35 yrs'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45 yrs'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55 yrs'
        WHEN Age BETWEEN 56 AND 65 THEN '56-65 yrs'
        WHEN AGE BETWEEN 66 AND 73 THEN '66-73 yrs'
        ELSE 'OTHER'
    END AS Age_Group,
    COUNT(Customer_id) AS Customer_Churned,
    ROUND(COUNT(customer_id)/sum(count(customer_id)) over(partition by customer_status)*100,2) as churn_Rate
FROM
    customer_churn
WHERE customer_status ="Attrited customer"
GROUP BY Age_Group
ORDER BY churn_Rate DESC;

SELECT * FROM age_group_churn_view;

-- Gender 

#CREATE VIEW Gender_wise_churn_view AS
SELECT gender, COUNT(customer_id) AS Customer_churned,
ROUND(COUNT(customer_id)/SUM(COUNT(customer_id)) OVER(Partition by customer_status)*100,2) as churn_percentage
FROM customer_churn
WHERE customer_status ="Attrited customer"
GROUP BY gender;

-- Education Level--
SELECT 
	Education, COUNT(customer_id) AS Customer_Churned,
	ROUND(COUNT(customer_id)/SUM(COUNT(customer_id)) OVER(Partition by customer_status)*100,2) as churn_rate
FROM 
	customer_churn
WHERE 
	customer_status ="Attrited customer"
GROUP BY Education
ORDER BY churn_rate DESC;

-- Marital Status 
SELECT 
	Marital_Status, COUNT(customer_id) AS Customer_Churned,
	ROUND(COUNT(customer_id)/SUM(COUNT(customer_id)) OVER(Partition by customer_status)*100,2) as churn_Rate
FROM 
	customer_churn
WHERE 
	customer_status ="Attrited customer"
GROUP BY Marital_Status;


-- What is the average credit limit and average revolving balance for churned vs. existing customers?


SELECT 
    customer_status,
    AVG(credit_limit) AS average_credit_limit,
    AVG(revolving_balance) AS avg_revolving_balance
FROM
    customer_churn
GROUP BY customer_status;


-- How does the number of inactive months (Inactive_Months) compare between churned and existing customers?

SELECT 
    customer_status,
    ROUND(AVG(inactive_months), 1) AS Avg_inactive_months
FROM
    customer_churn
GROUP BY customer_status;


-- Card Type --
SELECT 
	card_type,
	ROUND(COUNT(customer_id)/SUM(COUNT(customer_id)) OVER(PARTITION BY customer_status)*100,2) AS churn_rate
FROM 
	customer_churn
WHERE customer_status ="Attrited Customer"
GROUP BY card_type;

-- What is the average tenure (Tenure_Months) of churned customers compared to existing customers?

SELECT 
    customer_status AS customer_type,
    AVG(Tenure_Months) AS avg_customer_tenure
FROM
    customer_churn
GROUP BY customer_status;


-- Product Held--

SELECT 
	Product_Held,
	ROUND(COUNT(customer_id)/SUM(COUNT(customer_id)) OVER(PARTITION BY customer_status)*100,2) AS Churn_rate
FROM 
	customer_Churn
WHERE 
	customer_status ="Attrited Customer"
GROUP BY Product_Held
ORDER BY churn_rate DESC;

-- Annual Income --

SELECT DISTINCT 
	Annual_Income, COUNT(customer_id) as Total_customer,
	ROUND(COUNT(customer_id)/SUM(COUNT(customer_id)) OVER(PARTITION BY customer_status)*100,2) AS churn_rate
FROM 
	customer_churn
WHERE 
	customer_status ="Attrited Customer"
GROUP BY Annual_Income
ORDER BY churn_rate DESC;


-- Dependents --

SELECT 
     Dependents, COUNT(Customer_id) AS Customer_Churned,
     count(customer_id)/SUM(COUNT(customer_id)) OVER(PARTITION BY customer_status)*100 as churn_rate
FROM
    customer_churn
WHERE
    customer_status = 'Attrited Customer'
GROUP BY  Dependents
ORDER BY customer_churned DESC;

-- 2. Behavioral Analysis: Examining Customer Activities

-- Transaction Count --
SELECT 
	CASE 
		WHEN Transaction_count BETWEEN 10 AND 20 THEN "10-20"
		WHEN Transaction_count BETWEEN 21 AND 30 THEN "21-30"
		WHEN Transaction_count BETWEEN 31 AND 40 THEN "31-40"
		WHEN Transaction_count BETWEEN 41 AND 50 THEN "41-50"
		WHEN Transaction_count BETWEEN 51 AND 60 THEN "51-60"
		WHEN Transaction_count BETWEEN 61 AND 70 THEN "61-70"
		WHEN Transaction_count BETWEEN 71 AND 80 THEN "71-80"
		WHEN Transaction_count BETWEEN 81 AND 90 THEN "81-90"
		WHEN Transaction_count BETWEEN 91 AND 100 THEN "91-100" ELSE "OTHER" END AS Transactions_Range, 
        COUNT(customer_id) AS Customer_Churned,
		ROUND(COUNT(customer_id)/SUM(COUNT(customer_id)) OVER(PARTITION BY customer_status)*100,2) AS churn_rate
FROM customer_churn
WHERE customer_status ="Attrited customer"
GROUP BY Transactions_Range
ORDER BY churn_rate DESC
LIMIT 5;


-- Total Spend --

SELECT 
	CASE 
		WHEN Total_Spend <=2000 THEN "0-2000"
		WHEN Total_Spend <=4000 THEN "2001-4000"
		WHEN Total_Spend <=6000 THEN "4001-6000"
		WHEN Total_Spend <=8000 THEN "6001-8000"
		WHEN Total_Spend <=10000 THEN "8001-10000"
		WHEN Total_Spend <=12000 THEN "10001-12000"
		WHEN Total_Spend <=14000 THEN "12001-14000"
		WHEN Total_Spend <=16000 THEN "14001-16000"
		WHEN Total_Spend <=18000 THEN "16001-18000"
		WHEN Total_Spend <=20000 THEN "18001-20000" ELSE "OTHER" END AS Transactions_Range, 
        COUNT(customer_id) AS Customer_Churned,
		ROUND(COUNT(customer_id)/SUM(COUNT(customer_id)) OVER(PARTITION BY customer_status)*100,2) AS churn_rate
FROM 
	customer_churn
WHERE 
	customer_status ="Attrited customer"
GROUP BY Transactions_Range
ORDER BY churn_rate DESC;


-- Contact Frequency--

SELECT 
	Contact_Frequency, 
	ROUND(COUNT(customer_id)/SUM(COUNT(customer_id)) OVER(PARTITION BY Customer_Status)*100,2) AS Churn_Rate
FROM 
	customer_churn
WHERE 
	Customer_Status ="Attrited Customer"
GROUP BY Contact_Frequency
ORDER BY churn_rate DESC;

-- Credit Utilisation Ratio --

SELECT 
    credit_utilisation AS Credit_Utilisation_Ratio,
    COUNT(customer_id) AS customer_churned,
    ROUND(COUNT(customer_id)/SUM(COUNT(customer_id)) OVER(PARTITION BY customer_status)*100,2) AS churn_rate
FROM
    Customer_Churn
WHERE 
	customer_status ="Attrited customer"
GROUP BY Credit_Utilisation_Ratio
ORDER BY customer_churned DESC
LIMIT 5;


-- Transaction COUNT CHANGE IN Q4/Q1--

SELECT 
	Trans_Count_Change_Q4_Q1,
	COUNT(Customer_id) AS Customer_churned,
	ROUND(COUNT(customer_id)/SUM(COUNT(customer_id)) OVER(PARTITION BY customer_status)*100,2) AS churn_rate
FROM 
	Customer_churn
WHERE 
	customer_status ="Attrited Customer"
GROUP BY Trans_Count_Change_Q4_Q1
ORDER BY Customer_Churned DESC
LIMIT 5;


-- Inactive Months --

SELECT 
    Inactive_Months, COUNT(Customer_id) AS Customer_churned,
    ROUND(COUNT(customer_id)/SUM(COUNT(customer_id)) OVER(PARTITION BY customer_status)*100,2) AS churn_rate
FROM
    customer_churn
WHERE
    Customer_Status = 'Attrited Customer'
GROUP BY Inactive_Months
ORDER BY churn_rate DESC;

-- What is the average credit utilization ratio (Credit_Utilisation) for churned customers?

SELECT 
    ROUND(AVG(Credit_Utilisation), 2) AS Avg_Credit_Utilisation
FROM
    customer_churn
WHERE
    Customer_status = 'Attrited Customer';

-- How does average available credit (Available_Credit) compare between churned and existing customers?

SELECT 
    customer_status,
    AVG(Available_Credit) AS Avg_Available_Credit
FROM
    customer_churn
GROUP BY customer_Status;



-- WHERE CONDITION FOR OUR RISK MODEL
SELECT * FROM customer_churn 
WHERE age BETWEEN 36 AND 65
AND (Education = "High School" OR Education = "Graduate")
AND (marital_status = "Married" OR marital_status = "Single")
AND (annual_income = "Less than $40k" OR annual_income = "$40k - $60k")
AND (Dependents <= 4)
AND (Customer_status ="Existing Customer");



-- RISK MODEL CREATION 

SELECT 
	CASE WHEN Risk_Count >= 6 THEN "Critical Risk"
    WHEN Risk_Count = 5 THEN "High Risk"
    WHEN Risk_Count = 4 THEN "Moderate Risk"
    WHEN Risk_Count = 3 Then "Low Risk" ELSE "Minimal Risk" END AS Risk_Category,
    COUNT(customer_id) as Total_Customer_At_Risk,
    ROUND(COUNT(customer_id)/SUM(COUNT(customer_id)) OVER()*100,2) AS Percentage_of_Customer_At_Risk, Risk_Count
FROM (
		SELECT customer_id,
        AVG(revolving_balance) as Avg_Revolving_Balance,
			SUM(CASE WHEN Card_Type ="Blue" THEN 1 ELSE 0 END)+
			SUM(CASE WHEN Product_Held <3 THEN 1 ELSE 0 END)+
			SUM(CASE WHEN Credit_Utilisation = 0 THEN 1 ELSE 0 END)+
			SUM(CASE WHEN Contact_Frequency BETWEEN 2 AND 3 THEN 1 ELSE 0 END) +
            SUM(CASE WHEN Inactive_Months BETWEEN 2 AND 3 THEN 1 ELSE 0 END)+
			SUM(CASE WHEN Transaction_Count BETWEEN 30 AND 50 THEN 1 ELSE 0 END)+
            SUM(CASE WHEN Total_spend <=4000 THEN 1 ELSE 0 END)AS Risk_Count
        FROM customer_churn
        WHERE age BETWEEN 36 AND 65
			AND (Education = "High School" OR Education = "Graduate")
			AND (marital_status = "Married" OR marital_status = "Single")
			AND (annual_income = "Less than $40k" OR annual_income = "$40k - $60k")
			AND (Dependents <= 4)
			AND (Customer_status ="Existing Customer")
GROUP BY 
			customer_id
HAVING
			Risk_Count >= 1 AND 
			Avg_Revolving_balance <=700
) AS subquery
GROUP BY Risk_Count, Risk_Category
ORDER BY Risk_Count DESC;

	
