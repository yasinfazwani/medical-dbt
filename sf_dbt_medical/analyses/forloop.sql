{% set cols = ['unitadmitsource','unitstaytype','unitdischargelocation','unitdischargestatus']%}

select
{% for column in cols %}
    {{column}} 
        {% if not loop.last %}, {% endif%}
{% endfor %}
from {{ ref('bronze_unit_stays') }} 