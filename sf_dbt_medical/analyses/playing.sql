{% set age  = 45 %}
{% set ethnicity = 'African American' %}

select * from {{ref("bronze_patients")}}
where age < {{age}}
and ethnicity = '{{ethnicity}}'