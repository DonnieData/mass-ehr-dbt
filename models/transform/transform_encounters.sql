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
    ID,
    "START",
    "STOP",
    PATIENT,
    ORGANIZATION,
    PROVIDER,
    PAYER,
    ENCOUNTERCLASS,
    CODE,
    DESCRIPTION,
    BASE_ENCOUNTER_COST,
    TOTAL_CLAIM_COST,
    PAYER_COVERAGE,
    REASONCODE,
    REASONDESCRIPTION 
from {{ source('massachusetts_ehr', 'ENCOUNTERS') }}

