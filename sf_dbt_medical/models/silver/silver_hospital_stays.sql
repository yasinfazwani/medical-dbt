 {{
  config(
    materialized = 'incremental',
    unique_key = 'patienthealthsystemstayid'
    )
}}



select * from
{{ ref('bronze_hospital_stays') }}
{% if is_incremental() %}
where create_date > (select coalesce(max(create_date),'1900-01-01') from {{ this }})
{% endif %}
qualify row_number() over (partition by patienthealthsystemstayid order by create_date desc) = 1