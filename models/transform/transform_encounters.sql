-- Transform raw encounters into incremental model
-- Co-authored with CoCo

{{ config(
    materialized='incremental',
    schema='massachusetts_ehr',
    alias='encounters',
    incremental_strategy='append',
    on_schema_change='append_new_columns'
) }}

select 
    ID as ID,
    "START"::TIMESTAMP_NTZ as START_DATE,
    "STOP"::TIMESTAMP_NTZ as STOP_DATE,
    PATIENT::VARCHAR as PATIENT,
    ORGANIZATION::VARCHAR as ORGANIZATION,
    PROVIDER as PROVIDER,
    PAYER as PAYER,
    ENCOUNTERCLASS as ENCOUNTERCLASS,
    CODE as CODE,
    DESCRIPTION as DESCRIPTION,
    BASE_ENCOUNTER_COST::NUMBER(10,2) as BASE_ENCOUNTER_COST,
    TOTAL_CLAIM_COST::NUMBER(10,2) as TOTAL_CLAIM_COST,
    PAYER_COVERAGE::NUMBER(10,2) as PAYER_COVERAGE,
    REASONCODE as REASONCODE,
    REASONDESCRIPTION as REASONDESCRIPTION,
    'MASS-EHR'::VARCHAR as PIPELINE_NAME ,
    CURRENT_TIMESTAMP()::TIMESTAMP_NTZ AS SRC_LOAD_TS,
    '{{ invocation_id }}'::VARCHAR AS DBT_RUN_ID ,
    '{{ model.name }}'::VARCHAR AS DBT_MODEL_NAME,
    CURRENT_TIMESTAMP()::TIMESTAMP_NTZ AS LOAD_TS 
    
    
from {{ source('massachusetts_ehr', 'ENCOUNTERS') }}

