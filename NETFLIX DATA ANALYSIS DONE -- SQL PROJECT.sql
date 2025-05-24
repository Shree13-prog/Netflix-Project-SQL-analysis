select * from netflix


--Q.1 Content type distribution (Movies vs TV Shows)
SELECT type, COUNT(show_id) AS total
FROM netflix
GROUP BY type;


-- Q.2 Most common genres on Netflix
SELECT TRIM(genre) AS genre, COUNT(*) AS total
FROM (
  SELECT show_id, TRIM(value) AS genre
  FROM netflix, UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS value
) AS genre_table
GROUP BY genre
ORDER BY total DESC;


-- Q3. Top 5 countries with most content
SELECT country, COUNT(show_id) AS total_titles
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_titles DESC
LIMIT 5;


--Q.4 What type of content (Movie or TV Show) is more popular by country?
SELECT country, type, COUNT(*) AS total
FROM netflix
WHERE country IS NOT NULL
GROUP BY country, type
ORDER BY country, total DESC;


-- Q.5  Growth of Indian content year-wise
SELECT release_year, COUNT(*) AS total_titles
FROM netflix
WHERE country LIKE '%India%'
GROUP BY release_year
ORDER BY release_year;

-- Q.7 Top 10 most frequent directors
SELECT director, COUNT(*) AS total_titles
FROM netflix
WHERE director IS NOT NULL
GROUP BY director
ORDER BY total_titles DESC
LIMIT 10;


--Q.8 Categorize content as 'Good' or 'Bad' based on description keywords
SELECT 
  CASE 
    WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
    ELSE 'Good'
  END AS category,
  COUNT(*) AS total
FROM netflix
GROUP BY category;


--Q.9 What months does Netflix add the most content?
SELECT TO_CHAR(TO_DATE(date_added, 'Month DD, YYYY'), 'Month') AS month_name,
       COUNT(*) AS total_added
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY month_name
ORDER BY total_added DESC;

--Q.10 Which genres are more favored in different countries? 
SELECT country, genre, total
FROM (
  SELECT country, TRIM(genre) AS genre, COUNT(*) AS total,
         ROW_NUMBER() OVER (PARTITION BY country ORDER BY COUNT(*) DESC) AS rn
  FROM (
    SELECT country, UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
    FROM netflix
    WHERE country IS NOT NULL
  ) AS genre_data
  GROUP BY country, genre
) ranked_genres
WHERE rn = 1;

