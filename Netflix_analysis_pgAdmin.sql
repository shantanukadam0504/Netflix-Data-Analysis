-- =====================================================
-- NETFLIX DATA ANALYSIS
-- SQL Analysis Project
-- =====================================================


-- =====================================================
-- CREATE NETFLIX TABLE
-- =====================================================


CREATE TABLE netflix_titles (
    show_id VARCHAR(10),
    type VARCHAR(20),
    title VARCHAR(255),
    director TEXT,
    "cast" TEXT,
    country TEXT,
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(30),
    duration VARCHAR(30),
    listed_in TEXT,
    description TEXT
);


-- Check total number of records
SELECT COUNT(*) AS total_titles
FROM netflix_titles;


-- 1. Count Movies vs TV Shows
SELECT
    type,
    COUNT(*) AS total_titles
FROM netflix_titles
GROUP BY type
ORDER BY total_titles DESC;

-- 2. Number of Netflix titles by release year
SELECT
    release_year,
    COUNT(*) AS total_titles
FROM netflix_titles
GROUP BY release_year
ORDER BY release_year;

-- 3. Number of Netflix titles by rating
SELECT
    rating,
    COUNT(*) AS total_titles
FROM netflix_titles
GROUP BY rating
ORDER BY total_titles DESC;

-- 4. Top 10 countries by number of Netflix titles
-- Split multiple countries and count each country separately

SELECT
    TRIM(country_name) AS country,
    COUNT(*) AS total_titles
FROM netflix_titles
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(country, ',')) AS country_name
WHERE country IS NOT NULL
  AND TRIM(country_name) <> 'Not Listed'
GROUP BY TRIM(country_name)
ORDER BY total_titles DESC
LIMIT 10;


-- 5. Top 10 Netflix genres
-- Split multiple genres and count each genre separately

SELECT
    TRIM(genre_name) AS genre,
    COUNT(*) AS total_titles
FROM netflix_titles
CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre_name
WHERE listed_in IS NOT NULL
GROUP BY TRIM(genre_name)
ORDER BY total_titles DESC
LIMIT 10;


-- 6. Movie duration analysis

SELECT
    ROUND(AVG(CAST(SPLIT_PART(duration, ' ', 1) AS NUMERIC)), 2)
        AS average_movie_duration,
    MIN(CAST(SPLIT_PART(duration, ' ', 1) AS NUMERIC))
        AS shortest_movie,
    MAX(CAST(SPLIT_PART(duration, ' ', 1) AS NUMERIC))
        AS longest_movie
FROM netflix_titles
WHERE type = 'Movie'
  AND duration IS NOT NULL;


-- 7. TV Show season analysis

SELECT
    ROUND(AVG(CAST(SPLIT_PART(duration, ' ', 1) AS NUMERIC)), 2)
        AS average_seasons,
    MIN(CAST(SPLIT_PART(duration, ' ', 1) AS NUMERIC))
        AS minimum_seasons,
    MAX(CAST(SPLIT_PART(duration, ' ', 1) AS NUMERIC))
        AS maximum_seasons
FROM netflix_titles
WHERE type = 'TV Show'
  AND duration IS NOT NULL;


-- 8. Netflix titles added by year

SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year_added,
    COUNT(*) AS total_titles
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added;


-- 9. Movies vs TV Shows added by year

SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year_added,
    COUNT(*) FILTER (WHERE type = 'Movie') AS movies_added,
    COUNT(*) FILTER (WHERE type = 'TV Show') AS tv_shows_added
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added;


