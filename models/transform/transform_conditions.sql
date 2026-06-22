-- --select transform_conditions

{{ config(
    materialized='incremental',
    schema='massachusetts_ehr',
    alias='conditions',
    incremental_strategy='append',
    on_schema_change='append_new_columns'
) }}

select 
   "START"::TIMESTAMP_NTZ AS "START",
    "STOP"::TIMESTAMP_NTZ AS "STOP",
    PATIENT,
    ENCOUNTER,
    SYSTEM,
    CODE,
    DESCRIPTION,
    'MASS-EHR'::VARCHAR as PIPELINE_NAME,
    '{{ invocation_id }}'::VARCHAR AS DBT_RUN_ID ,
    '{{ model.name }}'::VARCHAR AS DBT_MODEL_NAME,
    CURRENT_TIMESTAMP()::TIMESTAMP_NTZ AS LOAD_TS 
    
        
from {{ source('massachusetts_ehr', 'CONDITIONS') }}


