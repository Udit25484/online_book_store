create database onlinebookstore;
use OnlineBookstore;

create table books(
book_id serial primary key,
title varchar(100),
author varchar(100),
genre varchar(50),
published_year int,
price numeric(10,2),
stock int);

create table customers(
customer_id serial primary key,
name varchar(100),
email varchar(100),
phone varchar(15),
city varchar(50),
country varchar(150));

create table orders(
order_id serial primary key,
customer_id int references customers(customers_id),
book_id int references books(book_id),
order_date date,
quantity int,
total_amount numeric(10,2));

select * from books;
select * from customers;
select * from orders;


-- 1) Retrieve all books in the "Fiction" genre:
select * from books where genre='fiction'; 

-- 2) Find books published after the year 1950:
select * from books where published_year > '1950' order by published_year asc;

-- 3) List all customers from the Canada:
select * from customers where country = 'canada';

-- 4) Show orders placed in November 2023:
select * from orders where order_date between '2023-11-01' and '2023-11-30' order by order_date asc;


-- 5) Retrieve the total stock of books available:
select sum(stock) as total_stock from books;

-- 6) Find the details of the most expensive book:
select * from books order by price desc limit 1;  

-- 7) Show all customers who ordered more than 1 quantity of a book:
select * from orders where quantity > 1 order by quantity asc;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders where total_amount > 20 order by total_amount asc;

-- 9) List all genres available in the Books table:
select distinct genre from books;

-- 10) Find the book with the lowest stock:
select * from books order by stock asc; 

-- 11) Calculate the total revenue generated from all orders:
select sum( total_amount) as total_revenue from orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
select sum(orders.quantity) as total_book_sold, books.genre
from orders join books
on orders.book_id = books.book_id
group by books.genre;


-- 2) Find the average price of books in the "Fantasy" genre:
select genre, avg(price) as avg_price  from books where genre = 'fantasy';


-- 3) List customers who have placed at least 2 orders:
select customers.name , count(orders.order_id)
from customers join orders
on customers.customer_id = orders.customer_id
group by customers.name
having count(order_id)>=2;

-- 4) Find the most frequently ordered book:
 select count(order_id) as order_count, book_id
 from orders
 group by book_id
 order by order_count desc;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select * from books
where genre = 'fantasy'
order by price desc limit  3;


-- 6) Retrieve the total quantity of books sold by each author:
select distinct(books.author), sum(orders.quantity) as total_quantity
from books join orders 
on books.book_id = orders.book_id
group by books.author;


-- 7) List the cities where customers who spent over $30 are located:
select distinct customers.city, orders.total_amount
from customers join orders
on customers.customer_id = orders.customer_id
where total_amount >30;

-- 8) Find the customer who spent the most on orders:
select customers.customer_id, customers.name, sum(orders.total_amount) as total_spent
from orders join customers
on orders.customer_id = customers.customer_id 
group by customers.customer_id, customers.name
order by total_spent desc limit 1;

-- 9) Calculate the stock remaining after fulfilling all orders:
select books.book_id, books.title, books.stock,coalesce(sum(orders.quantity),0) as order_quantity,
books.stock - coalesce(sum(orders.quantity),0) as remaining_orders
from books
left join orders on books.book_id = orders.book_id
group by books.book_id;

