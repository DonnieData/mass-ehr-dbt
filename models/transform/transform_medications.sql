-- --select transform_medications

{{ config(
    materialized='incremental',
    schema='massachusetts_ehr',
    alias='medications',
    incremental_strategy='append',
    on_schema_change='append_new_columns'
) }}

select 

    "START"::TIMESTAMP_NTZ AS "START",
    "STOP"::TIMESTAMP_NTZ AS "STOP",
    PATIENT ,
    PAYER ,
    ENCOUNTER ,
    CODE ,
    DESCRIPTION ,
    BASE_COST::NUMBER(10, 2) AS BASE_COST ,
    PAYER_COVERAGE::NUMBER(10, 2) AS PAYER_COVERAGE,
    DISPENSES INT,
    TOTALCOST::NUMBER(12, 2) AS TOTALCOST,
    REASONCODE ,
    REASONDESCRIPTION ,
    'MASS-EHR'::VARCHAR as PIPELINE_NAME,
    '{{ invocation_id }}'::VARCHAR AS DBT_RUN_ID ,
    '{{ model.name }}'::VARCHAR AS DBT_MODEL_NAME,
    CURRENT_TIMESTAMP()::TIMESTAMP_NTZ AS LOAD_TS 
   
from {{ source('massachusetts_ehr', 'MEDICATIONS') }}
