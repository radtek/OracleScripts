--
-- V_SLIV_NEFT_OTKL  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_SLIV_NEFT_OTKL
(PROD_ID_NPR, STAN_OTP_NAME, DATE_KVIT, DATE_IN_STAN, SVED_DATE, 
 NUM_KVIT_TXT, NUM_CIST, KALIBR_ID, VES_KVIT, VES_NETTO_KVIT, 
 VES, VES_NETTO)
AS 
select 
  a.prod_id_npr, 
  (CASE 
     WHEN a.prod_id_npr='90002' then '”синск' 
     WHEN a.prod_id_npr='90004' then 'ярега' 
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
order by sved_date,date_kvit,num_kvit_txt,sved_num,sved_pos;


