/*
CS4400: Introduction to Database Systems
Spring 2021
Phase III Template
Team 74
Alexa O'Reilly (aoreilly)
Madeline Wilson (mwilson316)
Caeden Meade (cmeade3)
Aaron Mathieson (amathieson)

Directions:
Please follow all instructions from the Phase III assignment PDF.
This file must run without error for credit.
*/

-- Procedure 2.a
-- ID: 2a
-- Author: asmith457
-- Name: register_customer
DROP PROCEDURE IF EXISTS register_customer;
DELIMITER //
CREATE PROCEDURE register_customer(
	   IN i_username VARCHAR(40),
       IN i_password VARCHAR(40),
	   IN i_fname VARCHAR(40),
       IN i_lname VARCHAR(40),
       IN i_street VARCHAR(40),
       IN i_city VARCHAR(40),
       IN i_state VARCHAR(2),
	   IN i_zipcode CHAR(5),
       IN i_ccnumber VARCHAR(40),
	   IN i_cvv CHAR(3),
       IN i_exp_date DATE
)
BEGIN

-- Type solution below
IF i_username NOT IN (SELECT Username from users) AND i_username NOT IN (SELECT Username from customer) AND LENGTH(i_zipcode) = 5 THEN
  INSERT INTO users (Username, Pass, FirstName, LastName, Street, City, State, Zipcode) 
  VALUES (i_username, MD5(i_password), i_fname, i_lname, i_street, i_city, i_state, i_zipcode);
  INSERT INTO customer (Username, CcNumber, CVV, EXP_DATE) VALUES (i_username, i_ccnumber, i_cvv, i_exp_date);
END IF;
IF i_username NOT IN (SELECT Username from customer) AND LENGTH(i_zipcode) = 5 THEN
  INSERT INTO customer (Username, CcNumber, CVV, EXP_DATE) VALUES (i_username, i_ccnumber, i_cvv, i_exp_date);
END IF;

-- End of solution
END //
DELIMITER ;

-- Procedure 2.b
-- ID: 2b
-- Author: asmith457
-- Name: register_employee
DROP PROCEDURE IF EXISTS register_employee;
DELIMITER //
CREATE PROCEDURE register_employee(
	   IN i_username VARCHAR(40),
       IN i_password VARCHAR(40),
	   IN i_fname VARCHAR(40),
       IN i_lname VARCHAR(40),
       IN i_street VARCHAR(40),
       IN i_city VARCHAR(40),
       IN i_state VARCHAR(2),
       IN i_zipcode CHAR(5)
)
BEGIN

-- Type solution below
IF i_username NOT IN (SELECT Username from users) AND LENGTH(i_zipcode) = 5 THEN
  INSERT INTO users (Username, Pass, FirstName, LastName, Street, City, State, Zipcode) 
  VALUES (i_username, MD5(i_password), i_fname, i_lname, i_street, i_city, i_state, i_zipcode);
  INSERT INTO employee (Username) VALUES (i_username);
END IF;
-- End of solution
END //
DELIMITER ;


-- Procedure 4.a
-- ID: 4a
-- Author: asmith457
-- Name: admin_create_grocery_chain
DROP PROCEDURE IF EXISTS admin_create_grocery_chain;
DELIMITER //
CREATE PROCEDURE admin_create_grocery_chain(
        IN i_grocery_chain_name VARCHAR(40)
)
BEGIN

-- Type solution below
IF i_grocery_chain_name NOT IN (SELECT ChainName FROM chain) THEN
  INSERT INTO chain (ChainName) VALUES (i_grocery_chain_name);
END IF;
-- End of solution
END //
DELIMITER ;

-- Procedure 5.a
-- ID: 5a
-- Author: ahatcher8
-- Name: admin_create_new_store
DROP PROCEDURE IF EXISTS admin_create_new_store;
DELIMITER //
CREATE PROCEDURE admin_create_new_store(
    	IN i_store_name VARCHAR(40),
        IN i_chain_name VARCHAR(40),
    	IN i_street VARCHAR(40),
    	IN i_city VARCHAR(40),
    	IN i_state VARCHAR(2),
    	IN i_zipcode CHAR(5)
)
BEGIN
-- Type solution below
IF (i_store_name, i_chain_name) not in (SELECT ChainName, StoreName from Store) and length(i_zipcode) = 5 THEN
INSERT into STORE(StoreName, ChainName, Street, City, State, Zipcode) VALUES (i_store_name, i_chain_name, i_street, i_city, i_state, i_zipcode);
END IF;
-- End of solution
END //
DELIMITER ;

