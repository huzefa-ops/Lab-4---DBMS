create schema orderlist;

use orderlist;

create table if not exists supplier(
supp_id int primary key , 
supp_name varchar(50) not null , 
supp_city varchar(50) not null , 
supp_phone varchar(50) not null
);

create table if not exists customer(
cus_id int primary key , 
cus_name varchar(20) not null, 
cus_phone varchar(10) not null, 
cus_city varchar(30) not null, 
cus_gender character 
);

create table if not exists category(
cat_id int primary key, 
cat_name varchar(20) not null
);

create table if not exists product(
pro_id int primary key, 
pro_name varchar(20) not null default "Dummy" , 
pro_desc varchar(60),  
cat_id int not null,
foreign key(cat_id) REFERENCES category(cat_id)
);


create table if not exists supplier_pricing(
pricing_id int primary key,
pro_id int not null,
foreign key(pro_id) references product(pro_id),
supp_id int not null,
foreign key(supp_id) references supplier(supp_id),
supp_price int default'0'
);

create table if not exists orders(
ord_id int primary key,
ord_amount int not null,
ord_date date not null,
cus_id int not null,
foreign key(cus_id) references customer(cus_id),
pricing_id int not null,
foreign key(pricing_id) references supplier_pricing(pricing_id)
);


create table if not exists ratings(
rat_id int primary key,
ord_id int not null,
foreign key(ord_id) references orders(ord_id),
rat_ratstars int not null
);

insert into supplier values('1','Rajesh Retails','Delhi','1234567890');
insert into supplier values('2','Appario Ltd.','Mumbai','2589631470');
insert into supplier values('3','Knome products','Banglore','9785462315');
insert into supplier values('4','Bansal Retails','Kochi','8975463285');
insert into supplier values('5','Mittal Ltd.','Lucknow','7898456532');

insert into customer values('1','AAKASH','9999999999','DELHI','M');
insert into customer values('2','AMAN','9785463215','NOIDA','M');
insert into customer values('3','NEHA','9999999999','MUMBAI','F');
insert into customer values('4','MEGHA','9994562399','KOLKATA','F');
insert into customer values('5','PULKIT','7895999999','LUCKNOW','M');

insert into category values('1','books');
insert into category values('2','games');
insert into category values('3','grocery');
insert into category values('4','electronics');
insert into category values('5','clothes');

insert into product(pro_id,pro_name,pro_desc,cat_id) values
('1','GTA V','Windows 7 and above with i5 processor and 8GB RAM','2'),
('2','TSHIRT','SIZE-L with Black, Blue and White variations','5'),
('3','ROG LAPTOP','Windows 10 with 15inch screen, i7 processor, 1TB SSD','4'),
('4','OATS','Highly Nutritious from Nestle','3'),
('5','HARRY POTTER','Best Collection of all time by J.K Rowling','1'),
('6','MILK','1L Toned MIlk','3'),
('7','Boat Earphones','1.5Meter long Dolby Atmos','4'),
('8','Jeans','Stretchable Denim Jeans with various sizes and color','5'),
('9','Project IGI','compatible with windows 7 and above','2'),
('10','Hoodie','Black GUCCI for 13 yrs and above','5'),
('11','Rich Dad Poor Dad','Written by RObert Kiyosaki','1'),
('12','Train Your Brain','By Shireen Stephen','1');

 insert into supplier_pricing(pricing_id,pro_id,supp_id,supp_price) values
 (1,1,2,1500),
(2,3,5,30000),
(3,5,1,3000),
(4,2,3,2500),
(5,4,1,1000);

insert into orders(ord_id,ord_amount,ord_date,cus_id,pricing_id) values 
(105,3000,'2021-08-16',4,3),
(106,1450,'2021-08-18',1,4),
(107,789,'2021-09-01',3,5),
(108,780,'2021-09-07',5,3),
(109,3000,'2021-00-10',5,3),
(110,2500,'2021-09-10',2,4),
(111,1000,'2021-09-15',4,5),
(112,789,'2021-09-16',4,3),
(113,31000,'2021-09-16',1,4),
(114,1000,'2021-09-16',3,5),
(115,3000,'2021-09-16',5,3),
(116,99,'2021-09-17',2,4);

