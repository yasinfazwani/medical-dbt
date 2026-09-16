{{
  config(
    materialized = 'incremental',
    unique_key = 'uniquepid'
    )
}}


select *,
 {{age_category('age')}} age_category
 from {{ ref('bronze_patients') }}
qualify row_number() over (partition by uniquepid order by create_date desc) = 1