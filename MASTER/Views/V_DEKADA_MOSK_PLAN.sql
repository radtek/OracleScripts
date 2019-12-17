--
-- V_DEKADA_MOSK_PLAN  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_DEKADA_MOSK_PLAN
(VID_DOC, GR_PROD, PROD, PLAT, DATE_PLAN, 
 TONN_DECLARED, VES)
AS 
select
  'plan' as VID_DOC,                 
  oil_prod_grp.NAME_NPR AS GR_PROD,
  oil_prod.NAME_NPR as PROD,
  kls_predpr.PREDPR_NAME as PLAT,
  TO_CHAR(plan_per.date_plan,'YYYYMMDD') as date_plan,   -- Дата отгрузки (?)
--  max(oil_prod.nagr) as norm,
  sum(m1.tonn_declared) as tonn_declared,
  SUM(plan_post.plan_ves) as ves     -- Количество
 from
  plan_post plan_post
  join
  kls_prod oil_prod on plan_post.prod_id_npr=oil_prod.id_npr
  join
  kls_prod oil_prod_grp on oil_prod.id_group_npr=oil_prod_grp.id_npr
  join
  kls_dog dogovor on plan_post.dog_id=dogovor.id
  join 
  kls_predpr on dogovor.PREDPR_ID=kls_predpr.ID
  join
  kls_planstru plan_pos on plan_post.planstru_id=plan_pos.id
  join
  plan_periods plan_per on plan_post.plan_per_id=plan_per.id
  left join 
  (select PROD_ID_NPR,DATE_PLAN,dog_id,sum(tonn_declared) as tonn_declared from month group by PROD_ID_NPR,DATE_PLAN,dog_id) m1 on (m1.PROD_ID_NPR=plan_post.PROD_ID_NPR and m1.date_plan=plan_per.date_plan and m1.dog_id=plan_post.DOG_ID)
where plan_post.plan_id=2 -- московский план
  and plan_per.date_plan between FOR_TEMP.GET_AS_DATE('BEGIN_DATE','MASTER','RAZNAR_MOSK.XLS') AND FOR_TEMP.GET_AS_DATE('END_DATE','MASTER','RAZNAR_MOSK.XLS')
  and plan_pos.kod_sgr<>21
  and dogovor.isu_kod_dog like 'A%' --убираем из плана поставки на собственные нужды
GROUP BY
  kls_predpr.PREDPR_NAME,
  TO_CHAR(plan_per.num_plan),
  TO_CHAR(plan_per.date_plan,'YYYYMMDD'),   -- Дата отгрузки (?)
  oil_prod_grp.NAME_NPR,
  oil_prod.NAME_NPR
HAVING SUM(plan_post.plan_ves)<>0
ORDER BY "GR_PROD","PROD","PLAT","DATE_PLAN" NULLS FIRST;


