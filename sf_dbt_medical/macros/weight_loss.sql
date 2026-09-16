{% macro weight_loss(x,y) %}
    round({{x}}-{{y}},0)
{% endmacro %}