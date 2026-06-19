-- -- select 

{{ config(
    materialized='incremental',
    schema='MASSACHUSETTS_EHR',
    alias='encounters',
    incremental_strategy='append',
    on_schema_change='append_new_columns'
) }}

select 
* 
from {{ source('massachusetts_ehr', 'ENCOUNTERS') }}