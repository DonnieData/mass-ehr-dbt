-- --select transform_claims_transactions

{{ config(
    materialized='incremental',
    schema='massachusetts_ehr',
    alias='claims_transactions',
    incremental_strategy='append',
    on_schema_change='append_new_columns'
) }}

select 

    ID,
    CLAIMID,
    CHARGEID,
    PATIENTID,
    TYPE,
    AMOUNT::NUMBER(12, 2) AS AMOUNT,
    METHOD,
    FROMDATE::TIMESTAMP_NTZ AS FROMDATE,
    TODATE::TIMESTAMP_NTZ AS TODATE,
    PLACEOFSERVICE,
    PROCEDURECODE,
    MODIFIER1,
    MODIFIER2,
    DIAGNOSISREF1,
    DIAGNOSISREF2,
    DIAGNOSISREF3,
    DIAGNOSISREF4,
    UNITS,
    DEPARTMENTID,
    NOTES,
    UNITAMOUNT::NUMBER(10, 2) AS UNITAMOUNT,
    TRANSFEROUTID,
    TRANSFERTYPE,
    PAYMENTS::NUMBER(12, 2) AS PAYMENTS,
    ADJUSTMENTS::NUMBER(12, 2) AS ADJUSTMENTS,
    TRANSFERS::NUMBER(12, 2) AS TRANSFERS,
    OUTSTANDING::NUMBER(12, 2) AS OUTSTANDING,
    APPOINTMENTID,
    LINENOTE,
    PATIENTINSURANCEID,
    FEESCHEDULEID,
    PROVIDERID,
    SUPERVISINGPROVIDERID,
    'MASS-EHR'::VARCHAR as PIPELINE_NAME,
    '{{ invocation_id }}'::VARCHAR AS DBT_RUN_ID ,
    '{{ model.name }}'::VARCHAR AS DBT_MODEL_NAME,
    CURRENT_TIMESTAMP()::TIMESTAMP_NTZ AS LOAD_TS 
   
from {{ source('massachusetts_ehr', 'CLAIMS_TRANSACTIONS') }}

