{{
  config(
    materialized = 'incremental',
    unique_key = 'patientunitstayid'
    )
}}


select *,
 {{weight_loss('admissionweight','dischargeweight')}} as weight_difference
 from {{ref('bronze_unit_stays')}}
qualify row_number() over (partition by patientunitstayid order by create_date desc) = 1