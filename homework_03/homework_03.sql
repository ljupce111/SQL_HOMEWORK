--Find all genres that have more than 3 movies with a rating of 'R'
SELECT g.name, COUNT(*) AS r_rated_count
FROM genres g
JOIN movie_genres mg ON g.genre_id = mg.genre_id
JOIN movies m ON mg.movie_id = m.movie_id
WHERE m.rating = 'R'
GROUP BY g.name
HAVING COUNT(*) > 3;
--Find directors who have made movies with total revenue over 500 million and have directed at least 2 movies
SELECT d.first_name || ' ' || d.last_name AS director_name,
       COUNT(m.movie_id) AS movie_count,
       SUM(mr.international_revenue) AS total_revenue
FROM directors d
JOIN movies m ON m.director_id = d.director_id
JOIN movie_revenues mr ON mr.movie_id = m.movie_id
GROUP BY d.first_name, d.last_name
HAVING COUNT(m.movie_id) >= 2 AND SUM(mr.international_revenue) > 500000000;
--Find actors who have appeared in more than 2 different genres and have won at least 1 award
SELECT a.first_name || ' ' || a.last_name AS actor,
       COUNT(DISTINCT g.genre_id) AS genre_count,
       COUNT(awa.award_id) AS award_count
FROM genres g
JOIN movie_genres mg ON g.genre_id = mg.genre_id
JOIN movies m ON m.movie_id = mg.movie_id
JOIN cast_members cm ON cm.movie_id = m.movie_id
JOIN actors a ON a.actor_id = cm.actor_id
JOIN actor_awards aw ON aw.actor_id = a.actor_id
JOIN awards awa ON awa.award_id = aw.award_id
GROUP BY a.first_name, a.last_name
HAVING COUNT(DISTINCT g.genre_id) > 2 AND COUNT(awa.award_id) > 0;
--Find movies that have received more than 3 reviews with an average rating above 7
SELECT m.title,
       COUNT(r.review_id) AS number_of_reviews,
       AVG(r.rating) AS average_rating
FROM movies m
JOIN reviews r ON r.movie_id = m.movie_id
GROUP BY m.title
HAVING COUNT(r.review_id) > 3 AND AVG(r.rating) > 7;
--Find production companies that have invested more than 100 million in movies released after 2015
SELECT pc.name, mpc.investment_amount
FROM movie_production_companies mpc
JOIN movies m ON m.movie_id = mpc.movie_id
JOIN production_companies pc ON pc.company_id = mpc.company_id
WHERE mpc.investment_amount >= 100000000 AND m.release_date >= '2015-01-01';
--Find countries where more than 2 movies were filmed with a total budget exceeding 150 million
SELECT ml.country, COUNT(m.movie_id) AS movies_filmed
FROM movie_locations ml
JOIN movies m ON m.movie_id = ml.movie_id
WHERE m.budget >= 150000000
GROUP BY ml.country
HAVING COUNT(m.movie_id) >= 2;
--Find genres where the average movie duration is over 120 minutes and at least one movie has won an Oscar
SELECT g.name,
       AVG(m.duration_minutes) AS average_duration,
       COUNT(CASE WHEN a.name = 'Oscar' THEN 1 END) AS oscar_wins
FROM genres g
JOIN movie_genres mg ON g.genre_id = mg.genre_id
JOIN movies m ON m.movie_id = mg.movie_id
JOIN movie_awards ma ON ma.movie_id = m.movie_id
JOIN awards a ON a.award_id = ma.award_id
GROUP BY g.name
HAVING AVG(m.duration_minutes) > 120 AND COUNT(CASE WHEN a.name = 'Oscar' THEN 1 END) > 0;
--Find years where more than 3 movies were released with an average budget over 50 million
SELECT EXTRACT(YEAR FROM m.release_date) AS year,
       COUNT(m.movie_id) AS movie_count,
       AVG(m.budget) AS avg_budget
FROM movies m
GROUP BY EXTRACT(YEAR FROM m.release_date)
HAVING COUNT(m.movie_id) > 3 AND AVG(m.budget) >= 50000000;
--Find actors who have played lead roles in more than 2 movies with a total revenue exceeding 200 million
SELECT a.first_name || ' ' || a.last_name AS actor,
       COUNT(*) AS lead_role_count,
       SUM(mr.international_revenue) AS total_revenue
