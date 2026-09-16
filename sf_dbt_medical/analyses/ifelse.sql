{% set flag = 1%}

select * from {{ref("bronze_unit_stays")}}
{% if flag ==1 %}
  where unitdischargestatus = 'Alive'
{% else%}
    where unitdischargestatus = 'Expired'
{% endif %}
