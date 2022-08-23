CREATE DATABASE IF NOT EXISTS `new-order-directory`;
USE `new-order-directory`;
USE `order-directory`;

-- 3) Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.
SELECT COUNT(customerDetails.CUST_ID) AS No_of_Customer,customerDetails.CUST_GENDER 
FROM customer AS customerDetails  
INNER JOIN (
SELECT orderDetails.ORD_Amount, orderDetails.CUST_ID 
FROM `order` AS orderDetails 
WHERE orderDetails.ORD_AMOUNT >= 3000 GROUP BY orderDetails.CUST_ID) AS  orderDetailsAtLeast
 ON customerDetails.CUST_ID = orderDetailsAtLeast.CUST_ID GROUP BY customerDetails.CUST_GENDER;
-----------------------------------------------------------------------------------------------------

-- 4)Display all the orders along with product name ordered by a customer having Customer_Id=2
SELECT pro.PROD_NAME, ord.*
FROM `order` ord 
JOIN supplier_pricing supp
ON supp.PRICING_ID = ord.PRICING_ID
JOIN product pro
ON pro.PROD_ID = supp.PROD_ID WHERE ord.CUST_ID = 2;

-----------------------------------------------------------------------------------------------------------

-- 5)Display the Supplier details who can supply more than one product.
SELECT SUPP_ID 
FROM supplier_pricing GROUP BY SUPP_ID 
HAVING count(SUPP_ID) > 1;

SELECT * FROM supplier WHERE SUPP_ID in (
SELECT SUPP_ID 
FROM supplier_pricing GROUP BY SUPP_ID 
HAVING count(SUPP_ID) > 1);

-- SELECT SUPP_ID, count(PROD_ID) FROM supplier_pricing GROUP BY SUPP_ID;

------------------------------------------------------------------------------------------------------

-- 6)Find the least expensive product from each category and 
-- print the table with category id, name, product name and price of the product
SELECT ca.CATE_ID, ca.CATE_NAME, pd.PROD_NAME, MIN(sp.SUPP_PRICE) as'PRICE'
FROM category ca
JOIN product pd
ON ca.CATE_ID = pd.CATE_ID
JOIN supplier_pricing sp
ON sp.PROD_ID = pd.PROD_ID GROUP BY ca.CATE_ID;

---------------------------------------------------------------------------------------------------------------

-- 7)Display the Id and Name of the Product ordered after “2021-10-05”.
SELECT pp.PROD_ID, PROD_NAME, ORD_DATE
FROM product AS pro
INNER JOIN (
SELECT sp.PROD_ID, od.ORD_DATE 
FROM supplier_pricing AS sp 
INNER JOIN `order` AS od 
ON sp.PRICING_ID = od.PRICING_ID)pp 
ON pro.PROD_ID = pp.PROD_ID where ORD_DATE > '2021-10-05';

----------------------------------------------------------------------------------------------------------

-- 8)Display customer name and gender whose names start or end with character 'A'.

SELECT CUST_NAME, CUST_GENDER from customer where CUST_NAME like 'A%' or CUST_NAME like '%A';
-- SELECT CUST_NAME, CUST_GENDER from customer where CUST_NAME like '%A%'

----------------------------------------------------------------------------------------------------------

-- 9)Create a stored procedure to display supplier id, name, rating and Type_of_Service. 
-- For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.
SELECT SUPP_ID, SUPP_NAME, Sum_Of_Rating/Count_of_Rating AS rating,
case when rating = 5 then 'Excellent Service'
when rating = 4 then 'Good Service'
when rating >= 4 then 'Average Service'
else 'Poor Service'
end AS Type_of_Service FROM SELECT(sp.supp_id SUPP_ID, supp_name SUPP_NAME, RAT_RATSTARTS rating, sum(RAT_RATSTARTS) Sum_of_Rating, count(RAT_RATSTARTS) Count_of_rating 
FROM supplier s 
INNER JOIN supplier_pricing sp
on s.SUPP_ID=sp.SUPP 
INNER JOIN `order` ord on sp.PRICING_ID=ord.PRICING_ID
INNER JOIN rating r ON ord.ORD_ID = r.ORD_ID group by sp.SUPP_ID) a;
;

SELECT sp.SUPP_ID, SUPP_NAME, RAT_RATSTARS, sum(RAT_RATSTARS), count(RAT_RATSTARS), avg(RAT_RATSTARS)
FROM supplier s 
INNER JOIN supplier_pricing sp
ON s.supp_id = sp.supp_id
INNER JOIN `order` ord on sp.PRICING_ID=ord.PRICING_ID
INNER JOIN rating r 
ON ord.ORD_ID = r.ORD_ID GROUP BY SUPP_ID;







 
 
 