-- Procedure 6.a
-- ID: 6a
-- Author: ahatcher8
-- Name: admin_create_drone
DROP PROCEDURE IF EXISTS admin_create_drone;
DELIMITER //
CREATE PROCEDURE admin_create_drone(
     IN i_drone_id INT,
       IN i_zip CHAR(5),
       IN i_radius INT,
       IN i_drone_tech VARCHAR(40)
)
BEGIN
-- Type solution below
-- select '';
-- select concat('\'', i_drone_id, '\', \'', i_zip, '\', \'', i_radius, '\', \'', i_drone_tech, '\'');
if (select count(*) from store where Zipcode = i_zip) and (select count(*) from drone_tech natural join users where Zipcode = i_zip and drone_tech.Username = i_drone_tech) then
  insert ignore into drone
  (ID, DroneStatus, Zip, Radius, DroneTech)
  values
  (i_drone_id, 'Available', i_zip, i_radius, i_drone_tech);
end if;
-- End of solution
END //
DELIMITER ;


-- Procedure 7.a
-- ID: 7a
-- Author: ahatcher8
-- Name: admin_create_item
DROP PROCEDURE IF EXISTS admin_create_item;
DELIMITER //
CREATE PROCEDURE admin_create_item(
        IN i_item_name VARCHAR(40),
        IN i_item_type VARCHAR(40),
        IN i_organic VARCHAR(3),
        IN i_origin VARCHAR(40)
)
BEGIN
-- Type solution below
IF (i_item_name not in (Select ItemName from Item) AND (i_organic = "Yes" OR i_organic = "No")) THEN
INSERT into ITEM(ItemName, ItemType, Origin, Organic) VALUES (i_item_name, i_item_type, i_origin, i_organic);
END IF;
-- End of solution
END //
DELIMITER ;

-- Procedure 8.a
-- ID: 8a
-- Author: dvaidyanathan6
-- Name: admin_view_customers
DROP PROCEDURE IF EXISTS admin_view_customers;
DELIMITER //
CREATE PROCEDURE admin_view_customers(
	   IN i_first_name VARCHAR(40),
       IN i_last_name VARCHAR(40)
)
BEGIN
-- Type solution below
	
	DROP TABLE IF EXISTS admin_view_customers_result;
    if (i_first_name is not NULL AND i_last_name is not NULL) THEN
    CREATE TABLE admin_view_customers_result as
    select Customer.Username, concat(FirstName," ",LastName) as Name, concat(Street,", ",City,", ",State," ",ZipCode) as Address from Customer left join Users
    on Customer.Username = Users.Username
    where (i_first_name = Users.FirstName AND i_last_name = Users.LastName);
    
    ELSE IF (i_first_name is not NULL AND i_last_name is NULL) THEN
	CREATE TABLE admin_view_customers_result as
    select Customer.Username, concat(FirstName," ",LastName) as Name, concat(Street,", ",City,", ",State," ",ZipCode) as Address from Customer left join Users
    on Customer.Username = Users.Username
    where (i_first_name = Users.FirstName); 
    
    ELSE IF (i_first_name is NULL and i_last_name is NOT NULL) THEN
	CREATE TABLE admin_view_customers_result as
    select Customer.Username, concat(FirstName," ",LastName) as Name, concat(Street,", ",City,", ",State," ",ZipCode) as Address from Customer left join Users
    on Customer.Username = Users.Username
    where (i_last_name = Users.LastName);
    
    ELSE
	CREATE TABLE admin_view_customers_result as
    select Customer.Username, concat(FirstName," ",LastName) as Name, concat(Street,", ",City,", ",State," ",ZipCode) as Address from Customer left join Users
    on Customer.Username = Users.Username;
--     Select * from AdminViewCustomers;
	END IF;
    END IF;
    END IF;
-- End of solution
END //
DELIMITER ;


