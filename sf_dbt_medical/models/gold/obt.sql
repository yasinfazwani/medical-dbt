{% set content = [
    {
        "table": ref('silver_unit_stays'),
        "columns": ['patientunitstayid', 'wardid', 'unittype', 'apacheadmissiondx', 'admissionheight', 'admissionweight', 'dischargeweight', 'unitadmittime24', 'unitadmitsource', 'unitvisitnumber', 'unitstaytype', 'unitdischargetime24', 'unitdischargeoffset', 'unitdischargelocation', 'unitdischargestatus', 'create_date'],
        "alias": "silver_unit_stays"

    },
    {
        "table":ref('silver_hospital_stays'),
        "columns": ['hospitalid', 'hospitaldischargelocation', 'hospitaldischargestatus', 'create_date as hospital_stay_create_date'],
        "alias": "silver_hospital_stays",
        "join_condition": "silver_unit_stays.patienthealthsystemstayid = silver_hospital_stays.patienthealthsystemstayid"
    },
    {
        "table": ref('silver_patients'),
        "columns": ['uniquepid', 'gender', 'age','age_category', 'is_age_90_plus', 'ethnicity', 'create_date as patient_create_date'],
        "alias": "silver_patients",
        "join_condition": "silver_hospital_stays.uniquepid = silver_patients.uniquepid"

    }
]%}


select
 {% for configs in content %}
   {% for col in configs['columns'] %}
   {{ configs['alias'] }}.{{ col }}{% if not loop.last or not loop.last %}, {% endif %}
   {% endfor %}{% if not loop.last %},{% endif %}
{% endfor %}
from
 {% for configs in content %}
    {%if loop.first%}
    {{configs['table']}} as {{configs['alias']}}
    {% else %}
        left join {{configs['table']}} as {{configs['alias']}}
        on {{configs['join_condition']}}
    {% endif %}
{% endfor %}



 