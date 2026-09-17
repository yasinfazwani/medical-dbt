{{
  config(
    materialized = 'incremental',
    unique_key = 'uniquepid'
    )
}}


select *,
 {{age_category('age')}} age_category
 from {{ ref('bronze_patients') }}
{% if is_incremental() %}
where create_date > (select coalesce(max(create_date),'1900-01-01') from {{ this }})
{% endif %}
qualify row_number() over (partition by uniquepid order by create_date desc) = 1