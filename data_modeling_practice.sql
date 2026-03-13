--write a query to list the Customer Namem order id etc ect --
select concat(first_name, ' ', last_name) as name, order_id, total_amount, to_char(orders.order_date, 'MM') as order_month
from retail_practice.customers
	join retail_practice.orders
		on retail_practice.customers.customer_id = retail_practice.orders.customer_id

	

--unions: sales aggregate--
select order_id, order_date, total_amount, 'high_sale' as valuation
	from retail_practice.orders
	where total_amount > 500
union select l_order_id, l_order_date, l_total_amount, 'recent_sale' as valuation
	from retail_practice.legacy_orders
	where l_order_date >= '2022-11-20' --this should be in single quotes otherwise sql thinks its minus--


--string functions--
select
	email,
	replace(substring(email, 1, position('@' in email) - 1), '.', ' ') as username,
	substring(email from position('@' in email) + 1) as email_provider
from retail_practice.customers


--case statements and window functions --VERY IMPORTANT TOPIC--
select
	concat(first_name, ' ', last_name) as customer_name,
	cus.customer_id,
	order_id,
	to_char(order_date, 'DD FMMonth, YYYY') as order_date,
	total_amount,
	case
		when total_amount < 500 then 'small'
		when total_amount <= 1000 then 'medium'
		else 'large'
	end as order_category,
	sum(total_amount) over(partition by cus.customer_id
		 order by order_id) as rolling_total,
	dense_rank() over(partition by region_id
		order by (
			select sum(total_amount)
			from retail_practice.orders as inner_ord
			where inner_ord.customer_id = cus.customer_id)
		desc) as customer_rank
from retail_practice.orders as ord
join retail_practice.customers as cus
	on cus.customer_id = ord.customer_id
order by customer_rank
		
		
case
			when total_amount < 500 then 'small'
			when total_amount <= 1000 then 'medium'
			else 'large'
		end		

		
		
--CTE's with window function--
with rolling_sales as 
(
select customer_id, sum(total_amount) as total
from orders
group by customer_id
)
select customer_id, total, sum(total) over(order by customer_id) as rolling_total
from rolling_sales;



--Triggers and events-- NEED TO FIX, ITS WRONG--
CREATE TRIGGER new_customers
AFTER INSERT ON orders
FOR EACH ROW
$$ BEGIN
    INSERT INTO customers (customer_id, join_date, region_id)
    VALUES (NEW.customer_id, CURRENT_DATE, 4);
end; $$


--stored procedures-- its wrong, check below for correct--
CREATE PROCEDURE large_sales()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Every statement inside BEGIN/END must end with a semicolon--
    SELECT * from orders
    WHERE total_amount > 1250;
    
    SELECT * from orders
    WHERE total_amount > 1000;
END;
$$;

call large_sales(); --this doesnt work, dunno why?--  Okay, Update - this is only used to delete/update data, to view it, use FUNCTIONS--
		

--NOTE: Triggers, Events and Procedures hae a diff way of working in postgres--

--Functions: use this if you want to call and show data--
create or replace function large_sales(threshold int)
returns setof orders
language plpgsql
as $$
begin
		return query
		select * from orders
		where total_amount > threshold; --this is the function--
end;
$$;


create or replace function large_sales2(threshold int)
returns setof orders --this wont work as we are only showing orders table but below code also joins customers table--
language plpgsql	-- to make this work, we need to specifically mention the columns to show in returns above--
as $$
begin
	return query
	select order_id, concat(first_name, last_name), orders.customer_id, status, total_amount
	from orders
	join customers
	on orders.customer_id = customers.customer_id
		where total_amount > threshold; --this is the function--
end;
$$;

select * from large_sales(500); --this is used to call the function--

select * from large_sales2(500); --this is used to call the function--



--Correct method to use STORED PROCEDURES--
create or replace procedure regional_discount(region_code int)
language plpgsql
as $$
begin
	update orders
	set total_amount  = total_amount * 0.90
	where region_id = region_code
	 and status = 'Pending'
	 and (total_amount * 0.90) > 50;
raise notice 'Discount Applied to Orders which are pending in Region %', region_code;
end;
$$;

call regional_discount(1);

select * from retail_practice.orders --to check if it worked--
where status = 'Pending'
and region_id = 1;

--code to add region_id to orders--
alter table orders
add column if not exists region_id int;

update orders o
set region_id = c.region_id
from customers c
where c.customer_id = o.customer_id;






select * from retail_practice.customers;
		
select * from retail_practice.orders;

select * from retail_practice.legacy_orders;

select * from retail_practice.products;

select * from retail_practice.regions;