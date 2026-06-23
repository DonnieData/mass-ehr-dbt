{{ config(
    materialized='view',
    schema='massachusetts_ehr',
    alias='v_rpt_condition_economics'
) }}

WITH conditions AS (
    SELECT * FROM {{ ref('transform_conditions') }}
),

encounters AS (
    SELECT * FROM {{ ref('transform_encounters') }}
)

SELECT 
    c.CODE AS condition_snomed_code,
    c.DESCRIPTION AS condition_name,
    COUNT(DISTINCT c.PATIENT) AS unique_patients_diagnosed,
    COUNT(DISTINCT c.ENCOUNTER) AS total_associated_encounters,
    
    -- Financial metrics
    AVG(e.BASE_ENCOUNTER_COST) AS avg_encounter_base_cost,
    AVG(e.TOTAL_CLAIM_COST) AS avg_total_amount_billed,
    SUM(e.TOTAL_CLAIM_COST) AS total_aggregate_financial_burden
FROM conditions c
JOIN encounters e ON c.ENCOUNTER = e.ID
GROUP BY c.CODE, c.DESCRIPTION