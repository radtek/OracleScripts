--
-- V_ZAKAZ_DECADS  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_ZAKAZ_DECADS
(PREDPR_NAME, GROUP_NAME, NAME_NPR, DATE_, VES, 
 DECADE_)
AS 
select 
  a.PREDPR_NAME,
  a.GROUP_NAME,
  a.NAME_NPR,
  a.DATE_ as date_,
  round(a.VES / c.ves * b.ves,1) as ves,
  a.decade_
from 
  v_ZAKAZ_DECADS_UNP a, 
  (
  select
   predpr_id,
   prod_id_npr,
   sum(ves) as ves
  from v_ZAKAZ_DECADS_SNP
  group by  
   predpr_id,
   prod_id_npr
  ) b,
  (select
   predpr_id,
   prod_id_npr,
   sum(ves) as ves
  from v_ZAKAZ_DECADS_UNP
  group by  
   predpr_id,
   prod_id_npr
  ) c   
where
b.PREDPR_ID=a.PREDPR_ID and
b.PROD_ID_NPR=a.PROD_ID_NPR and
a.PREDPR_ID=c.PREDPR_ID and
a.PROD_ID_NPR=c.PROD_ID_NPR
order by predpr_name,decade_,date_,group_name,name_npr;


