CREATE PROCEDURE `Question_9` ()
BEGIN

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
END