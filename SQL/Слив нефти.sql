-- Реестр 
create or replace view v_reestr_sliv_neft as 
select
  a.prod_id_npr,
  (CASE
     WHEN a.prod_id_npr='90002' then 'Усинск'
     WHEN a.prod_id_npr='90004' then 'Ярега'
	 ELSE ''
   END) as STAN_OTP_NAME,	 
  a.sved_date,
  b.NUM_KVIT_TXT,
  b.num_cist,
  ROUND(b.VES_NETTO,3) as ves_netto,
  ROUND(b.VES_NETTO_KVIT/1000,3) as ves_netto_kvit
from (select * from V_MASTER_REPORTS where UPPER(REPORT_FILE)='REESTR_SLIV_NEFT.XLS') r,
     sved_in a,reestr_in b
where a.id=b.sved_in_id
and a.sved_date between r.begin_date and r.end_date
and a.prod_id_npr=r.PROD_ID_NPR
order by sved_date,num_kvit_txt,sved_num,sved_pos  
  


-- Данные по сливу нефти
create or replace view v_sliv_neft_mos as 
select
  a.prod_id_npr,
  (CASE
     WHEN a.prod_id_npr='90002' then 'Усинск'
     WHEN a.prod_id_npr='90004' then 'Ярега'
	 ELSE ''
   END) as STAN_OTP_NAME,	 
  a.sved_num,
  b.NUM_KVIT_TXT,
  date_kvit, 
  ROUND(b.VES_KVIT/1000,3) as ves_kvit,
  DATE_IN_STAN,
  a.sved_date,
  b.num_cist,
  kalibr_id
from (select * from V_MASTER_REPORTS where UPPER(REPORT_FILE)='SLIV_NEFT_MOS.XLS') r,
     sved_in a,reestr_in b
where a.id=b.sved_in_id
and a.sved_date between r.begin_date and r.end_date
and a.prod_id_npr='90002'
order by sved_date,sved_num,date_kvit,num_kvit_txt,sved_pos

 
 
-- Справка о расхождениях
create or replace view v_sliv_neft_otkl as 
select
  a.prod_id_npr,
  (CASE
     WHEN a.prod_id_npr='90002' then 'Усинск'
     WHEN a.prod_id_npr='90004' then 'Ярега'
	 ELSE ''
   END) as STAN_OTP_NAME,	 
  date_kvit, 
  DATE_IN_STAN,
  a.sved_date,
  b.NUM_KVIT_TXT,
  b.num_cist,
  kalibr_id,
  ROUND(b.VES_KVIT/1000,3) as ves_kvit,
  ROUND(b.VES_NETTO_KVIT/1000,3) as ves_netto_kvit,
  ROUND(b.VES,7) as ves,
  ROUND(b.VES_NETTO,7) as ves_netto
from (select * from V_MASTER_REPORTS where UPPER(REPORT_FILE)='SLIV_NEFT_OTKL.XLS') r,
     sved_in a,reestr_in b
where a.id=b.sved_in_id
and a.sved_date=r.end_date
and a.prod_id_npr='90002'
order by sved_date,date_kvit,num_kvit_txt,sved_num,sved_pos

 
-- Базовый запрос
select
  sved_num,
  NUM_KVIT_TXT,
  date_kvit, 
  b.VES_KVIT/1000 as ves_kvit,
  b.VES_NETTO_KVIT/1000 as ves_netto_kvit,
  b.VES as ves,
  b.VES_NETTO as ves_netto,
  DATE_IN_STAN,
  sved_date,
  num_cist,
  kalibr_id
from sved_in a,reestr_in b
where a.id=b.sved_in_id
and a.sved_date between to_date('01.03.2006','dd.mm.yyyy') and to_date('28.03.2006','dd.mm.yyyy')
and a.prod_id_npr='90002'
order by sved_num,sved_pos   
  
