-- --select transform_claims

{{ config(
    materialized='incremental',
    schema='massachusetts_ehr',
    alias='claims',
    incremental_strategy='append',
    on_schema_change='append_new_columns'
) }}

select 
    ID ,
    PATIENTID ,
    PROVIDERID ,
    PRIMARYPATIENTINSURANCEID ,
    SECONDARYPATIENTINSURANCEID ,
    DEPARTMENTID ,
    PATIENTDEPARTMENTID ,
    DIAGNOSIS1 ,
    DIAGNOSIS2 ,
    DIAGNOSIS3 ,
    DIAGNOSIS4 ,
    DIAGNOSIS5 ,
    DIAGNOSIS6 ,
    DIAGNOSIS7 ,
    DIAGNOSIS8 ,
    REFERRINGPROVIDERID ,
    APPOINTMENTID ,
    CURRENTILLNESSDATE ,
    SERVICEDATE ,
    SUPERVISINGPROVIDERID ,
    STATUS1 ,
    STATUS2 ,
    STATUSP ,
    OUTSTANDING1 ,
    OUTSTANDING2 ,
    OUTSTANDINGP ,
    LASTBILLEDDATE1 TIMESTAMP_NTZ,
    LASTBILLEDDATE2 TIMESTAMP_NTZ,
    LASTBILLEDDATEP TIMESTAMP_NTZ,
    HEALTHCARECLAIMTYPEID1 ,
    HEALTHCARECLAIMTYPEID2 ,
    'MASS-EHR'::VARCHAR as PIPELINE_NAME,
    '{{ invocation_id }}'::VARCHAR AS DBT_RUN_ID ,
    '{{ model.name }}'::VARCHAR AS DBT_MODEL_NAME,
    CURRENT_TIMESTAMP()::TIMESTAMP_NTZ AS LOAD_TS 
   
from {{ source('massachusetts_ehr', 'CLAIMS') }}

