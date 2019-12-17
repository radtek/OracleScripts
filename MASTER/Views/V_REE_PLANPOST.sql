--
-- V_REE_PLANPOST  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_REE_PLANPOST
(NAME, ID_NPR, PROD_PLAN_ID, PLANSTRU_ID, PARENT_ID, 
 FOR_ID, FOR_NAME, ID_KIND_NPR, ABBR_NPR, DATE_PLAN, 
 BEGIN_DATE, END_DATE, PLAN_VES, PLAN_VES_ARH, DOG_ID, 
 PLAN_ID)
AS 
SELECT kls_planstru.NAME, kls_prod.id_npr, kls_prod.PROD_PLAN_ID, kls_planstru.ID planstru_id,
       kls_planstru.PARENT_ID,kls_planstru.FOR_ID,kls_planstru.FOR_NAME,
       kls_prod.id_kind_npr, kls_prod.abbr_npr, plan_periods.date_plan,
       plan_periods.begin_date, plan_periods.end_date, plan_post.plan_ves,
	   DECODE(kls_planstru.REGION_ID,21,plan_post.plan_ves,0) AS plan_ves_arh,
       plan_post.dog_id,plan_post.plan_id
  FROM plan_post, kls_planstru, plan_periods, kls_prod,V_TEMP_REESTR_PARAMS
 WHERE (    (kls_planstru.ID = plan_post.planstru_id)
        AND (plan_periods.plan_id = plan_post.plan_id)
        AND (plan_periods.ID = plan_post.plan_per_id)
        AND (kls_prod.id_npr = plan_post.prod_id_npr)
		AND (V_TEMP_REESTR_PARAMS.DATE_PLAN=plan_periods.DATE_PLAN)
		AND (V_TEMP_REESTR_PARAMS.DATETIME_REPORT>=plan_periods.BEGIN_DATE)
       );