-- Procedure 9.a
-- ID: 9a
-- Author: dvaidyanathan6
-- Name: manager_create_chain_item
DROP PROCEDURE IF EXISTS manager_create_chain_item;
DELIMITER //
CREATE PROCEDURE manager_create_chain_item(
        IN i_chain_name VARCHAR(40),
    	IN i_item_name VARCHAR(40),
    	IN i_quantity INT, 
    	IN i_order_limit INT,
    	IN i_PLU_number INT,
    	IN i_price DECIMAL(4, 2)
)
BEGIN
-- Type solution below
set @plu_chain_match_count = (select count(*) from chain_item where (PLUNumber = i_PLU_number) and (ChainName = i_chain_name));
if 
(select count(*) from item where ItemName = i_item_name) > 0
and
(@plu_chain_match_count = 0)
then
	insert into chain_item
    (ChainItemName, ChainName, PLUNumber, Orderlimit, Quantity, Price)
    values
    (i_item_name, i_chain_name, i_PLU_number, i_order_limit, i_quantity, i_price)
	on duplicate key update
    ChainItemName = i_item_name,
    ChainName = i_chain_name,
    PLUNumber = i_PLU_number,
    Orderlimit = i_order_limit,
    Quantity = i_quantity,
    Price = i_price;
end if;
-- End of solution
END //
DELIMITER ;

-- Procedure 10.a
-- ID: 10a
-- Author: dvaidyanathan6
-- Name: manager_view_drone_technicians
DROP PROCEDURE IF EXISTS manager_view_drone_technicians;
DELIMITER //
CREATE PROCEDURE manager_view_drone_technicians(
       IN i_chain_name VARCHAR(40),
       IN i_drone_tech VARCHAR(40),
       IN i_store_name VARCHAR(40)
)
BEGIN
-- Type solution below
DROP TABLE IF EXISTS manager_view_drone_technicians_result;
IF (i_drone_tech is not NULL AND i_store_name is not NULL) THEN
    CREATE TABLE manager_view_drone_technicians_result as
    select Drone_Tech.Username, concat(FirstName," ",LastName) as Name, Drone_Tech.StoreName as Location from Drone_Tech left join Users
    on Drone_Tech.Username = Users.Username
    where (Users.Username = i_drone_tech AND Drone_Tech.ChainName = i_chain_name AND Drone_Tech.StoreName = i_store_name);
ELSE IF (i_drone_tech is not NULL AND i_store_name is NULL) THEN
    CREATE TABLE manager_view_drone_technicians_result as
    select Drone_Tech.Username, concat(FirstName," ",LastName) as Name, Drone_Tech.StoreName as Location from Drone_Tech left join Users
    on Drone_Tech.Username = Users.Username
    where (Users.Username = i_drone_tech AND Drone_Tech.ChainName = i_chain_name);
ELSE IF (i_drone_tech is NULL AND i_store_name is not NULL) THEN
    CREATE TABLE manager_view_drone_technicians_result as
    select Drone_Tech.Username, concat(FirstName," ",LastName) as Name, Drone_Tech.StoreName as Location from Drone_Tech left join Users
    on Drone_Tech.Username = Users.Username
    where (Drone_Tech.ChainName = i_chain_name AND Drone_Tech.StoreName = i_store_name);
else
    CREATE TABLE manager_view_drone_technicians_result as
    select Drone_Tech.Username, concat(FirstName," ",LastName) as Name, Drone_Tech.StoreName as Location from Drone_Tech left join Users
    on Drone_Tech.Username = Users.Username
    where (Drone_Tech.ChainName = i_chain_name);
END IF;
END IF;
END IF;
-- End of solution
END //
DELIMITER ;
-- Procedure 11.a
-- ID: 11a
-- Author: vtata6
-- Name: manager_view_drones
DROP PROCEDURE IF EXISTS manager_view_drones;
DELIMITER //
CREATE PROCEDURE manager_view_drones(
       IN i_mgr_username varchar(40), 
       IN i_drone_id int, drone_radius int
)
BEGIN
-- select StoreName, Zipcode from Store
-- where (Store.ChainName in (select ChainName from Manager where i_mgr_username = Manager.Username));

-- Type solution below
-- select * from Drone;
Drop Table if Exists chain_zip_codes;
create table chain_zip_codes as
select distinct(Zipcode) from Store
where (Store.ChainName = (select ChainName from Manager where i_mgr_username = Manager.Username));
set @radius_limit = 0;
if (drone_radius is NOT NULL) THEN
    set @radius_limit = drone_radius;
END IF;

DROP TABLE IF EXISTS manager_view_drones_result;
if (i_drone_id is not NULL) THEN
    Create Table manager_view_drones_result as
    select distinct Drone.ID, Drone.DroneTech as Operator, Radius, Drone.Zip as "Zip Code", Drone.DroneStatus as Status from Drone join chain_zip_codes
    on (Drone.Zip = chain_zip_codes.Zipcode)
    where (i_drone_id = Drone.ID AND Radius >= @radius_limit AND Drone.Zip in (select Zipcode from chain_zip_codes));
