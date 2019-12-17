--
-- V_SLIV_NEFT_MOS  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_SLIV_NEFT_MOS
(PROD_ID_NPR, STAN_OTP_NAME, SVED_NUM, NUM_KVIT_TXT, DATE_KVIT, 
 VES_KVIT, DATE_IN_STAN, SVED_DATE, NUM_CIST, KALIBR_ID)
AS 
select 
  a.prod_id_npr, 
  (CASE 
     WHEN a.prod_id_npr='90002' then '”синск' 
     WHEN a.prod_id_npr='90004' then 'ярега' 
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
order by sved_date,sved_num,date_kvit,num_kvit_txt,sved_pos;


