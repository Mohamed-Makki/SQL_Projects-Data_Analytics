-- Advanced SQL Project -- Spotify Datasets

-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-- EDA
SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT MAX(duration_min) FROM spotify;
SELECT AVG(duration_min) FROM spotify;
SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify
WHERE duration_min = 0

DELETE FROM spotify
WHERE duration_min = 0
SELECT * FROM spotify
WHERE duration_min = 0

SELECT DISTINCT channel FROM spotify;

SELECT DISTINCT most_played_on FROM spotify;



-- -----------------------------
-- Data Analysis -Easy Category
-- -----------------------------

/*
### Easy Level

1. Retrieve the names of all tracks that have more than 1 billion streams.
2. List all albums along with their respective artists.
3. Get the total number of comments for tracks where `licensed = TRUE`.
4. Find all tracks that belong to the album type `single`.
5. Count the total number of tracks by each artist.

*/

-- Q.1 Retrieve the names of all tracks that have more than 1 billion streams.

SELECT track FROM spotify
WHERE stream > 1000000000

-- Q.2 List all albums along with their respective artists.

SELECT
	DISTINCT album, artist
FROM spotify
ORDER BY 1

-- Q.3 Get the total number of comments for tracks where `licensed = TRUE`.

SELECT
	SUM(comments) AS total
FROM spotify
WHERE licensed = 'true'

-- Q.4 Find all tracks that belong to the album type `single`.

SELECT * FROM spotify
WHERE album_type LIKE 'single'

-- Q.5 Count the total number of tracks by each artist.

SELECT 
	artist,
	COUNT(*) AS total_num_songs
FROM spotify
GROUP BY 1
ORDER BY 2 DESC

/*
### Medium Level

6. Calculate the average danceability of tracks in each album.
7. Find the top 5 tracks with the highest energy values.
8. List all tracks along with their views and likes where `official_video = TRUE`.
9. For each album, calculate the total views of all associated tracks.
10. Retrieve the track names that have been streamed on Spotify more than YouTube.

*/


-- Q.6 Calculate the average danceability of tracks in each album.

SELECT
	album,
	AVG(danceability) AS AVG_danceability
FROM spotify
GROUP BY 1
ORDER BY 2

-- Q.7 Find the top 5 tracks with the highest energy values.

SELECT
	track,
	MAX(energy) AS MAX_energy
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q.8 List all tracks along with their views and likes where `official_video = TRUE`.

SELECT
	track,
	SUM(views) AS SUM_views,
	SUM(likes) AS SUM_likes
FROM spotify
WHERE official_video = 'TRUE'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q.9 For each album, calculate the total views of all associated tracks.

SELECT
	album,
	track,
	SUM(views)
FROM spotify
GROUP BY 1, 2
ORDER BY 3 DESC

-- Q.10 Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * FROM
(
SELECT
	track,
	COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS streamed_on_YouTube,
	COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS streamed_on_Spotify
FROM spotify
GROUP BY 1
) AS T1
WHERE
	streamed_on_Spotify > streamed_on_YouTube
	AND
	streamed_on_YouTube <> 0

/*
### Advanced Level

1. Find the top 3 most-viewed tracks for each artist using window functions.
2. Write a query to find tracks where the liveness score is above the average.
3. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
4. Find tracks where the energy-to-liveness ratio is greater than 1.2.
5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
*/

-- Q.11 Find the top 3 most-viewed tracks for each artist using window functions.

-- each artists and total view for each track
-- track with jight view for each artist (we need top)
-- dense rank
-- cte and filder rank <= 3

WITH ranking_artist
AS
(SELECT
	artist,
	track,
	SUM(views),
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
FROM spotify
GROUP BY 1, 2
ORDER BY 1, 3 DESC
)
SELECT * FROM ranking_artist
WHERE rank <= 3

-- Q.12 Write a query to find tracks where the liveness score is above the average.

-- SELECT AVG(liveness) FROM spotify == 0.19

SELECT
	track,
	artist,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)

-- Q.13 **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**

WITH CTE
AS
(SELECT
	artist,
	MAX(energy) AS MAX_energy,
	MIN(energy) AS MIN_energy
FROM spotify
GROUP BY 1
)
SELECT
	artist,
	MAX_energy - MIN_energy AS diff_energy
FROM CTE
ORDER BY 2 DESC

-- Q.14 Find tracks where the energy-to-liveness ratio is greater than 1.2.

SELECT
	*
FROM spotify
WHERE 
	energy_liveness > 1.2

-- Q.15 Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

SELECT
	track,
	views,
	likes,
	SUM(likes) OVER(ORDER BY views DESC) AS cumulative_likes
FROM spotify
ORDER BY views DESC
