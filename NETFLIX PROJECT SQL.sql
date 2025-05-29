select * from netflix

--Q.1 Content type distribution (Movies vs TV Shows)
SELECT type, COUNT(show_id) AS total
FROM netflix
GROUP BY type;

-- Q.2 5 Most Common Genres on Netflix
SELECT 
  TRIM(genre) AS genre, 
  COUNT(*) AS total
FROM (
  SELECT 
    show_id, 
    TRIM(value) AS genre
  FROM netflix, 
  UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS value
) AS genre_table
GROUP BY genre
ORDER BY total DESC
LIMIT 5;

-- Q3. Top 5 countries with most content
SELECT country, COUNT(show_id) AS total_titles
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_titles DESC
LIMIT 5;

-- Q.4  Growth of Indian content year-wise
SELECT release_year, COUNT(*) AS total_titles
FROM netflix
WHERE country LIKE '%India%'
GROUP BY release_year
ORDER BY release_year;

--Q.5 Top 10 most frequent directors
SELECT director, COUNT(*) AS total_titles
FROM netflix
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total_titles DESC
LIMIT 10;

--Q.6 Categorize content as 'Good' or 'Bad' based on description keywords
SELECT 
  CASE 
    WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
    ELSE 'Good'
  END AS category,
  COUNT(*) AS total
FROM netflix
GROUP BY category;

--Q.7 What months does Netflix add the most content?
SELECT TO_CHAR(TO_DATE(date_added, 'Month DD, YYYY'), 'Month') AS month_name,
       COUNT(*) AS total_added
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY month_name
ORDER BY total_added DESC;

--Q.8 Which genres are more favored in India? 
SELECT 
  'India' AS country,
  TRIM(genre) AS top_genre,
  COUNT(*) AS total_titles
FROM (
  SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
  FROM netflix
  WHERE 
    country LIKE '%India%'
    AND country IS NOT NULL
) AS indian_genres
GROUP BY TRIM(genre)
ORDER BY total_titles DESC
LIMIT 1;

