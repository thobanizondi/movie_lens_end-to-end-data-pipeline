WITH stg_movies AS (
    SELECT
         *
    FROM {{ ref('stg_movies') }}
)

SELECT
     movie_id,
     INITCAP(TRIM(title)) AS movie_title,
     SPLIT(genres, '|') AS movie_array_genres,
     genres AS movie_genres
FROM stg_movies