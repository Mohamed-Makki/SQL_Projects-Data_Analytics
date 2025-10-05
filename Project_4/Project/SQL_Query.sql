/* 
  The first step we will take in this project
  after uploading the data is to link the tables together.
*/

ALTER TABLE album
ADD CONSTRAINT FK_album
FOREIGN KEY(artist_id)
REFERENCES artist(artist_id);

ALTER TABLE track
ADD CONSTRAINT FK_track_album
FOREIGN KEY(album_id)
REFERENCES album(album_id);

ALTER TABLE track
ADD CONSTRAINT FK_track_medi_type
FOREIGN KEY(media_type_id)
REFERENCES media_type(media_type_id);

ALTER TABLE track
ADD CONSTRAINT FK_track_genre
FOREIGN KEY(genre_id)
REFERENCES genre(genre_id);

ALTER TABLE playlist_track
ADD CONSTRAINT FK_playlist_track_track
FOREIGN KEY(track_id)
REFERENCES track(track_id);

ALTER TABLE playlist_track
ADD CONSTRAINT FK_playlist_track_playlist
FOREIGN KEY(playlist_id)
REFERENCES playlist(playlist_id);

ALTER TABLE invoice_line
ADD CONSTRAINT FK_invoiceline_track
FOREIGN KEY(track_id)
REFERENCES track(track_id);

ALTER TABLE invoice_line
ADD CONSTRAINT FK_invoiceline_invoice
FOREIGN KEY(invoice_id)
REFERENCES invoice(invoice_id);

ALTER TABLE invoice
ADD CONSTRAINT FK_invoice_customer
FOREIGN KEY(customer_id)
REFERENCES cust omer(customer_id);


SELECT * FROM album
SELECT * FROM artist
SELECT * FROM track
SELECT * FROM invoice
SELECT * FROM customer
SELECT * FROM genre
SELECT * FROM invoice_line
SELECT * FROM employee
SELECT * FROM media_type
SELECT * FROM playlist
SELECT * FROM playlist_track


-- EASY QUESTIONS

/* 1- who is the senior most employee based on job title? */

SELECT * FROM employee
ORDER BY levels desc
LIMIT 1

/* 2- which country have the most invoices? */

SELECT COUNT(*) AS C, billing_country
FROM invoice
GROUP BY 2
ORDER BY C DESC
LIMIT 1

/* 3- what are the top 3 values of total inovices? */

SELECT * FROM invoice
ORDER BY total DESC
LIMIT 3

/* 4- which city has the best coustomers? 
we would like to throw apromotional music
festival in the city we made the moat money. 
write query that returns one city that has
the highest sum of invoice totals. 
*/

SELECT billing_country, SUM(total) AS sum_all_invoices
FROM invoice
GROUP BY 1
ORDER BY sum_all_invoices DESC
LIMIT 1

/* 5- who is the best customer?
the customer who has spent the most
money will be declaredthe beat customer.
write a querythat reutrns the person who spent the most money.
*/

SELECT 
	customer.customer_id, 
	customer.first_name, 
	customer.last_name,
	SUM(invoice.total) AS money
FROM customer
JOIN invoice
ON customer.customer_id = invoice.customer_id
GROUP BY 1
ORDER BY money DESC
LIMIT 1

-- MODERATE QUESTIONS

/* 
6- wrtie query to return the email,
first name, last name,
and genre of all rock music listners.
return your list ordered alphabetically
by email starting with A?
*/

SELECT 
	DISTINCT(cs.email),
	cs.first_name,
	cs.last_name
FROM customer AS cs
JOIN invoice AS inv
ON cs.customer_id = inv.customer_id
JOIN invoice_line AS inl
ON inl.invoice_id = inv.invoice_id
JOIN track AS tk
ON inl.track_id = tk.track_id
JOIN genre AS gen
ON tk.genre_id = gen.genre_id
where gen.name like 'Rock'
ORDER BY email

/* 
7- let`s invite the artist who have written the most
rock music in our data set. write a query that returns the
artist and the totaltrack count of top 10 rock bands
*/

SELECT 
	art.artist_id, 
	art.name,
	COUNT(art.artist_id) AS number_of_songs
FROM artist AS art
JOIN album AS al
ON al.artist_id = art.artist_id
JOIN track AS tk
ON tk.album_id = al.album_id
JOIN genre AS gen
ON gen.genre_id = tk.genre_id
where gen.name like 'Rock'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10

/* 
8- return the name and milliseconds for each track.
oreder by the song length with the longest songs listed first.
*/

SELECT 
	name,
	milliseconds
FROM track
where milliseconds > (
					  SELECT 
					  	AVG(milliseconds) AS Average_milliseconds
					  FROM track 
                     )
ORDER BY 2 DESC


-- ADVANCE QUESTIONS

/* 
9- find how much amount spent by each customer on artist?
write a query to return customer name,
artist name and total spent?
*/

SELECT
	cs.customer_id,
	cs.first_name,
	cs.last_name,
	art.name,
	SUM(inl.unit_price * inl.quantity)
FROM customer AS cs
JOIN invoice AS inv
ON inv.customer_id = cs.customer_id
JOIN invoice_line AS inl
ON inl.invoice_id = inv.invoice_id
JOIN track AS tk
ON inl.track_id = tk.track_id
JOIN album AS al
ON al.album_id = tk.album_id
JOIN artist AS art
ON al.artist_id = art.artist_id
GROUP BY 1, 4
ORDER BY 5 DESC


/* 
10- find out the most opular music genre for each country,
we determine the most popular genre as the genre with the highest amount of purchase,
write a query that returns each country alon with the top genre, for countries where rhe maxinmum num of purchase.
*/

WITH popular_genre AS 
(

	SELECT 
		COUNT(inl.quantity) AS purchases,
		cs.country,
		gen.name,
		gen.genre_id,
		ROW_NUMBER() OVER(PARTITION BY cs.country ORDER BY COUNT(inl.quantity) DESC) AS RowNum
	FROM customer AS cs
		JOIN invoice AS inv
		ON inv.customer_id = cs.customer_id
		JOIN invoice_line AS inl
		ON inl.invoice_id = inv.invoice_id
		JOIN track AS tk
		ON inl.track_id = tk.track_id
		JOIN genre AS gen
		ON gen.genre_id = tK.genre_id
		GROUP BY 2, 3, 4
		ORDER BY 2, 1 DESC
)

SELECT * FROM popular_genre 
where RowNum = 1

/* 
11- write  query that determines the customer that has spent the most
on music for each country. write a query that returns the countey along
with the top amount spent is shared, provide all customers who spent the amount.
*/

WITH customer_with_country AS 
   (
	SELECT
		cs.customer_id,
		cs.first_name,
		cs.last_name,
		inv.billing_country,
		SUM(inv.total) AS total_spending,
		ROW_NUMBER() OVER(PARTITION BY inv.billing_country ORDER BY SUM(inv.total) DESC) AS RowNum
	FROM customer AS cs
		JOIN invoice AS inv
		ON inv.customer_id = cs.customer_id
	GROUP BY 1, 4
	ORDER BY 4, 5 DESC
)

SELECT * FROM customer_with_country
WHERE RowNum = 1