else
    Create Table manager_view_drones_result as
    select Drone.ID, Drone.DroneTech as Operator, Radius, Drone.Zip as "Zip Code", Drone.DroneStatus as Status from Drone join chain_zip_codes
    on (Drone.Zip = chain_zip_codes.Zipcode)
    where (Radius >= @radius_limit AND Drone.Zip in (select Zipcode from chain_zip_codes));
END IF;
-- End of solution
END //
DELIMITER ;

-- ID: 12a
-- Author: vtata6
-- Name: manager_manage_stores
DROP PROCEDURE IF EXISTS manager_manage_stores;
DELIMITER //
CREATE PROCEDURE manager_manage_stores(
	   IN i_mgr_username varchar(50), 
	   IN i_storeName varchar(50), 
	   IN i_minTotal int, 
	   IN i_maxTotal int
)
BEGIN
-- Type solution below
DROP TABLE IF EXISTS manager_manage_stores_result;
SET @start = 0;
if (i_minTotal is not NULL) THEN
	SET @start = i_minTotal;
END IF;
SET @finish = 2147483647;
if (i_maxTotal is not NULL) THEN
	SET @finish = i_maxTotal;
END IF;


drop table if exists chain_item_no_qty;
create table chain_item_no_qty as 
select ChainItemName, ChainName, PLUNumber, OrderLimit, Price from Chain_Item;

drop table if exists detailed_order_table;
create table detailed_order_table as
select Contains.OrderID, Contains.Quantity, ChainItemName, Price, sum(Price * quantity) as Total, Drone.ID, Drone_Tech.Username, Store.StoreName, Store.ChainName, concat(Store.Street," ", Store.City,", ", Store.State," ", Store.Zipcode) as Address from chain_item_no_qty
right join Contains on (Contains.PLUNumber = chain_item_no_qty.PLUNumber AND Contains.ChainName = chain_item_no_qty.ChainName)
right join Orders on (Contains.OrderID = Orders.ID)
left join Drone on (Orders.DroneID = Drone.ID)
right join Drone_Tech on (Drone_Tech.Username = Drone.DroneTech)
left join Store on (Store.StoreName = Drone_Tech.StoreName AND Store.ChainName = Drone_Tech.ChainName)
group by (Contains.OrderID);


if (i_storeName is NULL) THEN
CREATE TABLE manager_manage_stores_result as
select detailed_order_table.StoreName, detailed_order_table.Address, count(distinct detailed_order_table.OrderID) as Orders, count(distinct Username) + 1 as Employees, sum(Total) as total from detailed_order_table
where (CEILING(total) <= i_maxTotal AND FLOOR(total) >= i_minTotal AND StoreName IN (select StoreName from Store where( ChainName IN (select Manager.ChainName from Manager where (i_mgr_username = Manager.Username)))))
group by StoreName;



ELSE 

CREATE TABLE manager_manage_stores_result as
select detailed_order_table.StoreName, detailed_order_table.Address, count(distinct detailed_order_table.OrderID) as Orders, count(distinct Username) + 1 as Employees, sum(Total) as total from detailed_order_table
where (CEILING(total) <= i_maxTotal AND FLOOR(total) >= i_minTotal AND StoreName = i_storeName AND StoreName IN (select StoreName from Store where(ChainName IN (select Manager.ChainName from Manager where (i_mgr_username = Manager.Username)))))
group by StoreName;
END IF;
SELECT * FROM grocery_drone_delivery.manager_manage_stores_result;

-- End of solution
END //

-- Procedure 13.a
-- ID: 13a
-- Author: vtata6
-- Name: customer_change_credit_card_information
DROP PROCEDURE IF EXISTS customer_change_credit_card_information;
DELIMITER //
CREATE PROCEDURE customer_change_credit_card_information(
	   IN i_custUsername varchar(40), 
	   IN i_new_cc_number varchar(19), 
	   IN i_new_CVV int, 
	   IN i_new_exp_date date
)
BEGIN
-- Type solution below
if curdate() < i_new_exp_date then
	update customer set 
	CcNumber = i_new_cc_number,
	CVV = i_new_CVV,
	EXP_DATE = i_new_exp_date 
	where
	Username = i_custUsername;
end if;
-- End of solution
END //
DELIMITER ;

