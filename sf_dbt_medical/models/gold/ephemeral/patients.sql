
    {{
      config(
        materialized = 'ephemeral',
        )
    }}



with patients as
(
    select
    uniquepid, gender, age_category, ethnicity, patient_create_date
    from {{ ref('obt') }}
    qualify row_number() over (partition by uniquepid order by patient_create_date desc) = 1
)

select * from patients