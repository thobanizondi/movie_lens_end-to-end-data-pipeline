virtualenv venv
venv\Scripts\activate
pip install dbt_snowflake
dbt init movielens_dbt
cd movielens_dbt