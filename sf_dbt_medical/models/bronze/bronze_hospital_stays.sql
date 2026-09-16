{{
  config(
    materialized = 'incremental',
    )
}}

select patienthealthsystemstayid,
uniquepid,
hospitalid,
hospitaldischargelocation,
hospitaldischargestatus,
create_date
from {{source('staging','hospital_stays')}}
{% if is_incremental() %}
    where create_date > (select coalesce(max(create_date),'1900-01-01') from {{ this  }})
{%else%}

{%endif%}