FROM actors a
JOIN cast_members cm ON cm.actor_id = a.actor_id
JOIN movies m ON m.movie_id = cm.movie_id
JOIN movie_revenues mr ON mr.movie_id = m.movie_id
WHERE cm.is_lead_role = true
GROUP BY a.first_name, a.last_name
HAVING COUNT(*) > 2 AND SUM(mr.international_revenue) > 200000000;
--Create a view that shows top-rated movies. Include: movie title, average rating, review count, director name
CREATE OR REPLACE VIEW top_rated_movies AS
SELECT m.title,
       AVG(r.rating) AS average_rating,
       COUNT(r.review_id) AS review_count,
       d.first_name || ' ' || d.last_name AS director_name
FROM movies m
JOIN reviews r ON r.movie_id = m.movie_id
JOIN directors d ON m.director_id = d.director_id
GROUP BY m.title, d.first_name, d.last_name

SELECT * FROM top_rated_movies
--Create a view for movie financial performance. Include: movie title, budget,total revenue, profit, ROI
CREATE OR REPLACE VIEW movie_financial_performance AS
SELECT 
    m.title,
    m.budget,
    SUM(mr.domestic_revenue + mr.international_revenue) AS total_revenue,
	SUM(mr.domestic_revenue + mr.international_revenue) - SUM(mpc.investment_amount) as profit,
	((SUM(mr.domestic_revenue + mr.international_revenue) - SUM(mpc.investment_amount)) / SUM(mpc.investment_amount)) * 100 as ROI_percent
FROM movies m
JOIN movie_revenues mr ON mr.movie_id = m.movie_id
JOIN movie_production_companies mpc ON mpc.movie_id = m.movie_id
GROUP BY m.title, m.budget;

SELECT * FROM movie_financial_performance
--Create a view for actor filmography. Include: actor name, movie count, genre list, total revenue
CREATE OR REPLACE VIEW actor_filmography AS
SELECT a.first_name || ' ' || a.last_name as name,
		COUNT(DISTINCT cm.movie_id) AS number_of_movies,
		COUNT(DISTINCT mg.genre_id) AS number_of_genres,
		SUM(mr.domestic_revenue + mr.international_revenue) AS total_revenue
FROM actors a
JOIN cast_members cm ON cm.actor_id = a.actor_id
JOIN movies m ON m.movie_id = cm.movie_id
JOIN movie_genres mg ON mg.movie_id = m.movie_id
JOIN genres g ON g.genre_id = mg.genre_id
JOIN movie_revenues mr ON mr.movie_id = m.movie_id
GROUP BY a.first_name, a.last_name

SELECT * FROM actor_filmography
--Create a view for genre statistics. Include: genre name, movie count, average rating, total revenue
CREATE OR REPLACE VIEW genre_statistics AS
SELECT g.name,
		COUNT(m.movie_id) AS movie_count,
		 AVG(r.rating) AS average_rating,
		 SUM(mr.domestic_revenue + mr.international_revenue) AS total_revenue
FROM movie_genres mg
JOIN genres g ON mg.genre_id = g.genre_id
JOIN movies m ON m.movie_id = mg.movie_id
LEFT JOIN reviews r ON r.movie_id = m.movie_id
LEFT JOIN movie_revenues mr ON mr.movie_id = m.movie_id
GROUP BY g.name

SELECT * FROM genre_statistics
--Create a view for production company performance. Include: company name, movie count, total investment, total revenue
CREATE OR REPLACE VIEW production_company_performance AS
SELECT pc.name,
		COUNT(m.movie_id) as movie_count,
		SUM(mpc.investment_amount) as total_investment,
		SUM(mr.domestic_revenue + mr.international_revenue) AS total_revenue
FROM production_companies pc
JOIN movie_production_companies mpc ON mpc.company_id = pc.company_id
JOIN movies m ON m.movie_id = mpc.movie_id
JOIN movie_revenues mr ON mr.movie_id = m.movie_id
GROUP BY pc.name




