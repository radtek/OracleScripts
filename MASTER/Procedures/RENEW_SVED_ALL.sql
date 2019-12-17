--
-- RENEW_SVED_ALL  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_SVED_ALL (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
  date_inc DATE;
  v_dat DATE;
BEGIN

UPDATE load_buffer.SVED SET timep='00:00' WHERE substr(timep,1,1)=' ' or timep is NULL OR TIMEP='24:00';
UPDATE load_buffer.SVED SET data_o=DATA WHERE data_o is NULL;
UPDATE load_buffer.SVED SET N_NAL='00:00' WHERE substr(N_NAL,1,1)=' ' or N_NAL is NULL OR n_nal='24:00' OR substr(N_NAL,1,1)='1';
UPDATE load_buffer.SVED SET N_NALD=DATA WHERE N_NALD is NULL;
UPDATE load_buffer.SVED SET K_NAL='00:00' WHERE substr(K_NAL,1,1)=' ' or K_NAL is NULL OR k_nal='24:00';
UPDATE load_buffer.SVED SET K_NALD=DATA WHERE K_NALD is NULL;
UPDATE load_buffer.SVED SET GOTOV='00:00' WHERE substr(GOTOV,1,1)=' ' or GOTOV is NULL OR gotov='24:00';
UPDATE load_buffer.SVED SET GOTOVD=DATA WHERE GOTOVD is NULL;

  -- Определение архивной даты  
  BEGIN
    SELECT ARH_DATE.LAST_DATE INTO v_dat
	  FROM ARH_DATE WHERE ARH_DATE.TABLENAME='KVIT';
  EXCEPTION 
    WHEN OTHERS THEN
	  v_dat:=TO_DATE('31.12.1899','dd.mm.yyyy');
  END;	  	    

UPDATE /*+ RULE */ master.SVED m_s SET
  (FLG_OPERDATA,SVED_NUM,SVED_DATE,SVED_VES,SVED_CNT,
   GOTOV_TIME,
   BEG_NALIV_TIME,
   END_NALIV_TIME,
   DATE_OFORML,
   PASP_ID,PROD_ID_NPR,MESTO_ID,NARIAD_ID) =
  (SELECT 0,S.NP,S.DATA,S.VES,S.KOL,
    TO_DATE(TO_CHAR(S.GOTOVD,'dd.mm.yyyy ') || SUBSTR(S.GOTOV,1,5),'dd.mm.yyyy hh24:mi'),
    TO_DATE(TO_CHAR(S.N_NALD,'dd.mm.yyyy ') || SUBSTR(S.N_NAL,1,5),'dd.mm.yyyy hh24:mi'),
    TO_DATE(TO_CHAR(S.K_NALD,'dd.mm.yyyy ') || SUBSTR(S.K_NAL,1,5),'dd.mm.yyyy hh24:mi'),
    TO_DATE(TO_CHAR(S.DATA_O,'dd.mm.yyyy ') || SUBSTR(S.TIMEP,1,5),'dd.mm.yyyy hh24:mi'),
	S.KODPASP,S.KOD_NPR,S.MESTO,S.NARIAD_ID 
   FROM load_buffer.SVED S WHERE S.SVED_ID=m_s.id)
  WHERE flg_operdata=0 AND FROM_DBF=1 AND
    exists (SELECT NULL FROM load_buffer.SVED l_s where l_s.SVED_ID=m_s.id)
    AND m_s.SVED_DATE BETWEEN date_beg AND date_end
	and m_s.SVED_DATE>v_dat;

INSERT INTO master.SVED
     (ID,FLG_OPERDATA,FROM_DBF,SVED_NUM,SVED_DATE,SVED_VES,SVED_CNT,
      GOTOV_TIME,
      BEG_NALIV_TIME,
      END_NALIV_TIME,
      DATE_OFORML,
      PASP_ID,PROD_ID_NPR,MESTO_ID,NARIAD_ID)
     (SELECT S.SVED_ID,0,1,S.NP,S.DATA,S.VES,S.KOL,
      TO_DATE(TO_CHAR(S.GOTOVD,'dd.mm.yyyy ') || SUBSTR(S.GOTOV,1,5),'dd.mm.yyyy hh24:mi'),
      TO_DATE(TO_CHAR(S.N_NALD,'dd.mm.yyyy ') || SUBSTR(S.N_NAL,1,5),'dd.mm.yyyy hh24:mi'),
      TO_DATE(TO_CHAR(S.K_NALD,'dd.mm.yyyy ') || SUBSTR(S.K_NAL,1,5),'dd.mm.yyyy hh24:mi'),
      TO_DATE(TO_CHAR(S.DATA_O,'dd.mm.yyyy ') || SUBSTR(S.TIMEP,1,5),'dd.mm.yyyy hh24:mi'),
      S.KODPASP,S.KOD_NPR,S.MESTO,S.NARIAD_ID FROM load_buffer.SVED S
	WHERE not exists (SELECT NULL FROM master.SVED m_s WHERE m_s.id=S.SVED_ID AND m_s.flg_operdata=0));

DELETE FROM master.SVED A WHERE A.FLG_OPERDATA=0 AND A.FROM_DBF=1 AND
   NOT EXISTS (SELECT S.SVED_ID from load_buffer.SVED S WHERE S.SVED_ID = A.id) AND
   A.SVED_DATE BETWEEN date_beg AND date_end
	and A.SVED_DATE>v_dat;
	
COMMIT;   
   
RENEW_KLS_VALSVED(DATE_BEG,DATE_END,param1,param2,param3);

RENEW_SVED_REESTR(DATE_BEG,DATE_END,param1,param2,param3);

UPDATE master.SVED m_s SET
  (DATE_EDIT) =
  (SELECT MAX(K.DATE_EDIT) FROM master.KVIT K WHERE K.SVED_ID=m_s.id AND K.FLG_OPERDATA=m_s.FLG_OPERDATA)
 WHERE m_s.flg_operdata=0 AND from_dbf=1 
    and exists (SELECT null FROM master.KVIT m_k where m_k.SVED_ID=m_s.id AND m_k.FLG_OPERDATA=m_s.FLG_OPERDATA)
    AND m_s.SVED_DATE BETWEEN date_beg AND date_end
	and m_s.SVED_DATE>v_dat;

COMMIT;

END RENEW_SVED_ALL;
/

