{% macro age_category(x) %}
    case
        when {{x}} < 20 then 'teenager'
        when {{x}} >= 20 and {{x}} < 40 then 'young adult'
        when {{x}} >= 40 and {{x}} < 60 then 'adult'
        else 'senior'
    end
{% endmacro %}
