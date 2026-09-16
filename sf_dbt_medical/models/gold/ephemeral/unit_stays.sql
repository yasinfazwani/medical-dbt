
{{
    config(
    materialized = 'ephemeral',
    )
}}

with unit_stays as
(
    select
    patientunitstayid,
    wardid,
    unittype,
    apacheadmissiondx,
    unitadmitsource,
    unitstaytype,
    unitdischargelocation,
    unitdischargestatus,
    create_date,
    from {{ ref('obt') }}
    qualify row_number() over (partition by uniquepid order by patient_create_date desc) = 1
)

select * from unit_stays