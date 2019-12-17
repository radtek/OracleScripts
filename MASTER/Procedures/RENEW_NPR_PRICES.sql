--
-- RENEW_NPR_PRICES  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_NPR_PRICES (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='')IS
BEGIN
  return;
  
  UPDATE load_buffer.npr_cen SET time_='12:00:00' WHERE time_ is NULL;
  DELETE FROM load_buffer.npr_cen WHERE id=0 OR kod_npr is null or kod_npr='';
  UPDATE load_buffer.npr_cen SET kod_post=1 WHERE kod_post=0;
--- инсерт перед апдейтом это специально. Ради SUPPLIER_ID (VEV 27.6.2001)
  INSERT INTO npr_prices
    (id,cat_cen_id,prod_id_npr,cena,nds20,ngsm25,akciz,cena_otp,begin_date,input_date,ownership_id,supplier_id)
	(SELECT a.id,A.kateg_cen,a.kod_npr,a.cena,a.nds20,a.ndf25,a.akciz,a.cena_otp,a.date_dey,
	TO_DATE(TO_CHAR(a.date_,'dd.mm.yyyy ') || SUBSTR(a.TIME_,1,5),'dd.mm.yyyy hh24:mi'),var_real,1
	  FROM load_buffer.npr_cen A WHERE not exists (SELECT D.id FROM npr_prices D where D.id=a.id));

  UPDATE npr_prices
    set (cat_cen_id,prod_id_npr,cena,nds20,ngsm25,akciz,cena_otp,begin_date,input_date,ownership_id) =
	(SELECT A.kateg_cen,a.kod_npr,a.cena,a.nds20,a.ndf25,a.akciz,a.cena_otp,a.date_dey,
	TO_DATE(TO_CHAR(a.date_,'dd.mm.yyyy ') || SUBSTR(a.TIME_,1,5),'dd.mm.yyyy hh24:mi'),var_real
	  FROM load_buffer.npr_cen A WHERE A.id=npr_prices.id),
	supplier_id=(SELECT predpr_role.PREDPR_ID from predpr_role,load_buffer.npr_cen a
	   where predpr_role.KLS_ROLE_ID=1 and predpr_role.FOX_KOD=a.kod_post and a.id=npr_prices.id)
  where exists (SELECT B.id FROM load_buffer.npr_cen B where B.id=npr_prices.id );

  DELETE FROM npr_prices WHERE not exists (SELECT B.id FROM load_buffer.npr_cen B where B.id=npr_prices.id );
  COMMIT;

END RENEW_NPR_PRICES;
/

