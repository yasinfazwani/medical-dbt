{% set mapping_json %}
{
    "unit_type_mapping": [
        {"unittype": "Neuro ICU", "department": "Neurology"},
        {"unittype": "Med-Surg ICU", "department": "Medical-Surgical"},
        {"unittype": "Cardiac ICU", "department": "Cardiology"},
        {"unittype": "MICU", "department": "Medical"},
        {"unittype": "SICU", "department": "Surgical"}
    ]
}
{% endset %}

{% set mapping = fromjson(mapping_json) %}

select
    patientunitstayid,
    unittype,
    case
    {% for row in mapping['unit_type_mapping'] %}
        when unittype = '{{ row["unittype"] }}' then '{{ row["department"] }}'
    {% endfor %}
        else 'Other'
    end as department
from {{ ref('bronze_unit_stays') }}
