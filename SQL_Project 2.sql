

Basic:

---------------------------------------------------------------------------------------------------------
Q1 Retrieve the total number of orders placed.

select count(order_id) from orders
output -> 21350
----------------------------------------------------------------------------------------------------------
Q2 Calculate the total revenue generated from pizza sales.
select * from order_details   - (order_id)

select sum(o.quantity * p.price) as Total_Revenue 
from   order_details as o
join pizzas as p   
on p.pizza_id = o.pizza_id

output -> 817860.049999993

----------------------------------------------------------------------------------------------------------
Q3 Identify the highest-priced pizza.

select pt.name , p.price 
from  pizza_types as pt
join pizzas as p 
on p.pizza_type_id = pt.pizza_type_id
order by p.price desc
limit 1





----------------------------------------------------------------------------------------------------------
Q4 Identify the most common pizza size ordered.
select * from pizzas

select p.size , count(od.order_details_id) as common_size_order
from pizzas as p
join order_details as od
on p.pizza_id = od.pizza_id
group by  p.size decs 

"S"	14137
"XXL"	28
"XL"	544
"M"	15385
"L"	18526


----------------------------------------------------------------------------------------------------------
Q5 List the top 5 most ordered pizza types along with their quantities.
 
select   pt.name , sum(od.quantity) as quantities
from pizza_types as pt
join pizzas on  pizzas.pizza_type_id = pt.pizza_type_id 
join order_details as od on od.pizza_id = pizzas.pizza_id
group by pt.name 
order by quantities	desc limit 5

output
"The Classic Deluxe Pizza"	2453
"The Barbecue Chicken Pizza"	2432
"The Hawaiian Pizza"	2422
"The Pepperoni Pizza"	2418
"The Thai Chicken Pizza"	2371



----------------------------------------------------------------------------------------------------------
Intermediate:
Q1 Join the necessary tables to find the total quantity of each pizza category ordered.

select pt.category ,sum(od.quantity) as quantity
from pizza_types as pt
join pizzas on  pizzas.pizza_type_id = pt.pizza_type_id 
join order_details as od on od.pizza_id = pizzas.pizza_id
group by pt.category
order by quantity desc


output
"Classic"	14888
"Supreme"	11987
"Veggie"	11649
"Chicken"	11050




----------------------------------------------------------------------------------------------------------



Q2 Determine the distribution of orders by hour of the day.
select hour(order_time),count(order_id)  from public.orders
group by order_time


----------------------------------------------------------------------------------------------------------

Q3 Join relevant tables to find the category-wise distribution of pizzas.
 
select distinct(category),count(name)
from pizza_types
group by category

output
"Chicken"	6
"Classic"	8
"Supreme"	9
"Veggie"	9



----------------------------------------------------------------------------------------------------------
Q4 Group the orders by date and calculate the average number 
of pizzas ordered per day.

select round(avg(qut),0) as avg_number_of_pizzas from
(select o.order_date,sum(od.quantity) as qut
from orders as o
join order_details as od 
on o.order_id = o.	order_id
group by o.order_date ) as order_quantity



----------------------------------------------------------------------------------------------------------
Q5 Determine the top 3 most ordered pizza types based on revenue.

select pt.name ,sum(p.price * od.quantity) as  revenue
from pizza_types as pt
join pizzas as p 
on p.pizza_type_id = pt.pizza_type_id
join order_details as od 
on  od.pizza_id = p.pizza_id
group by pt.name	
order by revenue desc 
limit 3

output
"The Thai Chicken Pizza"	43434.25
"The Barbecue Chicken Pizza"	42768
"The California Chicken Pizza"	41409.5



----------------------------------------------------------------------------------------------------------
Advanced:
Q1 Calculate the percentage contribution of each pizza type to total revenue.

select pt.category ,(sum(p.price * od.quantity)  / (select sum(od.quantity * p.price) as total_sales 
from order_details as od 
join pizzas	as p on p.pizza_id = od.pizza_id )) * 100 as revenue
from pizza_types as pt
join pizzas as p 
on p.pizza_type_id = pt.pizza_type_id
join order_details as od 
on  od.pizza_id = p.pizza_id
group by pt.category	
order by revenue desc 
limit 3


output
"Classic"	26.905960255669903
"Supreme"	25.45631126009884
"Chicken"	23.955137556847493





----------------------------------------------------------------------------------------------------------
Q2 Analyze the cumulative revenue generated over time.

select order_date , sum(revenue) over (order by order_date) as cum_revenure
from 
(select o.order_date,sum(p.price * od.quantity) as revenue
from order_details as od
join pizzas as p   on od.pizza_id = p.pizza_id
join orders as o   on od.order_id = o.order_id
group by  o.order_date) as sales;





----------------------------------------------------------------------------------------------------------

Q3 Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select name, revenue from 
(select category , name, revenue , rank () over (partition by category order by revenue desc)as rn 
from	
(select pt.category,pt.name ,sum( (od.quantity) * p.price ) as revenue
from pizza_types as pt
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join order_details as od 
on od.pizza_id = p.pizza_id
group by pt.category,pt.name) as a) as b 
where rn <=3;
















