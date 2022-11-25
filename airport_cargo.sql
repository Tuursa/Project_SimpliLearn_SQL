#Import data
USE airports_data;

#Write a query to display all the passengers (customers) who have travelled in routes 01 to 25. Take data  from the passengers_on_flights table.
SELECT * FROM airports_data.passengers_on_flights;
SELECT * FROM airports_data.customer;
select customer.first_name, customer.last_name, customer.customer_id, passengers_on_flights.route_id from customer inner join passengers_on_flights
on customer.customer_id = passengers_on_flights.customer_id
where passengers_on_flights.route_id between 0 and 25
order by route_id;

#Write a query to identify the number of passengers and total revenue in business class from the ticket_details table.
SELECT * FROM airports_data.ticket_details;
select  customer.customer_id, customer.first_name, customer.last_name, ticket_details.class_id,  ticket_details.Price_per_ticket as total from customer join ticket_details
on customer.customer_id = ticket_details.customer_id
where class_id="bussiness"
order by Price_per_ticket desc;

#Write a query to display the full name of the customer by extracting the first name and last name from the customer table.
select concat(first_name, " ", last_name) as full_name from customer;

#Write a query to extract the customers who have registered and booked a ticket. Use data from the customer and ticket_details tables.
select customer.customer_id, ticket_details.no_of_tickets, ticket_details.class_id from customer
join ticket_details
on customer.customer_id = ticket_details.customer_id
order by customer_id asc;

#Write a query to identify the customer’s first name and last name based on their customer ID and brand (Emirates) from the ticket_details table.
select ticket_details.brand, ticket_details.customer_id, customer.first_name, customer.last_name from ticket_details
join customer
on ticket_details.customer_id = customer.customer_id
order by brand;

#Write a query to identify the customers who have travelled by Economy Plus class using Group By and Having clause on the passengers_on_flights table.
select customer.first_name, customer.last_name, passengers_on_flights.class_id from customer
join passengers_on_flights
on customer.customer_id = passengers_on_flights.customer_id
group by first_name, class_id
having class_id="economy plus";

#Write a query to identify whether the revenue has crossed 10000 using the IF clause on the ticket_details table.
select sum(ticket_details.Price_per_ticket) as Total_revenue, if (sum(Price_per_ticket) >10000 , "yes" , "no" ) as Reveune_crossed_or_not from ticket_details;

#Write a query to create and grant access to a new user to perform operations on a database.
USE airports_data;
GRANT ALL ON *.* TO 'root'@'localhost';
#FLUSH PRIVILEGES;

#Write a query to find the maximum ticket price for each class using window functions on the ticket_details table.
SELECT customer_id,  class_id , MAX(Price_per_ticket) OVER(PARTITION BY class_id) FROM tickets_detail;

#Write a query to extract the passengers whose route ID is 4 by improving the speed and performance of the passengers_on_flights table */
select customer.customer_id, customer.first_name, customer.last_name, passengers_on_flights.aircraft_id, passengers_on_flights.route_id from customer 
inner join passengers_on_flights 
on customer.customer_id = passengers_on_flights.customer_id
where route_id  = 4;

#For the route ID 4, write a query to view the execution plan of the passengers_on_flights table */
create view execution_plan
as 
select customer.first_name, customer.last_name , passengers_on_flights.* from customer 
inner join passengers_on_flights
on customer.customer_id = passengers_on_flights.customer_id
where route_id  = 4;

#Write a query to calculate the total price of all tickets booked by a customer across different aircraft IDs using rollup function */
select customer_id, aircraft_id, sum(Price_per_ticket) as total from ticket_details
group by  customer_id, aircraft_id with rollup ;

#Write a query to create a view with only business class customers along with the brand of airlines*/
create view business_class
as 
select customer.first_name, customer.last_name , ticket_details.brand from customer 
inner join ticket_details 
on customer.customer_id = ticket_details.customer_id
where class_id = "bussiness" ;
 
#Write a query to create a stored procedure that extracts all the details from the routes table where the travelled distance is more than 2000 miles
*/delimiter &&  
CREATE PROCEDURE distance_miles()  
begin
SELECT * FROM  routes where distance_miles > 2000;
END &&  
call distance_miles() ; 
 
#Write a query to create a stored procedure that groups the distance travelled by each flight into three categories. 
The categories are, short distance travel (SDT) for >=0 AND <= 2000 miles, 
intermediate distance travel (IDT) for >2000 AND <=6500, and long-distance travel (LDT) for >6500. */

select *,
case 
when distance_miles >=0 AND distance_miles <= 2000 then "short distance travel (SDT)"
when distance_miles >2000 and distance_miles <= 6500 then "intermediate distance travel (IDT)"
when  distance_miles >6500 then "long-distance travel (LDT)"
end as categories
from routes;
 
#Write a query to extract ticket purchase date, customer ID, class ID and specify if the complimentary services are provided for the specific class using a stored function in stored procedure on the ticket_details table.
Condition:
If the class is Business and Economy Plus, then complimentary services are given as Yes, else it is No*/
 
select p_date, customer_id, class_id,
CASE 
	when class_id = 'Bussiness' or class_id = "economy plus" then 'Yes'
    else 'No' 
end as Complimentary_service   
from ticket_details
order by customer_id;

