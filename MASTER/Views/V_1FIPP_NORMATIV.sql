--
-- V_1FIPP_NORMATIV  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_1FIPP_NORMATIV
(DOG_NUMBER, DATE_PLAN, PLAN_PLAT)
AS 
SELECT
  dog_number,
  date_plan,
  SUM(plan_plat) AS plan_plat
FROM
(
SELECT 
  kls_dog.DOG_NUMBER,
  bills.date_kvit+bills.KOL_DN AS date_plan,
  bills.summa_dok AS plan_plat
  FROM bills,kls_dog WHERE kls_dog.id=bills.dog_id AND kls_dog.LUKDOG_ID=793 
) 
GROUP BY
  dog_number,
  date_plan;


