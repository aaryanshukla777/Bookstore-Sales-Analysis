CREATE DATABASE IF NOT EXISTS bookstore_sales;
USE bookstore_sales;

CREATE TABLE IF NOT EXISTS books (
    book_id INT PRIMARY KEY,
    book_name VARCHAR(255),
    author VARCHAR(255),
    publisher VARCHAR(255),
    publishing_year YEAR,
    language_code VARCHAR(20),
    genre VARCHAR(100)
);
USE bookstore_sales;

CREATE TABLE IF NOT EXISTS ratings (
    book_id INT,
    author_rating FLOAT,
    book_average_rating FLOAT,
    book_ratings_count INT,
    gross_sales FLOAT,
    publisher_revenue FLOAT,
    sale_price FLOAT,
    units_sold INT
);
USE bookstore_sales;

SELECT COUNT(*) AS total_ratings
FROM ratings;
SELECT
    b.book_name,
    b.author,
    b.publisher,
    r.gross_sales,
    r.units_sold
FROM books b
JOIN ratings r
    ON b.book_id = r.book_id
ORDER BY r.gross_sales DESC
LIMIT 10;
SELECT
    b.book_name,
    b.author,
    r.gross_sales
FROM books b
JOIN ratings r
    ON b.book_id = r.book_id
WHERE r.gross_sales > (
    SELECT AVG(gross_sales)
    FROM ratings
)
ORDER BY r.gross_sales DESC;
USE bookstore_sales;

SELECT
    b.genre,
    ROUND(AVG(r.book_average_rating), 2) AS avg_book_rating
FROM books b
JOIN ratings r
    ON b.book_id = r.book_id
GROUP BY b.genre
ORDER BY avg_book_rating DESC;
USE bookstore_sales;

WITH publisher_sales AS (
    SELECT
        b.publisher,
        SUM(r.publisher_revenue) AS total_revenue
    FROM books b
    JOIN ratings r
        ON b.book_id = r.book_id
    GROUP BY b.publisher
)
SELECT
    publisher,
    ROUND(total_revenue, 2) AS total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM publisher_sales
ORDER BY revenue_rank;
USE bookstore_sales;

SELECT
    b.book_name,
    b.author,
    b.publishing_year,
    r.book_average_rating
FROM books b
JOIN ratings r
    ON b.book_id = r.book_id
WHERE b.publishing_year = 2012
  AND r.book_average_rating > 4.0
ORDER BY r.book_average_rating DESC;
USE bookstore_sales;
WITH author_stats AS (
    SELECT
        b.author,
        COUNT(*) AS book_count,
        ROUND(AVG(r.author_rating), 2) AS avg_author_rating
    FROM books b
    JOIN ratings r
        ON b.book_id = r.book_id
    GROUP BY b.author
)
SELECT
    author,
    book_count,
    avg_author_rating
FROM author_stats
WHERE book_count > 1
ORDER BY avg_author_rating DESC;
USE bookstore_sales;

SELECT
    b.book_name,
    b.author,
    r.gross_sales,
    r.publisher_revenue,
    ROUND(r.gross_sales - r.publisher_revenue, 2) AS profit_margin
FROM books b
JOIN ratings r
    ON b.book_id = r.book_id
ORDER BY profit_margin DESC;
USE bookstore_sales;

SELECT
    b.book_name,
    b.author,
    b.language_code,
    r.book_ratings_count,
    r.book_average_rating
FROM books b
JOIN ratings r
    ON b.book_id = r.book_id
WHERE LOWER(b.language_code) = 'en'
ORDER BY r.book_ratings_count DESC
LIMIT 5;
USE bookstore_sales;

SELECT
    b.publishing_year,
    SUM(r.units_sold) AS total_units_sold,
    ROUND(SUM(r.gross_sales), 2) AS total_gross_sales
FROM books b
JOIN ratings r
    ON b.book_id = r.book_id
GROUP BY b.publishing_year
ORDER BY b.publishing_year;
USE bookstore_sales;

SELECT
    b.book_name,
    b.author,
    r.author_rating,
    r.book_average_rating
FROM books b
JOIN ratings r
    ON b.book_id = r.book_id
WHERE r.author_rating > r.book_average_rating
ORDER BY (r.author_rating - r.book_average_rating) DESC;
SELECT COUNT(*) AS total_books
FROM books;

SELECT COUNT(*) AS total_ratings
FROM ratings;

SELECT COUNT(*) AS matched_books
FROM books b
JOIN ratings r
    ON b.book_id = r.book_id;

SELECT COUNT(DISTINCT book_id) AS unique_book_ids
FROM ratings;