{{ config(
    materialized='view',
    schema='massachusetts_ehr',
    alias='v_encounter_billing'
) }}

WITH encounters AS (
    SELECT * FROM {{ ref('transform_encounters') }}
),

claims AS (
    SELECT * FROM {{ ref('transform_claims') }}
),

payers AS (
    SELECT * FROM {{ ref('transform_payers') }}
),

claims_transactions AS (
    SELECT * FROM {{ ref('transform_claims_transactions') }}
),

claim_totals AS (
    SELECT 
        CLAIMID,
        SUM(CASE WHEN LOWER(TYPE) = 'payment' THEN AMOUNT ELSE 0 END) AS total_paid_to_date,
        SUM(CASE WHEN LOWER(TYPE) = 'adjustment' THEN AMOUNT ELSE 0 END) AS total_adjustments
    FROM claims_transactions
    GROUP BY CLAIMID
)

SELECT 
    e.ID AS encounter_id,
    e.PATIENT AS patient_id,
    e."START" AS encounter_start_at,
    e."STOP" AS encounter_stop_at,
    DATEDIFF('minute', e."START", e."STOP") AS duration_minutes,
    e.ENCOUNTERCLASS AS encounter_class,
    e.CODE AS encounter_snomed_code,
    
    -- Financials (Pre-staged scales preserved)
    e.BASE_ENCOUNTER_COST AS operational_base_cost,
    e.TOTAL_CLAIM_COST AS total_amount_billed,
    
    -- Payer context
    cl.PRIMARYPATIENTINSURANCEID AS payer_id,
    p.NAME AS payer_name,
    
    -- Ledger details
    COALESCE(ct.total_paid_to_date, 0.00) AS total_paid_to_date,
    COALESCE(ct.total_adjustments, 0.00) AS total_adjustments,
    (e.TOTAL_CLAIM_COST - e.BASE_ENCOUNTER_COST) AS net_hospital_margin
FROM encounters e
LEFT JOIN claims cl ON e.ID = cl.APPOINTMENTID
LEFT JOIN payers p ON cl.PRIMARYPATIENTINSURANCEID = p.ID
LEFT JOIN claim_totals ct ON cl.ID = ct.CLAIMID