-- Procedure 14.a
-- ID: 14a
-- Author: ftsang3
-- Name: customer_view_order_history
DROP PROCEDURE IF EXISTS customer_view_order_history;
DELIMITER //
CREATE PROCEDURE customer_view_order_history(
       IN i_username VARCHAR(40),
       IN i_orderid INT
)
BEGIN
-- Type solution below

DROP TABLE IF EXISTS contains_item;
Create table contains_item as 
select Contains.OrderID, Contains.ItemName, Contains.ChainName, Contains.Quantity, Contains.PLUNumber, Chain_Item.Price from (Contains left join Chain_Item on (Contains.PLUNumber = Chain_Item.PLUNumber AND Contains.ChainName = Chain_Item.ChainName));

DROP TABLE IF EXISTS customer_view_order_history_result;
IF (i_username is NOT NULL AND i_username in (Select Username from Customer) AND i_orderid IS NOT NULL AND i_orderid in (select ID from Orders where (Orders.CustomerUsername = i_username))) THEN
CREATE TABLE customer_view_order_history_result as 
select sum(contains_item.Price * contains_item.Quantity) as "total_amount", sum(contains_item.quantity) as "total_items", Orders.OrderDate, Orders.DroneID, Drone.DroneTech, Orders.OrderStatus from contains_item
left join Orders on (Orders.ID = contains_item.OrderID)
join Drone on (Orders.DroneID = Drone.ID)
where (Orders.CustomerUsername = i_username AND Orders.ID = i_orderid);
-- End of solution
END IF;
END //
DELIMITER ;

-- Procedure 15.a
-- ID: 15a
-- Author: ftsang3
-- Name: customer_view_store_items
DROP PROCEDURE IF EXISTS customer_view_store_items;
DELIMITER //
CREATE PROCEDURE customer_view_store_items(
	   IN i_username VARCHAR(40),
       IN i_chain_name VARCHAR(40),
       IN i_store_name VARCHAR(40),
       IN i_item_type VARCHAR(40)
)
BEGIN
-- Type solution below
drop table if exists interim;
create temporary table interim
select ChainItemName, Orderlimit from chain_item where ChainName in (select ChainName from store where StoreName = i_store_name and ChainName = i_chain_name and Zipcode in (select Zipcode from users where Username = i_username));

drop table if exists customer_view_store_items_result;
create table customer_view_store_items_result
select ChainItemName, Orderlimit from item join interim on item.ItemName = interim.ChainItemName where ((i_item_type is null) or (i_item_type = 'All') or (ItemType = i_item_type));
-- select Zipcode as zip from users where Username = i_username;
-- select StoreName as sName, ChainName as cName from store where Zipcode in ('0');
/*drop table if exists customer_view_store_items_result;
create table customer_view_store_items_result
	select ItemName from item where 
	(
		(i_item_type is null) 
		or 
		(i_item_type = 'All') 
		or 
		(ItemType = i_item_type)
	) 
	and 
	ItemName in (
		select ChainItemName, Quantity as quant from chain_item where 
		ChainName = (
			select ChainName from store where 
			Zipcode = (
				select Zipcode from users where Username = i_username
			) 
			and 
			ChainName = i_chain_name
			and
			StoreName = i_store_name
		)
	);*/
-- End of solution
END //
DELIMITER ;

-- ID: 15b
-- Author: ftsang3
-- Name: customer_select_items
DROP PROCEDURE IF EXISTS customer_select_items;
DELIMITER //
CREATE PROCEDURE customer_select_items(
      IN i_username VARCHAR(40),
      IN i_chain_name VARCHAR(40),
      IN i_store_name VARCHAR(40),
      IN i_item_name VARCHAR(40),
      IN i_quantity INT
)
BEGIN
-- Type solution below
  set @userZipcode = (select Zipcode from users where users.Username = i_username);
  set @storeInZipcodeCount = (select count(*) from store where Zipcode = @userZipcode and ChainName = i_chain_name and StoreName = i_store_name);
  set @countCreatingOrders = (select count(*) from orders where OrderStatus = 'creating' and CustomerUsername = i_username);
  if @storeInZipcodeCount and (@countCreatingOrders = 0) then
    set @pluNumber = (select PLUNumber from chain_item where ChainItemName = i_item_name and ChainName = i_chain_name);
    if not @pluNumber is null then
        set @orderLimit = (select OrderLimit from chain_item where ChainItemName = i_item_name and ChainName = i_chain_name);
        set @countAvailable = (select Quantity from chain_item where ChainItemName = i_item_name and ChainName = i_chain_name);

        if i_quantity <= @orderLimit and @countAvailable >= i_quantity then
            set @previousOrderID = (select max(ID) from orders);
            set @currentOrderID = @previousOrderID + 1;
            insert into orders
            (ID, OrderStatus, OrderDate, CustomerUsername, DroneID)
            values
            (@currentOrderID, 'creating', curdate(), i_username, null);

            insert into contains
            (OrderID, ItemName, ChainName, PLUNumber, Quantity)
            values
            (@currentOrderID, i_item_name, i_chain_name, @pluNumber, i_quantity);
        end if;
    end if;
