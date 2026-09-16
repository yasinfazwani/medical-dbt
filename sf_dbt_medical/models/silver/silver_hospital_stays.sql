 {{
  config(
    materialized = 'incremental',
    unique_key = 'patienthealthsystemstayid'
    )
}}



select * from 
{{ ref('bronze_hospital_stays') }}
qualify row_number() over (partition by patienthealthsystemstayid order by create_date desc) = 1