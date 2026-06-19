{% macro no_null_in_columns(model) %}
    SELECT * FROM {{ model }} WHERE 
    {% for col in adapter.dbt_utils.dbt_utils.default__get_filtered_columns_in_relation(model) %}
         {{ col.column  }} IS NULL OR   
    {% endfor %} 
     FALSE
{% endmacro %}