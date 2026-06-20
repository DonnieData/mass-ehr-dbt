-- Transform raw encounters into incremental model
-- --select transform_encounters

{{ config(
    materialized='incremental',
    schema='massachusetts_ehr',
    alias='encounters',
    incremental_strategy='append',
    on_schema_change='append_new_columns'
) }}

select 
* 
from {{ source('massachusetts_ehr', 'ENCOUNTERS') }}