--
-- MASTER_V_MREE_REESTR  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.MASTER_V_MREE_REESTR
(ORDER_NPR, PROD_PLAN_ID, NAME_NPR, DOG_ID, DOG_NUMBER, 
 PLAT_NAME, FOR_ID, FOR_NAME, LOAD_TYPE_ID, TYPE_OTGR_NAME, 
 NOM_ZD, TONN_DECLARED, TONN_LOADED, PRIM, POLUCH_NAME, 
 STAN_NAME, PLANMOSCOWDOG, PLANMOSCOWDOGWITHFOR, PLANMOSCOWPROD, PLANOURDOG, 
 PLANOURDOGWITHFOR, PLANOURPROD)
AS 
SELECT
  kls_prod_plan.ORDER_NPR,
  A.PROD_PLAN_ID,
  kls_prod_plan.NAME_NPR,
  A.DOG_ID,
  kls_dog.DOG_NUMBER,
  kls_predpr.PREDPR_NAME AS plat_name,
  A.FOR_ID,
  A.FOR_NAME,
  v_mree_month.LOAD_TYPE_ID,
  v_mree_month.TYPE_OTGR_NAME,
  v_mree_month.NOM_ZD,
  v_mree_month.TONN_DECLARED,
  v_mree_month.TONN_LOADED,
  v_mree_month.PRIM,
  v_mree_month.POLUCH_NAME,
  v_mree_month.STAN_NAME,
  A.PLANMOSCOWDOG,
  (SELECT SUM(B.PLANMOSCOWDOG) FROM V_MREE_PLANBYDOGDETAIL B WHERE 
    a.dog_id=b.dog_id AND a.prod_plan_id=b.prod_plan_id) AS PlanMoscowDogWithFor,
  (SELECT SUM(B.PLANMOSCOWDOG) FROM V_MREE_PLANBYDOGDETAIL B WHERE 
    a.prod_plan_id=b.prod_plan_id) AS PlanMoscowProd,
  A.PLANOURDOG,
  (SELECT SUM(B.PLANOURDOG) FROM V_MREE_PLANBYDOGDETAIL B WHERE 
    a.dog_id=b.dog_id AND a.prod_plan_id=b.prod_plan_id) AS PlanOurDogWithFor,
  (SELECT SUM(B.PLANOURDOG) FROM V_MREE_PLANBYDOGDETAIL B WHERE 
    a.prod_plan_id=b.prod_plan_id) AS PlanOurProd
  FROM V_MREE_PLANBYDOGDETAIL A,kls_prod_plan,kls_dog,v_mree_month,kls_predpr
  WHERE
    kls_prod_plan.ID=A.PROD_PLAN_ID AND
	kls_dog.id=a.dog_id AND
	kls_dog.PREDPR_ID=kls_predpr.ID AND
	a.dog_id=v_mree_month.dog_id(+) AND
	a.for_id=v_mree_month.for_id(+) AND
	a.prod_plan_id=v_mree_month.prod_plan_id(+)
  ORDER BY ORDER_NPR,DOG_NUMBER,FOR_ID,load_type_id,nom_zd;


