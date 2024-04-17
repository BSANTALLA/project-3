-- Drop tables if they exist
DROP TABLE Car;
DROP TABLE Customer_Table;
DROP TABLE Dealer;

CREATE TABLE Car(
	Car_ID INT PRIMARY KEY NOT NULL,
	Date_Sold DATE NOT NULL,
	Company VARCHAR(40) NOT NULL,
	Model VARCHAR(40) NOT NULL,
	Engine VARCHAR(100) NOT NULL,
	Transmission VARCHAR(50) NOT NULL,
	Body_Style VARCHAR(25) NOT NULL,
	Color VARCHAR(40) NOT NULL,
	Price INT NOT NULL	
);

SELECT * from Car;

Create Table Customer(
	Customer_ID INT Primary KEY NOT NULL,
	Customer_Name VARCHAR(40),
	Gender VARCHAR(8) NOT NULL,
	Annual_Income INT NOT NULL,
	Phone_Number INT NOT NULL,
	FOREIGN KEY (Customer_ID) REFERENCES Car (Car_Id)
);

SELECT * from Customer;

Create Table Dealer(
	Sale_ID INT PRIMARY KEY NOT NULL,
	Dealer_Name VARCHAR(100) NOT NULL,
	Dealer_Region VARCHAR(50) NOT NULL,
	Dealer_Number VARCHAR(15) NOT NULL,
	FOREIGN KEY (Sale_ID) REFERENCES Car (Car_Id)
);

SELECT * from Dealer;

--Compre Average car price for people in varying income brackets
SELECT 
    ROUND(AVG(CASE WHEN Customer.annual_income < 50000 THEN Car.price ELSE NULL END),2) AS avg_income_less_than_50000,
    ROUND(AVG(CASE WHEN Customer.annual_income > 50000 AND Customer.annual_income < 150000 THEN Car.price ELSE NULL END),2) AS avg_income_50000_to_150000,
    ROUND(AVG(CASE WHEN Customer.annual_income > 150001 THEN Car.price ELSE NULL END),2) AS avg_income_greater_than_150001
FROM 
    Car
JOIN 
    Customer ON Car.car_id = Customer.customer_id;

-- Count the number of cars sold and their average value from each dealership
SELECT 
    Dealer_Name,
    COUNT(Car.car_id) AS num_cars_sold,
    ROUND(AVG(Car.price),2) AS avg_car_price
FROM 
    Car
JOIN 
    Dealer ON Car.Car_ID = Dealer.Sale_ID
GROUP BY 
    Dealer_Name
ORDER BY
	avg_car_price DESC;

-- Average price by engine 
SELECT 
    Engine,
    ROUND(AVG(price), 2) AS avg_price
FROM 
    Car
GROUP BY 
    engine;
	
-- Most popular make/model per income range
SELECT 
    income_range,
    COUNT(*) AS num_customers,
    CONCAT(MAX(company), ' ', MAX(model)) AS most_frequent_car
FROM (
    SELECT 
        CASE 
            WHEN annual_income < 50000 THEN '<50000' 
            WHEN annual_income > 50000 AND annual_income < 150000 THEN '>50000 and <150000' 
            WHEN annual_income > 150000 THEN '>150000' 
        END AS income_range,
        company,
        model
    FROM 
        Customer
    JOIN 
        Car ON Customer.customer_id = Car.car_id
) AS subquery
GROUP BY 
    income_range;


