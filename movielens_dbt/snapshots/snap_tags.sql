{% snapshot snap_tags %}

{{
    config(
        unique_key='row_key',
        strategy='timestamp',
        updated_at='timestamp',
        invalidate_hard_deletes=True,
        target_schema='SNAPSHOTS'
    )
}}

SELECT
    MD5(CONCAT(
        CAST(user_id AS VARCHAR), '-',
        CAST(movie_id AS VARCHAR), '-',
        tag
    ))                                   AS row_key,
    user_id,
    movie_id,
    tag,
    CAST(timestamp AS TIMESTAMP_NTZ) AS timestamp
FROM {{ ref('stg_tags') }}
LIMIT 100

{% endsnapshot %}
