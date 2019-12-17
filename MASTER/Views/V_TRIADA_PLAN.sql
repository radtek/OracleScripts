--
-- V_TRIADA_PLAN  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_TRIADA_PLAN
(GR_PROD, PROD, PLAT, VES)
AS 
SELECT 
	  RES.GR_PROD,
	  RES.PROD,
	  RES.PLAT,
	  SUM(RES.VES) as VES
FROM
(select
  oil_prod_grp.NAME_NPR AS GR_PROD,
  oil_prod.NAME_NPR AS PROD,
  kls_predpr.PREDPR_NAME AS PLAT,
  SUM(plan_post.plan_ves) as VES	  	  
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
where plan_post.plan_id=3 -- ОБР
  and plan_per.begin_date between FOR_TEMP.GET_AS_DATE('BEGIN_DATE','MASTER','RAZNAR_TRIADA.XLS') AND FOR_TEMP.GET_AS_DATE('END_DATE','MASTER','RAZNAR_TRIADA.XLS')
--  and plan_pos.kod_sgr<>21
  and dogovor.isu_kod_dog like 'A%' --убираем из плана поставки на собственные нужды
GROUP BY
  kls_predpr.PREDPR_NAME,
  oil_prod_grp.NAME_NPR,
  oil_prod.NAME_NPR
HAVING SUM(plan_post.plan_ves)<>0
UNION ALL
select
  oil_prod_grp.NAME_NPR AS GR_PROD,
  oil_prod.NAME_NPR AS PROD,
  kls_predpr.PREDPR_NAME AS PLAT,
  SUM(plan_post.plan_ves) as VES
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
where plan_post.plan_id=2 -- московский план
  and plan_per.date_plan between FOR_TEMP.GET_AS_DATE('BEGIN_DATE','MASTER','RAZNAR_TRIADA.XLS') AND FOR_TEMP.GET_AS_DATE('END_DATE','MASTER','RAZNAR_TRIADA.XLS')
--  and plan_pos.kod_sgr<>21
  and dogovor.isu_kod_dog like 'A%' --убираем из плана поставки на собственные нужды
GROUP BY
  kls_predpr.PREDPR_NAME,
  oil_prod_grp.NAME_NPR,
  oil_prod.NAME_NPR
HAVING SUM(plan_post.plan_ves)<>0
) RES
HAVING SUM(RES.ves)<>0
GROUP BY RES.GR_PROD,RES.PROD,RES.PLAT
ORDER BY RES.GR_PROD,RES.PROD,RES.PLAT NULLS FIRST;


