-- Select database
USE publications;

-- Challenge 1 - Step 1
# The royalties the author will receive is typically a percentage of the entire book sales.
CREATE TEMPORARY TABLE royalties_1
SELECT 	titles.title_id AS Title_ID, 
		authors.au_id as Author_ID,
        (titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS sales_royalty
FROM authors
JOIN titleauthor
	ON authors.au_id = titleauthor.au_id
JOIN titles
	ON titleauthor.title_id = titles.title_id
JOIN sales
	ON titles.title_id = sales.title_id;

# Checking the values of the temp table
SELECT *
FROM royalties_1;


-- Challenge 1 - Step 2
CREATE TEMPORARY TABLE royalties_2
SELECT 	Title_ID, 
		Author_ID,
        SUM(sales_royalty) AS agg_royalties
FROM royalties_1
GROUP BY Title_ID, Author_ID;

# Checking the values of the temp table
SELECT *
FROM royalties_2;


-- Challenge 1 - Step 3
# An advance is the money that the publisher pays the author before the book comes out.
# The total profit an author receives by publishing a book is the sum of the advance and the royalties.
SELECT 	Author_ID,
        
        # Aquí debajo, el advance representa cuánto se pago de advance por el libro, PERO el combinado de ambos autores.
        # El royaltyper indica qué porcentaje del advance le tocó a cada autor; por esa razón, multiplicamos advance y royaltyper.
        SUM((titles.advance * titleauthor.royaltyper / 100) + agg_royalties) AS Profits
FROM royalties_2
JOIN titles
	ON royalties_2.Title_id = titles.title_id
JOIN titleauthor
	ON royalties_2.Author_ID = titleauthor.au_id
GROUP BY Author_ID
ORDER BY Profits DESC
LIMIT 3;


-- Challenge 2
# El reto anterior se hizo con temporary tables, así que aquí hagámoslo con derived tables (también conocidas como subqueries).
SELECT 	Author_ID,
        SUM((titles.advance * titleauthor.royaltyper / 100) + agg_royalties) AS Profits
FROM (
	SELECT 	Title_ID, 
			Author_ID,
			SUM(sales_royalty) AS agg_royalties
	FROM (
		SELECT 	titles.title_id AS Title_ID, 
				authors.au_id as Author_ID,
				(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS sales_royalty
		FROM authors
		JOIN titleauthor
			ON authors.au_id = titleauthor.au_id
		JOIN titles
			ON titleauthor.title_id = titles.title_id
		JOIN sales
			ON titles.title_id = sales.title_id) as royalties_1
	GROUP BY Title_ID, Author_ID ) as royalties_2
JOIN titles
	ON royalties_2.Title_id = titles.title_id
JOIN titleauthor
	ON royalties_2.Author_ID = titleauthor.au_id
GROUP BY Author_ID
ORDER BY Profits DESC
LIMIT 3;


-- Challenge 3
CREATE TABLE most_profiting_authors
SELECT 	Author_ID AS au_id,
        SUM((titles.advance * titleauthor.royaltyper / 100) + agg_royalties) AS profits
FROM (
	SELECT 	Title_ID, 
			Author_ID,
			SUM(sales_royalty) AS agg_royalties
	FROM (
		SELECT 	titles.title_id AS Title_ID, 
				authors.au_id as Author_ID,
				(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS sales_royalty
		FROM authors
		JOIN titleauthor
			ON authors.au_id = titleauthor.au_id
		JOIN titles
			ON titleauthor.title_id = titles.title_id
		JOIN sales
			ON titles.title_id = sales.title_id) as royalties_1
	GROUP BY Title_ID, Author_ID ) as royalties_2
JOIN titles
	ON royalties_2.Title_id = titles.title_id
JOIN titleauthor
	ON royalties_2.Author_ID = titleauthor.au_id
GROUP BY Author_ID
ORDER BY Profits DESC;

# Checando que se creó correctamente la tabla
SELECT *
FROM most_profiting_authors;