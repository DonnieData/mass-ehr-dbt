-- Patient medications view joining meds with conditions and encounters
-- Co-authored with CoCo
{{ config(
    materialized='view',
    schema='massachusetts_ehr',
    alias='v_patient_medications'
) }}

WITH medications AS (
    SELECT * FROM {{ ref('transform_medications') }}
),

conditions AS (
    SELECT * FROM {{ ref('transform_conditions') }}
)

SELECT 
    m.PATIENT AS patient_id,
    m.ENCOUNTER AS encounter_id,
    m."START" AS prescription_started_at,
    m."STOP" AS prescription_ended_at,
    
    -- RxNorm details
    m.CODE AS medication_rxnorm_code,
    m.DESCRIPTION AS medication_name,
    
    -- Cross-reference clinical justification
    c.CODE AS underlying_condition_code,
    c.DESCRIPTION AS underlying_condition_reason,
    
    -- Costs
    m.BASE_COST AS base_drug_cost,
    m.TOTALCOST AS total_accumulated_drug_cost,
    m.PAYER_COVERAGE AS insurance_covered_amount,
    (m.TOTALCOST - m.PAYER_COVERAGE) AS patient_out_of_pocket_cost
FROM medications m
LEFT JOIN conditions c ON m.ENCOUNTER = c.ENCOUNTER