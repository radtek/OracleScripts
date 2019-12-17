--
-- RENEW_PODACHA  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Podacha (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
  vDateBeg DATE;
  vDateEnd DATE;
BEGIN

update load_buffer.podacha set time_pod='00:00' where substr(time_pod,1,1)=' ' or time_pod is NULL OR time_pod='24:00'; 
UPDATE load_buffer.podacha SET N_NAL='00:00' WHERE substr(N_NAL,1,1)=' ' or N_NAL is NULL OR n_nal='24:00';
UPDATE load_buffer.podacha SET K_NAL='00:00' WHERE substr(K_NAL,1,1)=' ' or K_NAL is NULL OR k_nal='24:00';
UPDATE load_buffer.podacha SET GOTOV='00:00' WHERE substr(GOTOV,1,1)=' ' or GOTOV is NULL OR gotov='24:00';

BEGIN
  SELECT MIN(DATE_POD),MAX(DATE_POD) INTO vDateBeg,vDateEnd
    FROM load_buffer.podacha;
  IF vDateBeg IS NULL OR vDateEnd IS NULL THEN
    RETURN;
  END IF;		
EXCEPTION
  WHEN OTHERS THEN
    RETURN;
END;		
  
-- Удаляем предыдущие подачи
DELETE FROM PODACHA WHERE pod_date>=vDateBeg AND pod_date<vDateEnd+1;

--- Добавляем новые подачи
INSERT INTO MASTER.PODACHA
     (ID, POD_NUM, POD_DATE, 
	  KOL, VES, GOTOV_DATE, 
	  NALIV_DATE, LUKOMA_NUM, MPS_NUM, SMN_NUM, GD_UVED_NUM, 
	  LOAD_TYPE_ID, VETKA_OTP_ID, MESTO_ID, USER_ID,END_NALIV_DATE)
    (SELECT DISTINCT TO_NUMBER(POD_ID), POD_NUM, TO_DATE(TO_CHAR(date_pod,'dd.mm.yyyy')||' '||time_pod,'dd.mm.yyyy hh24:mi:ss'),
	 POD_KOL, POD_VES,TO_DATE(TO_CHAR(gotovd,'dd.mm.yyyy')||' '||gotov,'dd.mm.yyyy hh24:mi:ss'),
	 TO_DATE(TO_CHAR(n_nald,'dd.mm.yyyy')||' '||n_nal,'dd.mm.yyyy hh24:mi:ss'),NUM_LUKOMA,NUM_MPS, NUM_SMN, NUM_UVED,
	 TIP_OTGR, GD_TRACK,  MESTO, KOD_OPER,
	 TO_DATE(TO_CHAR(k_nald,'dd.mm.yyyy')||' '||k_nal,'dd.mm.yyyy hh24:mi:ss')
     FROM load_buffer.podacha);

--- Добавляем новые подачи
INSERT INTO MASTER.PODACHA_ROWS
   (ID, PODACHA_ID, NUM_POS, NUM_CIST, KALIBR_ID, VAGOWNER_ID, AXES, CAPACITY, VAGONTYPE_ID, NCISTDOP, VAG_STATUS_ID, 
    DEFI_MASS_ID, VETKA_POD_ID, VES, KOL_NET, VES_BRUTTO, VES_CIST, ZPU_TYPE1, ZPU_TYPE2, PLOMBA1, PLOMBA2, 
	VZLIV, VOLUME, TEMPER, PL20, FACT_PL, PASP_ID, PASP_NUM, PASP_DATE, REZ_NUM, PROD_ID_NPR, NOM_ZD, SVED_NUM, SVED_DATE)
(SELECT /*+ RULE */ ID, TO_NUMBER(POD_ID), POD_ORD, NUM_OTGR, TIP, TIPV, OSC, WES, RODV,NCISTDOP, ERROR, 
    DEFI_MASS,100+PODPUT, VES, KOL_NET,KOL_ALL,TARA_ALL,ZPU_TYPE1, ZPU_TYPE2,PLOMBA1, PLOMBA2,  
	VZLIV, OBIEM, TEMPER, PL, XPL,KODPASP,NUM_PASP, DINS, NUM_REZ,KOD_NPR,NOM_ZD,NP,DATE_OTGR
  FROM load_buffer.podacha); 

COMMIT;

END Renew_Podacha;

/

