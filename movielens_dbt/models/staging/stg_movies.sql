WITH raw_movies AS (
    SELECT
         *
    FROM MOVIELENS.RAW.RAW_MOVIES
)

SELECT 
        movieId AS movie_id,
        title AS title,
        genres AS genres
FROM raw_movies