end if;

-- End of solution
END //
DELIMITER ;

-- Procedure 16.a
-- ID: 16a
-- Author: jkomskis3
-- Name: customer_review_order
CREATE TABLE customer_review_order_result AS
DROP PROCEDURE IF EXISTS customer_review_order;
DELIMITER //
CREATE PROCEDURE customer_review_order(
	   IN i_username VARCHAR(40)
)
BEGIN
-- Type solution below
DROP TABLE IF EXISTS customer_review_order_result;
CREATE TABLE customer_review_order_result AS
SELECT ItemName, contains.Quantity AS Quantity, Price FROM contains, chain_item 
WHERE contains.OrderID = (SELECT ID FROM orders WHERE CustomerUsername = i_username AND OrderStatus = 'Creating')
AND ItemName=ChainItemName;
-- End of solution
END //
DELIMITER ;

-- Procedure 16.b
-- ID: 16b
-- Author: jkomskis3
-- Name: customer_update_order
DROP PROCEDURE IF EXISTS customer_update_order;
DELIMITER //
CREATE PROCEDURE customer_update_order(
	   IN i_username VARCHAR(40),
       IN i_item_name VARCHAR(40),
       IN i_quantity INT
)
BEGIN
-- Type solution below
UPDATE contains
    SET
    Quantity = i_quantity
  WHERE
    contains.ItemName = i_item_name AND contains.OrderID = (SELECT ID from orders WHERE CustomerUserName = i_username AND OrderStatus = 'Creating');

IF i_quantity = 0 THEN
  DELETE FROM contains WHERE contains.ItemName = i_item_name AND contains.OrderID = (SELECT ID from orders WHERE CustomerUserName = i_username AND OrderStatus = 'Creating');
END IF;
-- End of solution
END //
DELIMITER ;

