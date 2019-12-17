--
-- V_MREE_PLANBYDOG  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_MREE_PLANBYDOG
(DOG_ID, PROD_PLAN_ID, NAME_NPR, PLANMOSCOWDOG, PLANOURDOG)
AS 
SELECT
  v_mree_planpost.DOG_ID,  
  kls_prod_plan.ID AS prod_plan_id,
  kls_prod_plan.NAME_NPR,
  SUM(DECODE(v_mree_planpost.plan_id,
    2,v_mree_planpost.PLAN_VES,
	3,v_mree_planpost.PLAN_VES,0)) AS PlanMoscowDog,
  SUM(DECODE(v_mree_planpost.plan_id,
    2,v_mree_planpost.PLAN_VES,0)) AS PlanOurDog
  FROM v_mree_planpost,kls_prod_plan,kls_prod
  WHERE 
    v_mree_planpost.ID_NPR=kls_prod.ID_NPR AND
	kls_prod.PROD_PLAN_ID=kls_prod_plan.ID
  GROUP BY
    v_mree_planpost.DOG_ID,  
    kls_prod_plan.ID,
    kls_prod_plan.NAME_NPR;


