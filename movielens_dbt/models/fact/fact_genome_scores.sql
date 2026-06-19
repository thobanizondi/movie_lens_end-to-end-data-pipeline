WITH stg_genome_scores AS (
    SELECT
         *
    FROM {{ ref('stg_genome_scores') }}
)

SELECT
     movie_id,
     tag_id,
     ROUND(relevance, 4) AS relevance
FROM stg_genome_scores
WHERE relevance > 0