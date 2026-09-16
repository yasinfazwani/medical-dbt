{{
  config(
    materialized = 'incremental',
    )
}}


select * from {{source('staging','patients')}}
{% if is_incremental() %}
    where create_date > (select coalesce(max(create_date),'1900-01-01') from {{ this  }})
{%else%}

{%endif%}