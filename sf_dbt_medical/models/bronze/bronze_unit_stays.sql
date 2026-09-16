{{
  config(
    materialized = 'incremental',
    )
}}


select * from {{source('staging','unit_stays')}}
{% if is_incremental() %}
    where create_date > (select coalesce(max(create_date),'1900-01-01') from {{ this  }})
{%else%}

{%endif%}