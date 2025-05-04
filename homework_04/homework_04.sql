--Get movies by rating (table-valued function)
CREATE OR REPLACE FUNCTION get_movies_by_rating(rating_param TEXT)
RETURNS TABLE (
    movie_id INT,
    title character varying,
    rating mpaa_rating
) 
AS 
$$
BEGIN
    RETURN QUERY
    SELECT m.movie_id, m.title, m.rating
    FROM movies m
    WHERE m.rating = rating_param::mpaa_rating;
END;
$$ 
LANGUAGE plpgsql;

SELECT * FROM get_movies_by_rating('PGs')
--Get director's filmography (table-valued function)
CREATE OR REPLACE FUNCTION get_director_filmography(director_id_param INT)
RETURNS TABLE (
    movie_id INT,
    title character varying
) 
AS 
$$
BEGIN
    RETURN QUERY
    SELECT 
        m.movie_id, 
        m.title
    FROM movies m
    WHERE m.director_id = director_id_param;
END;
$$ 
LANGUAGE plpgsql;

SELECT * FROM get_director_filmography(3)

--Calculate actor's age
CREATE OR REPLACE FUNCTION calculate_age_from_birth(birth_date DATE)
RETURNS INT
AS
$$
BEGIN
	RETURN DATE_PART('year', AGE(CURRENT_DATE, birth_date))::INT;
END;
$$
LANGUAGE plpgsql;
		--create a view using the function
CREATE OR REPLACE VIEW get_actor_details AS
SELECT
	first_name,
	last_name,
	birth_date,
	calculate_age_from_birth(birth_date) as age
FROM actors

SELECT * FROM get_actor_details

--Check if actor has won awards
CREATE OR REPLACE FUNCTION has_won_awards(award_id INT)
RETURNS TEXT
AS
$$
BEGIN
    IF award_id IS NOT NULL THEN
        RETURN 'Actor has won an award';
    ELSE
        RETURN 'Actor has not won any awards';
    END IF;
END;
$$
LANGUAGE plpgsql;
		--create a view
CREATE OR REPLACE VIEW check_actor_awards As
SELECT
	a.first_name,
	a.last_name,
	has_won_awards(aa.award_id)
FROM actors a
LEFT JOIN actor_awards aa ON aa.actor_id = a.actor_id


SELECT * FROM check_actor_awards