-- ID: 17a
-- Author: jkomskis3
-- Name: drone_technician_view_order_history
DROP PROCEDURE IF EXISTS drone_technician_view_order_history;
DELIMITER //
CREATE PROCEDURE drone_technician_view_order_history(
        IN i_username VARCHAR(40),
      IN i_start_date DATE,
      IN i_end_date DATE
)
BEGIN
drop view if exists Order_Total;
  create view Order_Total as
  select CONTAINS.OrderID, sum(Price * CONTAINS.Quantity) as Total_Amount from
  CONTAINS, CHAIN_ITEM, ORDERS
  where (CONTAINS.PLUNumber, CONTAINS.ChainName) = (CHAIN_ITEM.PLUNumber, CHAIN_ITEM.ChainName)
  and ORDERS.ID = CONTAINS.OrderID
  group by CONTAINS.OrderID;
    
    drop view if exists Emp;
    create view Emp as
  select * from DRONE_TECH natural join USERS;
    
    drop view if exists Emp_1;
    create view Emp_1 as
    select * from USERS natural join DRONE_TECH;
    
    drop view if exists Cust;
    create view Cust as
    select * from USERS;
    
    drop table if exists drone_technician_view_order_history_result;
    create table drone_technician_view_order_history_result (
    ID int,
        Operator varchar(81),
        Date date,
        Drone_ID int,
        Status varchar(20),
        Total decimal(5, 2),
        key (ID)
  );
    
    set @zipcode = (select STORE.Zipcode from DRONE_TECH, STORE where Username = i_username and (DRONE_TECH.StoreName, DRONE_TECH.ChainName) = (STORE.StoreName, STORE.ChainName));
    
    insert into drone_technician_view_order_history_result
    select distinct ORDERS.ID as ID, 
    concat(Emp.FirstName, ' ', Emp.LastName) as Operator, OrderDate as Date, 
    DroneID as Drone_ID,
    OrderStatus as Status, Order_Total.Total_Amount as Total
    from Emp, Cust, Order_Total, ORDERS, STORE, CONTAINS, DRONE, Emp_1
    where Order_Total.OrderID = CONTAINS.OrderID and CONTAINS.OrderID = ORDERS.ID and ORDERS.DroneID = DRONE.ID
    and Emp_1.Username = i_username and (Emp.StoreName, Emp.ChainName) = (Emp_1.StoreName, Emp_1.ChainName)
    and (Emp.StoreName, Emp.ChainName) = (STORE.StoreName, STORE.ChainName) and DRONE.DroneTech = Emp.Username
    and ORDERS.CustomerUsername = Cust.Username and Cust.Zipcode = STORE.Zipcode and OrderStatus <> 'Pending' and
    (case
    when (i_start_date is not null and i_end_date is not null) then
        OrderDate between i_start_date and i_end_date
        when (i_start_date is not null and i_end_date is null) then
        OrderDate >= i_start_date
        when (i_start_date is null and i_end_date is not null) then
        OrderDate <= i_end_date
        else OrderDate = OrderDate
  end);
    
    insert into drone_technician_view_order_history_result
    select distinct ORDERS.ID as ID, null as Operator,OrderDate as Date, null as Drone_ID, OrderStatus as Status, 
    Order_Total.Total_Amount as Total
    from Emp_1, Cust, Order_Total, ORDERS, STORE, CONTAINS
    where Order_Total.OrderID = CONTAINS.OrderID and CONTAINS.OrderID = ORDERS.ID
    and @zipcode = STORE.Zipcode
    and ORDERS.CustomerUsername = Cust.Username and Cust.Zipcode = STORE.Zipcode and OrderStatus = 'Pending' and
    (case
    when (i_start_date is not null and i_end_date is not null) then
        OrderDate between i_start_date and i_end_date
        when (i_start_date is not null and i_end_date is null) then
        OrderDate >= i_start_date
        when (i_start_date is null and i_end_date is not null) then
        OrderDate <= i_end_date
        else OrderDate = OrderDate
    end);
    
-- End of solution
END //
DELIMITER ;

-- ID: 17b
-- Author: agoyal89
-- Name: dronetech_assign_order
DROP PROCEDURE IF EXISTS dronetech_assign_order;
DELIMITER //
CREATE PROCEDURE dronetech_assign_order(
     IN i_username VARCHAR(40),
       IN i_droneid INT,
       IN i_status VARCHAR(20),
       IN i_orderid INT
)
sp_main: BEGIN

  if i_username not in (select DroneTech from DRONE where ID = i_droneid) then leave sp_main; end if;
    if ((select DroneID from ORDERS where ID = i_orderid) is not null
    and (select DroneID from ORDERS where ID = i_orderid) <> i_droneid) then leave sp_main; end if;

  update DRONE set DroneStatus = 'Busy' where ID = i_droneid;
    
  update ORDERS set OrderStatus = i_status, DroneID = i_droneid where ID = i_orderid; 

-- End of solution
END //
DELIMITER ;

