-- --select transform_patients

{{ config(
    materialized='incremental',
    schema='massachusetts_ehr',
    alias='patients',
    incremental_strategy='append',
    on_schema_change='append_new_columns'
) }}

select 

    ID,
    BIRTHDATE::DATE AS BIRTHDATE ,
    DEATHDATE::DATE AS DEATHDATE,
    SSN,
    DRIVERS ,
    PASSPORT ,
    PREFIX ,
    FIRST ,
    MIDDLE ,
    LAST ,
    SUFFIX,
    MAIDEN ,
    MARITAL ,
    RACE ,
    ETHNICITY ,
    GENDER ,
    BIRTHPLACE ,
    ADDRESS ,
    CITY ,
    STATE ,
    COUNTY ,
    FIPS ,
    ZIP ,
    LAT::NUMBER(10, 8) AS LATITUDE,
    LON::NUMBER(11, 8) AS LONGITUDE,
    HEALTHCARE_EXPENSES::NUMBER(10, 2) AS HEALTHCARE_EXPENSES,
    HEALTHCARE_COVERAGE::NUMBER(10, 2) AS HEALTHCARE_COVERAGE,
    INCOME::NUMBER(12, 2) AS INCOME
    'MASS-EHR'::VARCHAR as PIPELINE_NAME,
    '{{ invocation_id }}'::VARCHAR AS DBT_RUN_ID ,
    '{{ model.name }}'::VARCHAR AS DBT_MODEL_NAME,
    CURRENT_TIMESTAMP()::TIMESTAMP_NTZ AS LOAD_TS 
   
from {{ source('massachusetts_ehr', 'PATIENTS') }}


