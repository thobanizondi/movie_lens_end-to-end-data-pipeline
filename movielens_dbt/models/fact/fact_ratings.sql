{{
    config(
        materialized='incremental',
        unique_key='rating_id'
    )
}}

WITH stg_ratings AS (
    SELECT * FROM {{ ref('stg_ratings') }}
)

SELECT
    MD5(CONCAT(
        CAST(user_id AS VARCHAR), '-',
        CAST(movie_id AS VARCHAR), '-',
        CAST(rating_timestamp AS VARCHAR)
    )) AS rating_id,
    user_id,
    movie_id,
    rating,
    rating_timestamp
FROM stg_ratings

{% if is_incremental() %}
WHERE rating_timestamp > (SELECT MAX(rating_timestamp) FROM {{ this }})
{% endif %}
