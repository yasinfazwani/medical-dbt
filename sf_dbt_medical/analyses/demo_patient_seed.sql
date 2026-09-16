-- Full end-to-end demo: bronze -> silver -> obt -> snapshot (dim_patients)
-- Run each step in order. Steps in Snowflake worksheets are marked SNOWFLAKE;
-- steps in your terminal are marked TERMINAL.

-- ============================================================
-- STEP 0 (SNOWFLAKE, one-time cleanup) — only needed once, to clear out
-- duplicate "current" rows left in dim_patients from before the dedup fix.
-- Check first:
select uniquepid, count(*)
from hospital.gold.dim_patients
where dbt_valid_to is null
group by uniquepid
having count(*) > 1;

-- If that returns any rows, rebuild the snapshot table from scratch:
drop table if exists hospital.gold.dim_patients;


-- ============================================================
-- STEP 1 (SNOWFLAKE) — edit the same real patient again.
-- Previous value was age 60 (category 'senior'). Dropping to 25 crosses back
-- to 'young adult', so the category change is obvious again.

insert into hospital.staging.patients
  (uniquepid, gender, age, is_age_90_plus, ethnicity, create_date)
values
  ('002-10665', 'Male', 44, false, 'Caucasian', current_timestamp());


-- ============================================================
-- STEP 2 (TERMINAL) — rebuild bronze -> silver -> obt:
--   dbt run --select bronze_patients+
--
-- STEP 3 (TERMINAL) — rebuild the snapshot:
--   dbt snapshot


-- ============================================================
-- STEP 4 (SNOWFLAKE) — verify at each layer, in order:

-- bronze: should show multiple rows for this uniquepid (append-only history)
select * from hospital.bronze.bronze_patients
where uniquepid = '002-10665'
order by create_date;

-- silver: exactly ONE row, latest age (25) and its age_category
select * from hospital.silver.silver_patients
where uniquepid = '002-10665';

-- obt: patient's row(s) joined with hospital/unit stay data, age_category = 'young adult'
select uniquepid, age, age_category, ethnicity, patient_create_date
from hospital.gold.obt
where uniquepid = '002-10665';

-- dim_patients snapshot: history preserved — the OLD row (age_category='senior')
-- now has dbt_valid_to set to roughly when you ran `dbt snapshot`, and a NEW row
-- exists with dbt_valid_to is null and age_category='young adult'.
select uniquepid, age_category, ethnicity, patient_create_date, dbt_valid_from, dbt_valid_to
from hospital.gold.dim_patients
where uniquepid = '002-10665'
order by dbt_valid_from;
