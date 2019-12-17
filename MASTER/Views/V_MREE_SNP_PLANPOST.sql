--
-- V_MREE_SNP_PLANPOST  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_MREE_SNP_PLANPOST
(REFINERY_ID, REFINERY_NAME, NAME, OTHER, ID_NPR, 
 PLANSTRU_ID, PARENT_ID, FOR_ID, FOR_NAME, PROD_PLAN_ID, 
 ABBR_NPR, DATE_PLAN, BEGIN_DATE, END_DATE, PLAN_VES, 
 PLAN_VES_ARH, DOG_ID, PLAN_ID)
AS 
SELECT
  A.REFINERY_ID,
  refinery.SF_NAME as REFINERY_NAME,
  A.NAME,
  A.other,
  A.id_npr,
  A.planstru_id,
  A.PARENT_ID,
  A.FOR_ID,
  A.FOR_NAME,
  A.PROD_PLAN_ID,
  A.abbr_npr,
  A.date_plan,
  A.begin_date,
  A.end_date,
  SUM(A.PLAN_VES) as PLAN_VES,
  SUM(A.PLAN_VES_ARH) as PLAN_VES_ARH,
  A.dog_id,
  A.plan_id
FROM
(
-- Позиции плана из плана поставок
SELECT
  plan_post.REFINERY_ID,
  kls_planstru.NAME,
  DECODE(kls_planstru.KOD_SGR,91,DECODE(kls_planstru.KOD_SPG,10,1,0),0) AS other,
  kls_prod.id_npr,
  kls_planstru.ID planstru_id,
  kls_planstru.PARENT_ID,
  kls_planstru.FOR_ID,
  kls_planstru.FOR_NAME,
  kls_prod.PROD_PLAN_ID,
  kls_prod.abbr_npr,
  plan_periods.date_plan,
  plan_periods.begin_date,
  plan_periods.end_date,
  plan_post.plan_ves,
  DECODE(kls_planstru.REGION_ID,21,plan_post.plan_ves,0) AS plan_ves_arh,
  plan_post.dog_id,
  plan_post.plan_id
FROM plan_post, kls_planstru, plan_periods, kls_prod,V_TEMP_MREESTR_SNP_PARAMS, kls_plan
WHERE (kls_planstru.ID = plan_post.planstru_id)
  AND (plan_periods.plan_id = plan_post.plan_id)
  AND (plan_periods.ID = plan_post.plan_per_id)
  AND (kls_prod.id_npr = plan_post.prod_id_npr)
  AND (plan_periods.PLAN_ID=KLS_PLAN.ID)
  AND (kls_plan.GLOBAL_PLAN_ID=12) -- План СНП
--  AND plan_post.REFINERY_ID=8 -- Только с УНП
  AND (V_TEMP_MREESTR_SNP_PARAMS.DATE_PLAN=plan_periods.DATE_PLAN)
  AND (V_TEMP_MREESTR_SNP_PARAMS.DATETIME_REPORT>=plan_periods.BEGIN_DATE)
UNION ALL
-- Позиции плана из заявок
SELECT distinct
  (CASE
     WHEN kls_dog2.is_agent=8 THEN kls_dog2.agent_id 
  ELSE 8
   END) as REFINERY_ID,    
  kls_planstru.NAME,
  DECODE(kls_planstru.KOD_SGR,91,DECODE(kls_planstru.KOD_SPG,10,1,0),0) AS other,
  kls_prod.id_npr,
  kls_planstru.ID planstru_id,
  kls_planstru.PARENT_ID,
  kls_planstru.FOR_ID,
  kls_planstru.FOR_NAME,
  kls_prod.PROD_PLAN_ID,
  kls_prod.abbr_npr,
  ZAKAZ.date_plan,
  ZAKAZ.date_plan as begin_date,
  LAST_DAY(ZAKAZ.date_plan) as end_date,
  0 as plan_ves,
  0 AS plan_ves_arh,
  ZAKAZ.LUKDOG_ID as dog_id,
  KLS_PLAN.ID as plan_id
FROM ZAKAZ, kls_planstru, kls_prod,V_TEMP_MREESTR_SNP_PARAMS, kls_plan,kls_dog kls_dog2
WHERE (kls_planstru.ID = ZAKAZ.planstru_id)
  AND (kls_prod.id_npr = ZAKAZ.prod_id_npr)
  AND (KLS_PLAN.ID=12)
  AND (V_TEMP_MREESTR_SNP_PARAMS.DATE_PLAN=ZAKAZ.DATE_PLAN)
  AND zakaz.is_agent=2
  AND zakaz.lukdog_id=kls_dog2.id(+)
  AND zakaz.is_accept=1
) a, kls_predpr refinery
WHERE a.refinery_id=refinery.id 
GROUP BY
  A.REFINERY_ID,
  refinery.SF_NAME,
  A.NAME,
  A.other,
  A.id_npr,
  A.planstru_id,
  A.PARENT_ID,
  A.FOR_ID,
  A.FOR_NAME,
  A.PROD_PLAN_ID,
  A.abbr_npr,
  A.date_plan,
  A.begin_date,
  A.end_date,
  A.dog_id,
  A.plan_id;


