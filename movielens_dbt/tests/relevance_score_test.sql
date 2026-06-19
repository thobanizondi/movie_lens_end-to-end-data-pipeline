SELECT
     *
FROM {{ref('fact_genome_scores')}}
WHERE relevance <= 0