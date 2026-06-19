WITH raw_ratings AS (
    SELECT * FROM {{ source('raw', 'RAW_RATINGS') }}
)

SELECT
    USERID                       AS user_id,
    MOVIEID                      AS movie_id,
    RATING                       AS rating,
    TO_TIMESTAMP(TIMESTAMP)      AS rating_timestamp
FROM raw_ratings