-- ID: 18a
-- Author: agoyal89
-- Name: dronetech_order_details
DROP PROCEDURE IF EXISTS dronetech_order_details;
DELIMITER //
CREATE PROCEDURE dronetech_order_details(
     IN i_username VARCHAR(40),
       IN i_orderid VARCHAR(40)
)
BEGIN
-- Type solution below
    drop view if exists Order_Total;
  create view Order_Total as
  select CONTAINS.OrderID, sum(Price * CONTAINS.Quantity) as Total_Amount, q_total as Total_Items from
  CONTAINS, CHAIN_ITEM, ORDERS, (select OrderID, sum(Quantity) as q_total from CONTAINS group by OrderID) as Q_table
  where (CONTAINS.PLUNumber, CONTAINS.ChainName) = (CHAIN_ITEM.PLUNumber, CHAIN_ITEM.ChainName)
  and ORDERS.ID = CONTAINS.OrderID and ORDERS.ID = Q_table.OrderID
  group by CONTAINS.OrderID;
    
    drop view if exists Emp;
    create view Emp as
    select * from USERS;
    
    drop view if exists Cust;
    create view Cust as
    select * from USERS;
    
    drop table if exists dronetech_order_details_result;
    create table dronetech_order_details_result (
    Customer_Name varchar(81),
        Order_ID int,
        Total_Amount decimal(5, 2),
        Total_Items int,
        Date_of_Purchase date,
    Drone_ID int,
        Store_Associate varchar(81),
        Order_Status varchar(20),
        Address varchar(90),
        primary key (Order_ID)
  );
    if (select OrderStatus from ORDERS where ID = i_orderid) = 'Pending' then
  insert into dronetech_order_details_result
    select concat(Cust.FirstName, ' ', Cust.LastName) as Customer_Name, ORDERS.ID as Order_ID, Total_Amount,
    Total_Items, OrderDate as Date_of_Purchase, 'N/A' as Drone_ID, 'N/A' as Store_Associate,
    OrderStatus as Order_Status, concat(Cust.Street, ', ', Cust.City, ', ', Cust.State, ' ', Cust.Zipcode) as Address
    from ORDERS, Cust, Order_Total
    where Cust.Username = CustomerUsername and ORDERS.ID = Order_Total.OrderID  and
    ORDERS.ID = i_orderid;
    end if;
    
    if (select OrderStatus from ORDERS where ID = i_orderid) <> 'Pending' then
    insert into dronetech_order_details_result
    select concat(Cust.FirstName, ' ', Cust.LastName) as Customer_Name, ORDERS.ID as Order_ID, Total_Amount,
    Total_Items, OrderDate as Date_of_Purchase, DRONE.ID as Drone_ID, concat(Emp.FirstName, ' ', Emp.LastName) as Store_Associate,
    OrderStatus as Order_Status, concat(Cust.Street, ', ', Cust.City, ', ', Cust.State, ' ', Cust.Zipcode) as Address
    from ORDERS, Emp, Cust, DRONE, Order_Total
    where Cust.Username = CustomerUsername and ORDERS.DroneID = DRONE.ID and ORDERS.ID = Order_Total.OrderID  and
    ORDERS.ID = i_orderid and Emp.Username = DRONE.DroneTech;
    end if;

-- End of solution
END //
DELIMITER ;

-- ID: 18b
-- Author: agoyal89
-- Name: dronetech_order_items
DROP PROCEDURE IF EXISTS dronetech_order_items;
DELIMITER //
CREATE PROCEDURE dronetech_order_items(
        IN i_username VARCHAR(40),
        IN i_orderid INT
)
sp_main: BEGIN
-- Type solution below
    if (i_orderid not in 
    (select ORDERS.ID from DRONE, ORDERS where DroneID = DRONE.ID and DroneTech = i_username))
    then leave sp_main; end if;

    drop table if exists dronetech_order_items_result;
    create table dronetech_order_items_result (
        Item varchar(40),
        Count int,
        primary key (Item, Count)
    );

    insert into dronetech_order_items_result
    select ItemName as Item, Quantity as Count
    from CONTAINS, ORDERS where OrderID = ID and ID = i_orderid;
-- End of solution
END //
DELIMITER ;

-- Procedure 19.a
-- ID: 19a
-- Author: agoyal89
-- Name: dronetech_assigned_drones
DROP PROCEDURE IF EXISTS dronetech_assigned_drones;
DELIMITER //
CREATE PROCEDURE dronetech_assigned_drones(
        IN i_username VARCHAR(40),
        IN i_droneid INT,
        IN i_status VARCHAR(20)
)
sp_main: BEGIN

    drop table if exists dronetech_assigned_drones_result;
    create table dronetech_assigned_drones_result (
        Drone_ID int,
        Drone_Status varchar(20),
        Radius int,
        primary key (Drone_ID)
    );

    if i_status = 'Busy' then
    insert into dronetech_assigned_drones_result
    select ID as Drone_ID, DroneStatus as Status, Radius
    from DRONE where DroneTech = i_username and DroneStatus = 'Busy' and
    (case
        when i_droneid is not null then i_droneid = ID
        else ID = ID
    end); end if;

    if i_status = 'Available' then
    insert into dronetech_assigned_drones_result
    select ID as Drone_ID, DroneStatus as Status, Radius
    from DRONE where DroneTech = i_username and DroneStatus = 'Available' and
    (case
        when i_droneid is not null then i_droneid = ID
        else ID = ID
    end); end if;

    if i_status = 'ALL' then
    insert into dronetech_assigned_drones_result
    select ID as Drone_ID, DroneStatus as Status, Radius
    from DRONE where DroneTech = i_username and
    (case
        when i_droneid is not null then i_droneid = ID
        else ID = ID
    end); end if;

-- End of solution
END //
DELIMITER ;



