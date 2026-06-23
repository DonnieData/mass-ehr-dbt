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
    ID as ID,
    "START"::TIMESTAMP_NTZ as "START",
    "STOP"::TIMESTAMP_NTZ as "STOP",
    PATIENT,
    ORGANIZATION,
    PROVIDER as PROVIDER,
    PAYER ,
    ENCOUNTERCLASS,
    CODE,
    DESCRIPTION,
    BASE_ENCOUNTER_COST::NUMBER(10,2) as BASE_ENCOUNTER_COST,
    TOTAL_CLAIM_COST::NUMBER(10,2) as TOTAL_CLAIM_COST,
    PAYER_COVERAGE::NUMBER(10,2) as PAYER_COVERAGE,
    REASONCODE,
    REASONDESCRIPTION,
    'MASS-EHR'::VARCHAR as PIPELINE_NAME,
    '{{ invocation_id }}'::VARCHAR AS DBT_RUN_ID ,
    '{{ model.name }}'::VARCHAR AS DBT_MODEL_NAME,
    CURRENT_TIMESTAMP()::TIMESTAMP_NTZ AS LOAD_TS 
    
from {{ source('massachusetts_ehr', 'ENCOUNTERS') }}

