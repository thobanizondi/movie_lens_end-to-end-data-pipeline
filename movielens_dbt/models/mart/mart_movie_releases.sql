{{ config(materialized='table') }}
WITH fact_ratings AS (
    SELECT * FROM {{ ref('fact_ratings') }}
),

seed_dates AS (
    SELECT * FROM {{ ref('seed_movie_release_dates') }}
)
SELECT
    r.*,
    CASE
        WHEN d.release_date IS NULL THEN 'Unknown'
        ELSE 'Known'
    END AS release_info_available
FROM fact_ratings r
LEFT JOIN seed_dates d ON r.movie_id = d.movie_id