{{ config(
    materialized='view',
    schema='massachusetts_ehr',
    alias='v_patient_360'
) }}



WITH patients AS (
    SELECT * FROM {{ ref('transform_patients') }}
),

encounters AS (
    SELECT * FROM {{ ref('transform_encounters') }}
),

conditions AS (
    SELECT * FROM {{ ref('transform_conditions') }}
),

patient_metrics AS (
    SELECT 
        PATIENT AS patient_id,
        COUNT(DISTINCT ID) AS total_encounters_count,
        SUM(BASE_ENCOUNTER_COST) AS total_base_costs,
        SUM(TOTAL_CLAIM_COST) AS total_claim_charges
    FROM encounters
    GROUP BY PATIENT
),

patient_financials AS (
    SELECT 
        ID AS patient_id,
        SUM(HEALTHCARE_EXPENSES) AS total_patient_out_of_pocket,
        SUM(HEALTHCARE_COVERAGE) AS total_payer_covered
    FROM patients
    GROUP BY ID
),

chronic_conditions AS (
    SELECT DISTINCT 
        PATIENT AS patient_id,
        1 AS has_chronic_condition_flag
    FROM conditions
    WHERE LOWER(DESCRIPTION) LIKE '%diab%' 
       OR LOWER(DESCRIPTION) LIKE '%hyper%' 
       OR LOWER(DESCRIPTION) LIKE '%heart%'
)

SELECT 
    p.ID AS patient_id,
    p.FIRST AS first_name,
    p.LAST AS last_name,
    p.GENDER,
    p.RACE,
    p.ETHNICITY,
    p.INCOME AS annual_income,
    p.CITY,
    p.STATE,
    COALESCE(m.total_encounters_count, 0) AS total_encounters_count,
    COALESCE(m.total_base_costs, 0.00) AS total_base_costs,
    COALESCE(m.total_claim_charges, 0.00) AS total_claim_charges,
    COALESCE(f.total_patient_out_of_pocket, 0.00) AS total_lifetime_out_of_pocket,
    COALESCE(f.total_payer_covered, 0.00) AS total_lifetime_payer_covered,
    COALESCE(cc.has_chronic_condition_flag, 0) AS has_chronic_condition_flag
FROM patients p
LEFT JOIN patient_metrics m ON p.ID = m.patient_id
LEFT JOIN patient_financials f ON p.ID = f.patient_id
LEFT JOIN chronic_conditions cc ON p.ID = cc.patient_id