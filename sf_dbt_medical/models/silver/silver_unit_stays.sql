{{
  config(
    materialized = 'incremental',
    unique_key = 'patientunitstayid'
    )
}}


select *,
 {{weight_loss('admissionweight','dischargeweight')}} as weight_difference
 from {{ref('bronze_unit_stays')}}
{% if is_incremental() %}
where create_date > (select coalesce(max(create_date),'1900-01-01') from {{ this }})
{% endif %}
qualify row_number() over (partition by patientunitstayid order by create_date desc) = 1