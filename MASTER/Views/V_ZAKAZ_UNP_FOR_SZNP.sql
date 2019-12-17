--
-- V_ZAKAZ_UNP_FOR_SZNP  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_ZAKAZ_UNP_FOR_SZNP
(ZAKAZ_ID, ZAKAZ_HIST_ID, NAME, STAN_NAME, PROD_NAME, 
 POLUCH_NAME, VES)
AS 
select  
b.zakaz_id
,b.id as zakaz_hist_id
,'Заказ N '||a.client_number ||' от '||to_char(a.client_date,'dd.mm.yyyy')||' - '||to_char(b.load_ves)||' тн, '||KLS_STAN.STAN_NAME||', '||KLS_PROD.ABBR_NPR||', '||POLUCH.PREDPR_NAME as NAME
,KLS_STAN.STAN_NAME
,KLS_PROD.ABBR_NPR as PROD_NAME
,POLUCH.PREDPR_NAME as POLUCH_NAME
,B.LOAD_VES as ves
from zakaz a, zakaz_hist b, kls_prod, kls_stan, kls_predpr poluch 
where a.id=b.zakaz_id 
and a.date_plan=trunc(sysdate,'month') 
and a.is_agent=1 
and a.is_accept=1
and a.plat_id=10
and B.STATUS_ZAKAZ_ID=20
and a.prod_id_npr=KLS_PROD.ID_NPR (+)
and a.stan_id=kls_stan.id(+)
and a.poluch_id=poluch.id(+)
order by b.zakaz_id,b.sortby,b.id;


