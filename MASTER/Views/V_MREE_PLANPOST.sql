--
-- V_MREE_PLANPOST  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_MREE_PLANPOST
(NAME, OTHER, ID_NPR, PLANSTRU_ID, PARENT_ID, 
 FOR_ID, FOR_NAME, PROD_PLAN_ID, ABBR_NPR, DATE_PLAN, 
 BEGIN_DATE, END_DATE, PLAN_VES, PLAN_VES_ARH, DOG_ID, 
 PLAN_ID)
AS 
SELECT
	   kls_planstru.NAME,
--	   DECODE(kls_planstru.KOD_SGR,91,1,0) AS other,
	   DECODE(kls_planstru.KOD_SGR,91,DECODE(kls_planstru.KOD_SPG,10,1,0),0) AS other,
	   kls_prod.id_npr, kls_planstru.ID planstru_id,
       kls_planstru.PARENT_ID,kls_planstru.FOR_ID,kls_planstru.FOR_NAME,
       kls_prod.PROD_PLAN_ID, kls_prod.abbr_npr, plan_periods.date_plan,
       plan_periods.begin_date, plan_periods.end_date, plan_post.plan_ves,
	   DECODE(kls_planstru.REGION_ID,21,plan_post.plan_ves,0) AS plan_ves_arh,
       plan_post.dog_id,plan_post.plan_id
  FROM plan_post, kls_planstru, plan_periods, kls_prod,V_TEMP_MREESTR_PARAMS, kls_plan
 WHERE (    (kls_planstru.ID = plan_post.planstru_id)
        AND (plan_periods.plan_id = plan_post.plan_id)
        AND (plan_periods.ID = plan_post.plan_per_id)
        AND (kls_prod.id_npr = plan_post.prod_id_npr)
		AND (plan_periods.PLAN_ID=KLS_PLAN.ID)
		AND (kls_plan.GLOBAL_PLAN_ID in (1,2)) -- Для отсеивания других планов
		AND (V_TEMP_MREESTR_PARAMS.DATE_PLAN=plan_periods.DATE_PLAN)
		AND (V_TEMP_MREESTR_PARAMS.DATETIME_REPORT>=plan_periods.BEGIN_DATE)
       );