insert into ratings(rat_id,ord_id,rat_ratstars) values 
(1,101,4),
(2,102,3),
(3,103,1),
(4,104,2),
(5,105,4),
(6,106,3),
(7,107,4),
(8,108,4),
(9,109,3),
(10,110,5),
(11,111,3),
(12,112,4),
(13,113,2),
(14,114,1),
(15,115,1),
(16,116,0);

-- Write queries for the following:

-- 3)	Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.
-- 4)	Display all the orders along with the product name ordered by a customer having Customer_Id=2.
-- 5)	Display the Supplier details who can supply more than one product.
-- 6)	Find the category of the product whose order amount is minimum.
-- 7)	Display the Id and Name of the Product ordered after “2021-10-05”.
-- 8)	Display customer name and gender whose names start or end with character 'A'.
-- 9)	 Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.

-- Answer 3 
select * from `order` where ord_amount >= 3000;

-- INNER JOIN between order and customer table
select cus_gender, count(*)
from orders  inner join customer on orders.cus_id = customer.cus_id 
where ord_amount >= 3000 group by customer.cus_gender;

-- Display all the orders along with the product name ordered by a customer having Customer_Id=2.
-- Join 3 tables order table product and product details

select product.pro_name, orders.* from orders, supplier_pricing, product
where orders.cus_id=2 and
orders.pricing_id=supplier_pricing.pricing_id and supplier_pricing.pro_id=product.pro_id;

-- 5 Display the Supplier details who can supply more than one product.

-- Find out supplier ids of the supplier supplying more than one product

select supplier.* from supplier where supplier.supp_id in
(select supp_id from supplier_pricing group by supp_id having
count(supp_id)>1)
group by supplier.supp_id;


-- 6)	Find the least expensive product from each category and print the table with category id, name, product name and price of the product

-- order, product, category

select category.cat_id,category.cat_name, min(t3.min_price) as Min_Price from category inner join
(select product.cat_id, product.pro_name, t2.* from product inner join
(select pro_id, min(supp_price) as Min_Price from supplier_pricing group by pro_id)
as t2 where t2.pro_id = product.pro_id)
as t3 where t3.cat_id = category.cat_id group by t3.cat_id;

-- 7)	Display the Id and Name of the Product ordered after “2021-10-05”.
-- order , product details, product

select product.pro_id,product.pro_name from orders
inner join supplier_pricing on supplier_pricing.pricing_id=orders.pricing_id 
inner join product on product.pro_id=supplier_pricing.pro_id 
where orders.ord_date>"2021-10-05";


-- 8 Display customer name and gender whose names start or end with character 'A'.

-- HINT: like 'A%'

select cus_name, cus_gender from customer where customer.cus_name like 'A%' or customer.cus_name like '%A';

-- 9)	Create a stored procedure to display supplier id, name, rating and Type_of_Service. 
-- For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.


Create definer='root'@'localhost' PROCEDURE 'Rating_report'()

BEGIN
select report.supp_id,report.supp_name,report.Average,
CASE
	WHEN report.Average =5 THEN 'Excellent Service'
	WHEN report.Average >4 THEN 'Good Service'
	WHEN report.Average >2 THEN 'Average Service'
	ELSE 'Poor Service'
	END AS Type_of_Service from
(select final.supp_id, supplier.supp_name, final.Average from
(select test2.supp_id, sum(test2.rat_ratstars)/count(test2.rat_ratstars) as Average from
(select supplier_pricing.supp_id, test.ORD_ID, test.RAT_RATSTARS from supplier_pricing inner join
(select orders.pricing_id, rating.ORD_ID, rating.RAT_RATSTARS from orders inner join rating on rating.ord_id = orders.ord_id ) as test
on test.pricing_id = supplier_pricing.pricing_id)
as test2 group by supplier_pricing.supp_id)
as final inner join supplier where final.supp_id = supplier.supp_id) as report;

CALL Rating_report()