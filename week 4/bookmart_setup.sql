-- ============================================================
-- bookmart_setup.sql
-- Fresh dataset for Week 4 Weekly Assessment
-- The Unlox Academy · DA/DS Track
-- ============================================================
-- Three related tables — designed to exercise every Week 4 concept:
--   authors : self-join via mentor_id
--   books   : joined to authors via author_id
--   sales   : joined to books via book_id
--
-- HOW TO RUN:
--   1. Open MySQL Workbench
--   2. File > Open SQL Script > select this file
--   3. Press Ctrl+Shift+Enter
--   4. Verify:
--        SELECT COUNT(*) FROM bookmart.authors;   -- 10
--        SELECT COUNT(*) FROM bookmart.books;     -- 25
--        SELECT COUNT(*) FROM bookmart.sales;     -- 40
-- ============================================================

DROP DATABASE IF EXISTS bookmart;
CREATE DATABASE bookmart;
USE bookmart;

-- ============================================================
-- authors — 10 rows, 3 mentor relationships for SELF JOIN
-- ============================================================
CREATE TABLE authors (
    author_id    INT PRIMARY KEY,
    name         VARCHAR(60),
    country      VARCHAR(30),
    born_year    INT,
    mentor_id    INT,       -- self-reference for SELF JOIN
    FOREIGN KEY (mentor_id) REFERENCES authors(author_id)
);

INSERT INTO authors VALUES
    (1,  'Chetan Bhagat',        'India',   1974, NULL),
    (2,  'Amish Tripathi',       'India',   1974, NULL),
    (3,  'Ruskin Bond',          'India',   1934, NULL),
    (4,  'Preeti Shenoy',        'India',   1971, 1),     -- mentored by Chetan
    (5,  'Devdutt Pattanaik',    'India',   1970, NULL),
    (6,  'James Clear',          'USA',     1986, NULL),
    (7,  'Yuval Harari',         'Israel',  1976, NULL),
    (8,  'Alex Michaelides',     'UK',      1977, 7),     -- mentored by Yuval
    (9,  'Robert Kiyosaki',      'USA',     1947, NULL),
    (10, 'Malcolm Gladwell',     'Canada',  1963, 7);     -- mentored by Yuval

