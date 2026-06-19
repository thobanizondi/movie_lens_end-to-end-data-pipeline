WITH stg_genome_tags AS (
    SELECT
         *
    FROM {{ ref('stg_genome_tags') }}
)
SELECT
     tag_id,
     INITCAP(TRIM(tag)) AS tag
FROM stg_genome_tags