select "START" from RAW.MASSACHUSETTS_EHR.PROCEDURES limit 100

select "START"::TIMESTAMP from RAW.MASSACHUSETTS_EHR.PROCEDURES limit 100

select * from RAW.MASSACHUSETTS_EHR.PATIENTS

use database raw; 
use schema MASSACHUSETTS_EHR;

select * from ENCOUNTERS
select count(*) from encounters

select * from ENCOUNTERS en
left join PATIENTS pa
on en.patient = pa.id
limit 100

select * from TRANSFORM.MASSACHUSETTS_EHR.ENCOUNTERS