-- ============================================================
-- books — 25 rows, spanning 7 genres and 10 authors
-- Author 3 (Ruskin Bond) and Author 9 (Kiyosaki) have some intentional
-- design decisions for LEFT JOIN demos below
-- ============================================================
CREATE TABLE books (
    book_id          INT PRIMARY KEY,
    title            VARCHAR(80),
    author_id        INT,
    genre            VARCHAR(30),
    price            DECIMAL(6, 2),
    published_year   INT,
    avg_rating       DECIMAL(3, 2),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

INSERT INTO books VALUES
    -- Chetan Bhagat (author 1) — Fiction
    (101, 'Half Girlfriend',              1, 'Fiction',   199.00, 2014, 4.00),
    (102, 'One Indian Girl',              1, 'Fiction',   249.00, 2016, 3.80),
    (103, '400 Days',                     1, 'Fiction',   349.00, 2021, 4.10),
    -- Amish Tripathi (author 2) — Mythology
    (104, 'Immortals of Meluha',          2, 'Mythology', 299.00, 2010, 4.50),
    (105, 'Secret of the Nagas',          2, 'Mythology', 299.00, 2011, 4.60),
    (106, 'Oath of the Vayuputras',       2, 'Mythology', 399.00, 2013, 4.70),
    -- Ruskin Bond (author 3) — Fiction + Biography
    (107, 'The Room on the Roof',         3, 'Fiction',   199.00, 2012, 4.40),
    (108, 'Rain in the Mountains',        3, 'Fiction',   249.00, 2015, 4.50),
    (109, 'Landour Days',                 3, 'Biography', 299.00, 2018, 4.30),
    -- Preeti Shenoy (author 4)
    (110, 'Life is What You Make It',     4, 'Fiction',   299.00, 2011, 4.20),
    (111, 'The One You Cannot Have',      4, 'Fiction',   349.00, 2013, 4.00),
    -- Devdutt Pattanaik (author 5) — Mythology
    (112, 'Jaya',                         5, 'Mythology', 499.00, 2014, 4.60),
    (113, 'Sita',                         5, 'Mythology', 449.00, 2016, 4.50),
    (114, 'My Gita',                      5, 'Mythology', 399.00, 2018, 4.40),
    -- James Clear (author 6) — Self-Help
    (115, 'Atomic Habits',                6, 'Self-Help', 349.00, 2018, 4.70),
    -- Yuval Harari (author 7) — History
    (116, 'Sapiens',                      7, 'History',   499.00, 2011, 4.60),
    (117, 'Homo Deus',                    7, 'History',   599.00, 2015, 4.40),
    (118, '21 Lessons',                   7, 'History',   549.00, 2018, 4.30),
    -- Alex Michaelides (author 8) — Fiction
    (119, 'The Silent Patient',           8, 'Fiction',   399.00, 2019, 4.50),
    (120, 'The Maidens',                  8, 'Fiction',   449.00, 2021, 4.00),
    -- Robert Kiyosaki (author 9) — Business (only 1 book)
    (121, 'Rich Dad Poor Dad',            9, 'Business',  299.00, 2000, 4.40),
    -- Malcolm Gladwell (author 10) — Business
    (122, 'Outliers',                    10, 'Business',  449.00, 2008, 4.50),
    (123, 'Blink',                       10, 'Business',  399.00, 2005, 4.30),
    (124, 'Talking to Strangers',        10, 'Business',  549.00, 2019, 4.10),
    -- One book with NULL rating (new release)
    (125, 'The Wager',                    7, 'History',   599.00, 2024, NULL);

-- ============================================================
-- sales — 40 rows across 5 Indian cities and 6 months of 2024
-- Some books have NO sales (used for LEFT JOIN anti-join demos)
-- ============================================================
CREATE TABLE sales (
    sale_id        INT PRIMARY KEY,
    book_id        INT,
    quantity       INT,
    sale_date      DATE,
    city           VARCHAR(30),
    customer_type  VARCHAR(15),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

INSERT INTO sales VALUES
    (1001, 101, 3, '2024-01-15', 'Bengaluru', 'Retail'),
    (1002, 104, 2, '2024-01-18', 'Mumbai',    'Retail'),
    (1003, 115, 5, '2024-01-22', 'Bengaluru', 'Corporate'),
    (1004, 116, 4, '2024-01-25', 'Delhi',     'Retail'),
    (1005, 121, 2, '2024-01-28', 'Bengaluru', 'Student'),
    (1006, 115, 3, '2024-02-02', 'Chennai',   'Retail'),
    (1007, 112, 1, '2024-02-05', 'Mumbai',    'Retail'),
    (1008, 116, 2, '2024-02-10', 'Bengaluru', 'Retail'),
    (1009, 122, 3, '2024-02-14', 'Delhi',     'Corporate'),
    (1010, 101, 1, '2024-02-18', 'Hyderabad', 'Student'),
    (1011, 115, 6, '2024-02-22', 'Bengaluru', 'Corporate'),
    (1012, 104, 3, '2024-02-25', 'Chennai',   'Retail'),
    (1013, 105, 2, '2024-03-01', 'Bengaluru', 'Retail'),
    (1014, 119, 4, '2024-03-05', 'Mumbai',    'Retail'),
    (1015, 116, 1, '2024-03-10', 'Delhi',     'Student'),
    (1016, 121, 5, '2024-03-14', 'Bengaluru', 'Corporate'),
    (1017, 115, 2, '2024-03-18', 'Chennai',   'Student'),
    (1018, 112, 3, '2024-03-22', 'Bengaluru', 'Retail'),
    (1019, 122, 2, '2024-03-25', 'Mumbai',    'Retail'),
    (1020, 107, 1, '2024-03-28', 'Delhi',     'Retail'),
    (1021, 104, 4, '2024-04-02', 'Bengaluru', 'Retail'),
    (1022, 115, 3, '2024-04-05', 'Hyderabad', 'Corporate'),
    (1023, 116, 2, '2024-04-10', 'Chennai',   'Retail'),
    (1024, 119, 3, '2024-04-14', 'Bengaluru', 'Student'),
    (1025, 121, 1, '2024-04-18', 'Mumbai',    'Retail'),
    (1026, 122, 4, '2024-04-22', 'Delhi',     'Corporate'),
    (1027, 112, 2, '2024-04-25', 'Bengaluru', 'Retail'),
    (1028, 115, 5, '2024-05-01', 'Bengaluru', 'Corporate'),
    (1029, 104, 2, '2024-05-05', 'Hyderabad', 'Retail'),
    (1030, 116, 3, '2024-05-10', 'Mumbai',    'Retail'),
    (1031, 121, 2, '2024-05-14', 'Chennai',   'Student'),
    (1032, 105, 1, '2024-05-18', 'Bengaluru', 'Retail'),
    (1033, 122, 2, '2024-05-22', 'Delhi',     'Retail'),
    (1034, 119, 3, '2024-05-25', 'Bengaluru', 'Corporate'),
    (1035, 115, 4, '2024-06-02', 'Mumbai',    'Retail'),
    (1036, 116, 1, '2024-06-05', 'Chennai',   'Student'),
    (1037, 112, 2, '2024-06-10', 'Bengaluru', 'Retail'),
    (1038, 121, 3, '2024-06-14', 'Delhi',     'Corporate'),
    (1039, 115, 2, '2024-06-18', 'Bengaluru', 'Retail'),
    (1040, 104, 1, '2024-06-22', 'Hyderabad', 'Retail');

-- ============================================================
-- Verify
-- ============================================================
SELECT COUNT(*) AS authors_count FROM authors;   -- 10
SELECT COUNT(*) AS books_count   FROM books;     -- 25
SELECT COUNT(*) AS sales_count   FROM sales;     -- 40
SELECT * FROM books b 
INNER JOIN authors a ON b.author_id = a.author_id;
SELECT a.name FROM authors a 
LEFT JOIN books b ON a.author_id = b.author_id 
WHERE b.book_id IS NULL;
SELECT a.name AS author, m.name AS mentor 
FROM authors a 
JOIN authors m ON a.mentor_id = m.author_id; 
SELECT name FROM authors WHERE country = 'India' 
UNION 
SELECT a.name FROM authors a 
JOIN books b ON a.author_id = b.author_id 
WHERE b.genre = 'Mythology';
SELECT COUNT(*) FROM books 
WHERE price > (SELECT AVG(price) FROM books); 
SELECT * FROM books b 
WHERE NOT EXISTS ( 
SELECT 1 FROM sales s WHERE s.book_id = b.book_id 
); 	
SELECT b.title, SUM(s.quantity) AS total_qty 
FROM sales s JOIN books b ON s.book_id = b.book_id 
GROUP BY b.book_id 
ORDER BY total_qty DESC 
LIMIT 1; 
SELECT title, price, 
RANK() OVER (PARTITION BY genre ORDER BY price DESC) AS rank_in_genre 
FROM books WHERE genre = 'Business'; 
select b.title,a.name from books b 
inner join authors a 
on b.author_id=a.author_id;
select a.name,b.title from books b
left join authors a
on b.author_id=a.author_id;
select b.genre,sum(s.quantity*b.price) as total from books b
inner join sales s 
on b.book_id=s.book_id
group by b.genre
order by total desc;
select s.city,sum(s.quantity*b.price) as total from books b
inner join sales s 
on b.book_id=s.book_id
group by s.city
order by total desc
limit 1;
select b.title,a.name from authors a
right join books b
on a.author_id=b.author_id; 
select a.name,b.title from authors a
left join books b on a.author_id=b.author_id
union
select a.name,b.title from authors a
right join books b 
on a.author_id=b.author_id;
select a.name as mentee ,b.name as mentor from authors a
inner join authors b 
on a.mentor_id =b.author_id;
 select c.city ,ct.customer_type
 from (select distinct city from sales) c
cross join (select distinct customer_type from sales) ct;
select name from authors where country='India'
union
select name from authors where born_year>1970;
select b.title from books b 
left join sales s 
on b.book_id=s.book_id
where s.book_id is null;
select title,price from books where price>(select avg(price) from books)
order by price desc;
select s.* from sales s
where s.book_id in (select b.book_id from books b where b.genre in ('History'or'Mythology'));
select title ,price from books where price> all(select price from books where genre='Fiction')
order by price desc;
select b.title,b.genre ,b.price from books b where b.price> (select avg(c.price) from books c)
order by price desc;
select a.name from authors a
where exists(select 1 from books b where b.author_id=a.author_id and b.published_year>2018);
select a.name from authors a where not exists(select 1 from books b where b.author_id=a.author_id and b.genre='business');
select s.* from sales s 
where s.book_id in (select b.book_id from books b
inner join authors a on b.author_id =a.author_id
where a.country='India');
select genre ,avg(price) over(partition by genre) as avges from books order by avges desc;
select title,genre,price from (select b.title,b.genre,b.price, 
row_number() over (partition by b.genre order by b.price desc) as rn
from books b) ranked where rn<=2  ;
select s.sale_id,s.sale_date,s.quantity,
lag(s.quantity) over (order by s.sale_date) as prev_quenty
from sales s
where s.book_id=115
order by s.sale_date;
select s.sale_id,s.sale_date,s.quantity,
sum(s.quantity) over (order by s.sale_date) as running_total
from sales s
order by s.sale_date;

with book_sales as (select s.book_id,
sum(s.quantity) as total_quantity
from sales s group by s.book_id)
select b.title,bs.total_quantity
from book_sales bs
inner join books b 
on bs.book_id=b.book_id
order by bs.total_quantity desc;

-- full ai code undersanding is no or less
-- full ai code undersanding is no or less
	with genre_revenue as (select b.genre, sum(s.quantity*b.price) as revenue
	from sales s inner join books b 
	on s.book_id=b.book_id
	group by b.genre),
	ranked_genres as (select genre,revenue,
	rank() over (order by revenue desc) as genre_rank
	from genre_revenue)
	select genre,
	revenue,genre_rank from ranked_genres order by genre_rank;
    with book_totals as( select s.book_id,sum(s.quantity) as total_quantity
    from sales s
    group by s.book_id),
    genre_revenue as( select b.genre,
    sum(s.quantity*b.price) as total_revenue
    from sales s inner join books b
    on s.book_id=b.book_id
    group by b.genre),
    ranked_books as ( select b.genre,
    bt.book_id,bt.total_quantity,
    rank() over (partition by b.genre order by bt.total_quantity desc) as rnk
    from book_totals bt
    inner join books b
    on bt.book_id=b.book_id)
select g.genre,b.title,a.name as author_name,rb.total_quantity,
g.total_revenue from ranked_books rb
inner join books b
on rb.book_id=b.book_id
inner join authors a
on b.author_id=a.author_id
inner join genre_revenue g
on rb.genre=g.genre
where rb.rnk=1
order by g.total_revenue desc; 