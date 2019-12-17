--
-- V_DEKADA_MOSK_OBR  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_DEKADA_MOSK_OBR
(VID_DOC, GR_PROD, PROD, PLAT, OBR_NUM, 
 DEKADA, DATE_PLAN, VES)
AS 
select
  'obr' as vid_doc,
  oil_prod_grp.NAME_NPR AS GR_PROD,
  oil_prod.NAME_NPR AS PROD,
  kls_predpr.PREDPR_NAME AS PLAT,	  	  
  TO_CHAR(plan_per.num_plan) as OBR_NUM,                 -- Номер ОБР или указания
  (case 
	   when to_number(to_char(plan_per.begin_date,'dd'))>=1 and to_number(to_char(plan_per.begin_date,'dd'))<=10 then 1
	   when to_number(to_char(plan_per.begin_date,'dd'))>10 and to_number(to_char(plan_per.begin_date,'dd'))<=20 then 2
	   else 3
	end) as dekada, -- Декада ОБР или указания	
  TO_CHAR(plan_per.date_plan,'YYYYMMDD') as date_plan,   -- Дата отгрузки (?)
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
where plan_post.plan_id=3 -- ОБР
  and plan_per.begin_date between FOR_TEMP.GET_AS_DATE('BEGIN_DATE','MASTER','raznar_mosk.xls') AND FOR_TEMP.GET_AS_DATE('END_DATE','MASTER','raznar_mosk.xls')
  and plan_pos.kod_sgr<>21
  and dogovor.isu_kod_dog like 'A%' --убираем из плана поставки на собственные нужды
GROUP BY
  kls_predpr.PREDPR_NAME,
  TO_CHAR(plan_per.num_plan),
  (case 
	   when to_number(to_char(plan_per.begin_date,'dd'))>=1 and to_number(to_char(plan_per.begin_date,'dd'))<=10 then 1
	   when to_number(to_char(plan_per.begin_date,'dd'))>10 and to_number(to_char(plan_per.begin_date,'dd'))<=20 then 2
	   else 3
	end),
  TO_CHAR(plan_per.date_plan,'YYYYMMDD'),   -- Дата отгрузки (?)
  oil_prod_grp.NAME_NPR,
  oil_prod.NAME_NPR
HAVING SUM(plan_post.plan_ves)<>0
ORDER BY "GR_PROD","PROD","PLAT" NULLS FIRST;


