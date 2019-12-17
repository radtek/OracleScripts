--
-- V_REESTR_SLIV_NEFT  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_REESTR_SLIV_NEFT
(PROD_ID_NPR, STAN_OTP_NAME, SVED_DATE, NUM_KVIT_TXT, NUM_CIST, 
 VES_NETTO, VES_NETTO_KVIT)
AS 
select 
  a.prod_id_npr, 
  (CASE 
     WHEN a.prod_id_npr='90002' then '”синск' 
     WHEN a.prod_id_npr='90004' then 'ярега' 
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
order by sved_date,num_kvit_txt,sved_num,sved_pos;


