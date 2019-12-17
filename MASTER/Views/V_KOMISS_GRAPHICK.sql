--
-- V_KOMISS_GRAPHICK  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_KOMISS_GRAPHICK
(DOG_NUMBER, DATE_PLAN, PLAN_PLAT, NUM_PLAT_POR, FACT_PLAT)
AS 
SELECT
  dog_number,
  date_plan,
  SUM(plan_plat) AS plan_plat,
  MAX(num_plat_por),
  SUM(fact_plat) AS fact_plat
FROM
(
SELECT 
  kls_dog.DOG_NUMBER,
  bills.date_kvit+bills.KOL_DN AS date_plan,
  bills.SUMMA_DOK AS plan_plat,
  '' AS num_plat_por,
  0 AS fact_plat
  FROM bills,kls_dog WHERE kls_dog.id=bills.dog_id AND kls_dog.LUKDOG_ID=793
UNION ALL
SELECT
  kls_dog.DOG_NUMBER,
  opl.DATA_POR AS date_plan,
  0 AS plan_plat,
  get_opl_plat_nums(kls_dog.id, opl.DATA_POR) AS num_plat_por,
  opl.SUMMA AS fact_plat
  FROM kls_dog,opl
  WHERE kls_dog.id=opl.dog_id AND kls_dog.LUKDOG_ID=793
) 
GROUP BY
  dog_number,
  date_plan;


