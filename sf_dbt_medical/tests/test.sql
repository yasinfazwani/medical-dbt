 {{
  config(
    severity = 'warn',
    )


}}

select * from
{{ source('staging', 'patients') }}
where age > 80