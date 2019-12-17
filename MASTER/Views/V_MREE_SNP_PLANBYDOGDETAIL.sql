--
-- V_MREE_SNP_PLANBYDOGDETAIL  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_MREE_SNP_PLANBYDOGDETAIL
(REFINERY_ID, REFINERY_NAME, DOG_ID, OTHER, PROD_PLAN_ID, 
 NAME_NPR, FOR_ID, FOR_NAME, PLANALLDOG, PLANFIRSTDOG)
AS 
SELECT
  a.REFINERY_ID,
  a.REFINERY_NAME,
  a.DOG_ID,
  a.OTHER,
  kls_prod_plan.ID AS prod_plan_id,
  kls_prod_plan.NAME_NPR,
  a.FOR_ID,
  a.FOR_NAME,
  SUM(a.PLAN_VES) as PlanAllDog,
  SUM(DECODE(a.plan_id,
    12,a.PLAN_VES,0)) AS PlanFirstDog
  FROM v_mree_snp_planpost a,kls_prod_plan,kls_prod
  WHERE
    a.ID_NPR=kls_prod.ID_NPR AND
 kls_prod.PROD_PLAN_ID=kls_prod_plan.ID
  GROUP BY
    a.REFINERY_ID,
    a.REFINERY_NAME,
    a.DOG_ID,
    a.OTHER,
    kls_prod_plan.ID,
    kls_prod_plan.NAME_NPR,
    a.FOR_ID,
    a.FOR_NAME;


