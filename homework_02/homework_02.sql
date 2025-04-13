--Find all movies released in 2019
SELECT title as movies_released_in_2019
FROM movies
WHERE release_date > '2019-01-01' AND release_date < '2020-01-01'
--Find all actors from 'British' nationality
SELECT first_name || ' ' || last_name as British_Actors
FROM actors 
WHERE nationality = 'British' 
--Find all movies with 'PG-13' rating
SELECT title as movies_rated_PG_13
FROM movies
Where rating = 'PG-13'
--Find all directors from 'American' nationality
SELECT first_name || ' ' || last_name as american_directors
FROM directors
WHERE nationality = 'American'
--Find all movies with duration more than 150 minutes
SELECT title as longer_movies
FROM movies
WHERE duration_minutes > 150
--Find all actors with last name 'Pitt'
SELECT first_name || ' ' || last_name as last_name_pitt
FROM actors
Where last_name = 'Pitt'
-- Find all movies with budget greater than 100 million
SELECT title as budget_greater_then_100mil
FROM movies
Where budget > 100000000
--Find all reviews with rating 5
SELECT rating, review_text
FROM reviews
WHERE rating = 5
--Find all movies in English language
SELECT title as movies_in_english
FROM movies
WHERE language = 'English'
--Find all production companies from 'California'
SELECT name as compaines_in_california
FROM production_companies
Where headquarters ILIKE '%California%'
--Show actors and their movies
SELECT a.first_name, movies.title
FROM actors a
JOIN cast_members cm ON a.actor_id = cm.actor_id
JOIN movies ON cm.movie_id = movies.movie_id
--Show movies and their genres
SELECT m.title, g.name
FROM genres g
JOIN movie_genres mg ON g.genre_id = mg.genre_id
JOIN movies m ON mg.movie_id = m.movie_id;
--Show users and their reviews
SELECT u.username, r.review_text
FROM users u
JOIN reviews r ON u.user_id = r.user_id
--Show movies and their locations
SELECT m.title, ml.city
FROM movies m
JOIN movie_locations ml ON m.movie_id = ml.movie_id 
--Show movies and their production companies
SELECT m.title, pc.name
FROM movies m
JOIN movie_production_companies mpc ON m.movie_id = mpc.movie_id 
JOIN production_companies pc ON pc.company_id = mpc.company_id
--Show actors and their awards
SELECT a.first_name || ' ' || a.last_name as actor, awards.name
FROM actors a
JOIN actor_awards aw ON a.actor_id = aw.actor_id
JOIN awards ON awards.award_id = aw.award_id
--Show movies and their awards
SELECT m.title, awards.name
FROM movies m
JOIN movie_awards ma ON ma.movie_id = m.movie_id
JOIN awards ON ma.award_id = awards.award_id
--Show users and their watchlist movies
SELECT u.username, m.title
FROM users u
JOIN user_watchlist uw ON u.user_id = uw.user_id
JOIN movies m ON m.movie_id = uw.movie_id
--Show movies and their revenues
SELECT m.title, mr.domestic_revenue, mr.international_revenue
FROM movies m
JOIN movie_revenues mr ON m.movie_id = mr.movie_id
--Show all R-rated movies and their directors
SELECT m.title, m.rating, d.first_name
FROM movies m
JOIN directors d ON d.director_id = m.director_id
--Show all movies from 2019 and their genres
SELECT m.title , g.name
FROM movies m
JOIN movie_genres mg ON mg.movie_id = m.movie_id
JOIN genres g ON g.genre_id = mg.genre_id
WHERE release_date > '2019-01-01' AND release_date < '2020-01-01'
--Show all American actors and their movies
SELECT a.first_name || ' ' || a.last_name as american_actors, m.title
FROM actors a 
JOIN cast_members cm ON cm.actor_id = a.actor_id
JOIN movies m ON m.movie_id = cm.movie_id
WHERE a.nationality='American'
--Show all movies with budget over 100M and their production companies
SELECT m.title as budget_over_100mil, pc.name 
FROM movies m
JOIN movie_production_companies mpc ON m.movie_id = mpc.movie_id
JOIN production_companies pc ON pc.company_id = mpc.company_id
WHERE m.budget > 100000000
--Show all movies filmed in 'London' and their directors
SELECT m.title, ml.city
FROM movies m
JOIN movie_locations ml ON ml.movie_id = m.movie_id 
WHERE ml.city = 'London'
--Show all horror movies and their actors
SELECT m.title, g.name, a.first_name
FROM movies m
JOIN movie_genres mg ON mg.movie_id = m.movie_id
JOIN genres g ON g.genre_id = mg.genre_id
JOIN cast_members cm ON cm.movie_id = m.movie_id
JOIN actors a ON a.actor_id = cm.actor_id
WHERE g.name = 'Horror'
--Show all movies with reviews rated 5 and their reviewers
SELECT r.rating, r.rating, u.username
FROM reviews r
JOIN movies m ON m.movie_id = r.movie_id
JOIN users u ON u.user_id = r.user_id
WHERE r.rating = 5
--Show all British directors and their movies
SELECT d.first_name || ' ' || D.last_name as director , m.title
FROM directors d
JOIN movies m ON m.director_id = d.director_id
WHERE d.nationality = 'British'
--Show all movies longer than 180 minutes and their genres
SELECT m.title, g.name
FROM movies m
JOIN movie_genres mg ON mg.movie_id = m.movie_id
JOIN genres g ON g.genre_id = mg.genre_id
WHERE m.duration_minutes > 180
--Show all Oscar-winning movies and their directors
SELECT m.title as oscar_winning_movies, d.First_name as director
FROM movies m
JOIN movie_awards ma ON ma.movie_id = m.movie_id
JOIN awards a ON a.award_id = ma.award_id
JOIN directors d ON d.director_id = m.director_id
WHERE a.name = 'Oscar'




SELECT * FROM movies
