-- Select database
USE publications;

-- Challenge 1 - Step 1 - Calculate the royalties of each sales for each author
# The royalties the author will receive is typically a percentage of the entire book sales.
CREATE TEMPORARY TABLE author_royalties
SELECT 	titles.title_id AS Title_ID, 
		authors.au_id AS Author_ID,
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
FROM author_royalties;


-- Challenge 1 - Step 2 - Aggregate the total royalties for each title for each author
CREATE TEMPORARY TABLE author_royalties_agg
SELECT 	Title_ID, 
		Author_ID,
        SUM(sales_royalty) AS agg_royalties
FROM author_royalties
GROUP BY Title_ID, Author_ID;

# Checking the values of the temp table
SELECT *
FROM author_royalties_agg;


-- Challenge 1 - Step 3 - Calculate the total profits of each author
# An advance is the money that the publisher pays the author before the book comes out.
# The total profit an author receives by publishing a book is the sum of the advance and the royalties.
SELECT 	Author_ID,
        
        # Aquí debajo, el advance representa cuánto se pago de advance por el libro, PERO el combinado de ambos autores.
        # El royaltyper indica qué porcentaje del advance le tocó a cada autor; por esa razón, multiplicamos advance y royaltyper.
        SUM(titles.advance * titleauthor.royaltyper / 100) + SUM(agg_royalties) AS Profits
FROM author_royalties_agg
	JOIN titles
	ON author_royalties_agg.Title_id = titles.title_id
	JOIN titleauthor
	ON author_royalties_agg.Author_ID = titleauthor.au_id
    AND author_royalties_agg.Title_ID = titleauthor.title_id # Hay que unir tanto en author y title, para considerar solo los autores y libros que aparecen en author_royalties_agg
GROUP BY Author_ID
ORDER BY Profits DESC
;


SELECT 	Author_ID,
        Title_ID,
        # Aquí debajo, el advance representa cuánto se pago de advance por el libro, PERO el combinado de ambos autores.
        # El royaltyper indica qué porcentaje del advance le tocó a cada autor; por esa razón, multiplicamos advance y royaltyper.
        SUM((titles.advance * titleauthor.royaltyper / 100) + (agg_royalties) AS Profits
FROM author_royalties_agg
	JOIN titles
	ON author_royalties_agg.Title_id = titles.title_id
	JOIN titleauthor
	ON author_royalties_agg.Author_ID = titleauthor.au_id 
    AND author_royalties_agg.Title_ID = titleauthor.title_id
GROUP BY Author_ID
ORDER BY Profits DESC
;



-- Challenge 2
# El reto anterior se hizo con temporary tables, así que aquí hagámoslo ahora con derived tables (también conocidas como subqueries).
SELECT 	Author_ID,
		SUM((titles.advance * titleauthor.royaltyper / 100) + agg_royalties) AS Profits
FROM (
	SELECT Title_ID, 
			Author_ID,
			SUM(sales_royalty) AS agg_royalties
	FROM ( 
		SELECT	titles.title_id AS Title_ID, 
				authors.au_id as Author_ID,
				(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS sales_royalty
		FROM authors
			JOIN titleauthor 
			ON authors.au_id = titleauthor.au_id
			JOIN titles
			ON titleauthor.title_id = titles.title_id
			JOIN sales
			ON titles.title_id = sales.title_id) as author_royalties
            
	GROUP BY Title_ID, Author_ID ) as author_royalties_agg
		JOIN titles
		ON author_royalties_agg.Title_id = titles.title_id
		JOIN titleauthor
		ON author_royalties_agg.Author_ID = titleauthor.au_id
        AND author_royalties_agg.Title_ID = titleauthor.title_id
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
			ON titles.title_id = sales.title_id) as author_royalties
            
	GROUP BY Title_ID, Author_ID ) as author_royalties_agg
		JOIN titles
		ON author_royalties_agg.Title_id = titles.title_id
		JOIN titleauthor
		ON author_royalties_agg.Author_ID = titleauthor.au_id
        AND author_royalties_agg.Title_ID = titleauthor.title_id

GROUP BY Author_ID
ORDER BY Profits DESC;

# Checando que se creó correctamente la tabla
SELECT *
FROM most_profiting_authors;