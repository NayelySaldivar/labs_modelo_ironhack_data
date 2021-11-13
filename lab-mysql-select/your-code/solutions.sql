# Para insertar comentarios, se puede poner "--" o "/*" (para abrir comentario) y "*/" (para cerrarlo
# MySQL, adicionalmente, permite usar #

-- Select database
USE publications;


-- Challenge 1 - Who Have Published What At Where?
SELECT 	au.au_id AS "AUTHOR ID", 
		au.au_lname AS "LAST NAME", 
        au.au_fname AS "FIRST NAME",
        tt.title AS TITLE,
        pb.pub_name AS PUBLISHER
FROM authors AS au # Aquí quizá no es necesario el alias: complica más de lo que ayuda
	JOIN titleauthor AS ta 	# El Join es idéntico a un Inner Join 
	ON au.au_id = ta.au_id
	JOIN titles AS tt 
	ON ta.title_id = tt.title_id
	JOIN publishers AS pb
	ON tt.pub_id = pb.pub_id
ORDER BY au.au_id 
;

# Checando número de records en Table titleauthor (25) para compararlos con nuestro query
SELECT COUNT(*)
FROM titleauthor
;

# Checando número de records en nuestro query (25)
SELECT COUNT(*)
FROM (
	SELECT 	au.au_id AS "AUTHOR ID", 
			au.au_lname AS "LAST NAME", 
			au.au_fname AS "FIRST NAME",
			tt.title AS TITLE,
			pb.pub_name AS PUBLISHER
	FROM authors AS au
		JOIN titleauthor AS ta 
		ON au.au_id = ta.au_id
		JOIN titles AS tt 
		ON ta.title_id = tt.title_id
		JOIN publishers AS pb
		ON tt.pub_id = pb.pub_id) AS table2
;
        
# Nuestros queries coinciden en número de filas, por lo que probablemente están bien.


-- Challenge 2 - Who Have Published How Many At Where?
SELECT 	au.au_id AS "AUTHOR ID", 
		au.au_lname AS "LAST NAME", 
        au.au_fname AS "FIRST NAME",
        pb.pub_name AS PUBLISHER,
        COUNT(au.au_id) AS "TITLE COUNT"
FROM authors AS au
	JOIN titleauthor AS ta 	
	ON au.au_id = ta.au_id
	JOIN titles AS tt 
	ON ta.title_id = tt.title_id
	JOIN publishers AS pb
	ON tt.pub_id = pb.pub_id
GROUP BY au.au_id, pb.pub_name
ORDER BY au.au_id DESC 
;

# A continuación, sumamos la columna "Title Count" para ver si coincide con los records en Table titleauthor (25)

## Se usa un Common Table Expression (CTE), es decir, un resultado temporal al cual
## podemos hacer referencia. Para ello, utilizamos WITH... AS... Es equivalente a usar un subquery.

WITH titles_per_author AS ( # Opcionalmente puedo abrir paréntesis tras titles_per_author para nombrar las columnas de otra forma.
							# Además, le damos un nombre descriptivo a la CTE, de preferencia con snake_case (no con camelCase).
	SELECT 	au.au_id AS "AUTHOR ID", 
			au.au_lname AS "LAST NAME", 
			au.au_fname AS "FIRST NAME",
			pb.pub_name AS PUBLISHER,
			COUNT(au.au_id) as TITLE_COUNT
	FROM authors AS au
		JOIN titleauthor AS ta 	
		ON au.au_id = ta.au_id
		JOIN titles AS tt 
		ON ta.title_id = tt.title_id
		JOIN publishers AS pb
		ON tt.pub_id = pb.pub_id
	GROUP BY au.au_id, pb.pub_name
	ORDER BY au.au_id DESC 
    )

SELECT SUM(TITLE_COUNT)
FROM titles_per_author
;

# Indeed, the number of records equals the number of records in tableauthor


-- Challenge 3 - Best Selling Authors
SELECT 	au.au_id AS "AUTHOR ID", 
		au.au_lname AS "LAST NAME", 
        au.au_fname AS "FIRST NAME",
		SUM(sl.qty) AS TOTAL
FROM authors AS au
	JOIN titleauthor AS ta 	# El Join es idéntico a un Inner Join 
	ON au.au_id = ta.au_id
	JOIN titles AS tt 
	ON ta.title_id = tt.title_id
	JOIN sales AS sl
	ON tt.title_id = sl.title_id
GROUP BY au.au_id
ORDER BY TOTAL DESC
LIMIT 3
;


-- Challenge 4 - Best Selling Authors Ranking
SELECT 	au.au_id AS "AUTHOR ID", 
		au.au_lname AS "LAST NAME", 
        au.au_fname AS "FIRST NAME",
		IFNULL(SUM(sl.qty), 0) AS TOTAL
FROM authors AS au
	JOIN titleauthor AS ta 	# El Join es idéntico a un Inner Join 
	ON au.au_id = ta.au_id
	JOIN titles AS tt 
	ON ta.title_id = tt.title_id
	JOIN sales AS sl
	ON tt.title_id = sl.title_id
GROUP BY au.au_id
ORDER BY TOTAL DESC
;


-- Bonus Challenge
SELECT 	Author_ID,
        authors.au_lname,
        authors.au_fname,
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
			ON titles.title_id = sales.title_id) as author_royalties
	
    GROUP BY Title_ID, Author_ID ) as author_royalties_agg
    	JOIN authors
		ON author_royalties_agg.Author_ID = authors.au_id
		JOIN titles
		ON author_royalties_agg.Title_id = titles.title_id
		JOIN titleauthor
		ON author_royalties_agg.Author_ID = titleauthor.au_id
    
GROUP BY Author_ID
ORDER BY Profits DESC
LIMIT 3;
