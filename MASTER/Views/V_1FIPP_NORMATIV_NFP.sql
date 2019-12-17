--
-- V_1FIPP_NORMATIV_NFP  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_1FIPP_NORMATIV_NFP
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
  v_bill_pos.summa AS plan_plat
  FROM bills,kls_dog,v_bill_pos WHERE kls_dog.id=bills.dog_id AND kls_dog.LUKDOG_ID=793 and v_bill_pos.nom_dok=bills.nom_dok and v_bill_pos.PROD_ID_NPR>10300 
) 
GROUP BY
  dog_number,
  date_plan;


