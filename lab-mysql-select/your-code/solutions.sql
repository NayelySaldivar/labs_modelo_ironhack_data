-- Select database
USE publications;

-- Challenge 1
SELECT 	au.au_id AS "AUTHOR ID", 
		au.au_lname AS "LAST NAME", 
        au.au_fname AS "FIRST NAME",
        tt.title AS TITLE,
        pb.pub_name AS PUBLISHER
FROM authors AS au
JOIN titleauthor as ta 	# El Join es idéntico a un Inner Join 
		ON au.au_id = ta.au_id
JOIN titles as tt 
		ON ta.title_id = tt.title_id
JOIN publishers as pb
		ON tt.pub_id = pb.pub_id
ORDER BY au.au_id 
;

# Checking number of records on Table titleauthor = 25
SELECT COUNT(*)
FROM titleauthor
;

# Checking number of results in the query = 25
SELECT COUNT(*)
FROM (
SELECT 	au.au_id AS "AUTHOR ID", 
		au.au_lname AS "LAST NAME", 
        au.au_fname AS "FIRST NAME",
        tt.title AS TITLE,
        pb.pub_name AS PUBLISHER
FROM authors AS au
JOIN titleauthor as ta 
		ON au.au_id = ta.au_id
JOIN titles as tt 
		ON ta.title_id = tt.title_id
JOIN publishers as pb
		ON tt.pub_id = pb.pub_id) as table2
        ;
        
# Nuestros queries coinciden en número de filas, por lo que probablemente están bien.

-- Challenge 2
SELECT 	au.au_id AS "AUTHOR ID", 
		au.au_lname AS "LAST NAME", 
        au.au_fname AS "FIRST NAME",
        pb.pub_name AS PUBLISHER,
        COUNT(au.au_id) as "TITLE COUNT"
FROM authors AS au
JOIN titleauthor as ta 	# El Join es idéntico a un Inner Join 
		ON au.au_id = ta.au_id
JOIN titles as tt 
		ON ta.title_id = tt.title_id
JOIN publishers as pb
		ON tt.pub_id = pb.pub_id
GROUP BY au.au_id, pb.pub_name
ORDER BY au.au_id DESC 
;

# Suming "Title Count" column to see if it equals number of records in Table titleauthor
SELECT SUM(TITLE_COUNT)
FROM (
SELECT 	au.au_id AS "AUTHOR ID", 
		au.au_lname AS "LAST NAME", 
        au.au_fname AS "FIRST NAME",
        pb.pub_name AS PUBLISHER,
        COUNT(au.au_id) as TITLE_COUNT
FROM authors AS au
JOIN titleauthor as ta 	# El Join es idéntico a un Inner Join 
		ON au.au_id = ta.au_id
JOIN titles as tt 
		ON ta.title_id = tt.title_id
JOIN publishers as pb
		ON tt.pub_id = pb.pub_id
GROUP BY au.au_id, pb.pub_name
ORDER BY au.au_id DESC ) as table1
;

# Indeed, the number of records equals the number of records in tableauthor

-- Challenge 3
SELECT 	au.au_id AS "AUTHOR ID", 
		au.au_lname AS "LAST NAME", 
        au.au_fname AS "FIRST NAME",
		SUM(sl.qty) AS TOTAL
FROM authors AS au
JOIN titleauthor as ta 	# El Join es idéntico a un Inner Join 
		ON au.au_id = ta.au_id
JOIN titles as tt 
		ON ta.title_id = tt.title_id
JOIN sales as sl
		ON tt.title_id = sl.title_id
GROUP BY au.au_id
ORDER BY TOTAL DESC
LIMIT 3
;


-- Challenge 4
SELECT 	au.au_id AS "AUTHOR ID", 
		au.au_lname AS "LAST NAME", 
        au.au_fname AS "FIRST NAME",
		IFNULL(SUM(sl.qty), 0) AS TOTAL
FROM authors AS au
JOIN titleauthor as ta 	# El Join es idéntico a un Inner Join 
		ON au.au_id = ta.au_id
JOIN titles as tt 
		ON ta.title_id = tt.title_id
JOIN sales as sl
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
			ON titles.title_id = sales.title_id) as royalties_1
	GROUP BY Title_ID, Author_ID ) as royalties_2
JOIN authors
	ON royalties_2.Author_ID = authors.au_id
JOIN titles
	ON royalties_2.Title_id = titles.title_id
JOIN titleauthor
	ON royalties_2.Author_ID = titleauthor.au_id
GROUP BY Author_ID
ORDER BY Profits DESC
LIMIT 3;
