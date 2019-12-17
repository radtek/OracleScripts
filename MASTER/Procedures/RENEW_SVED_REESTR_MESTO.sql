--
-- RENEW_SVED_REESTR_MESTO  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_SVED_REESTR_MESTO (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
  date_inc DATE;
  vMesto NUMBER;
  vType NUMBER;
BEGIN

IF param1 || ' ' =' ' THEN --- место не указано
  RETURN;
ELSE
  vMesto:=TO_NUMBER(param1);
END IF;

IF param2 || ' ' =' ' THEN --- тип оперативки
  vType:=0;
ELSE
  vType:=TO_NUMBER(param2);
END IF;

UPDATE load_buffer.SVED_REESTR SET timep='00:00' WHERE substr(timep,1,1)=' ' or timep is NULL  OR TIMEP='24:00';
UPDATE load_buffer.SVED_REESTR SET data_o=DATA WHERE data_o is NULL;
UPDATE load_buffer.SVED_REESTR SET N_NAL='00:00' WHERE substr(N_NAL,1,1)=' ' or N_NAL is NULL OR n_nal='24:00' OR substr(N_NAL,1,1)='1';
UPDATE load_buffer.SVED_REESTR SET N_NALD=DATA WHERE N_NALD is NULL;
UPDATE load_buffer.SVED_REESTR SET K_NAL='00:00' WHERE substr(K_NAL,1,1)=' ' or K_NAL is NULL OR K_NAL='24:00';
UPDATE load_buffer.SVED_REESTR SET K_NALD=DATA WHERE K_NALD is NULL;
UPDATE load_buffer.SVED_REESTR SET GOTOV='00:00' WHERE substr(GOTOV,1,1)=' ' or GOTOV is NULL OR GOTOV='24:00';
UPDATE load_buffer.SVED_REESTR SET GOTOVD=DATA WHERE GOTOVD is NULL;

UPDATE master.SVED SET
  (SVED_NUM,SVED_DATE,SVED_VES,SVED_CNT,
   GOTOV_TIME,
   BEG_NALIV_TIME,
   END_NALIV_TIME,
   DATE_OFORML,
   PASP_ID,PROD_ID_NPR,MESTO_ID,NARIAD_ID) =
   (SELECT S.NP,S.DATA,S.VES,S.KOL,
      TO_DATE(TO_CHAR(S.GOTOVD,'dd.mm.yyyy ') || SUBSTR(S.GOTOV,1,5),'dd.mm.yyyy hh24:mi'),
      TO_DATE(TO_CHAR(S.N_NALD,'dd.mm.yyyy ') || SUBSTR(S.N_NAL,1,5),'dd.mm.yyyy hh24:mi'),
      TO_DATE(TO_CHAR(S.K_NALD,'dd.mm.yyyy ') || SUBSTR(S.K_NAL,1,5),'dd.mm.yyyy hh24:mi'),
      TO_DATE(TO_CHAR(S.DATA_O,'dd.mm.yyyy ') || SUBSTR(S.TIMEP,1,5),'dd.mm.yyyy hh24:mi'),
	  S.KODPASP,S.KOD_NPR,S.MESTO,S.NARIAD_ID
    FROM load_buffer.SVED_REESTR S WHERE S.SVED_ID=master.SVED.id AND S.MESTO=vMesto)
  WHERE MASTER.SVED.FLG_OPERDATA=1 AND MASTER.SVED.FROM_DBF=1 AND MASTER.SVED.MESTO_ID=vMesto AND
        exists (SELECT A.SVED_ID FROM load_buffer.SVED_REESTR A
		        WHERE A.SVED_ID=master.SVED.id AND A.MESTO=vMesto);

INSERT INTO master.SVED
     (ID,FLG_OPERDATA,FROM_DBF,SVED_NUM,SVED_DATE,SVED_VES,SVED_CNT,
      GOTOV_TIME,
      BEG_NALIV_TIME,
      END_NALIV_TIME,
      DATE_OFORML,
      PASP_ID,PROD_ID_NPR,MESTO_ID,NARIAD_ID)
     (SELECT S.SVED_ID,1,1,S.NP,S.DATA,S.VES,S.KOL,
      TO_DATE(TO_CHAR(S.GOTOVD,'dd.mm.yyyy ') || SUBSTR(S.GOTOV,1,5),'dd.mm.yyyy hh24:mi'),
      TO_DATE(TO_CHAR(S.N_NALD,'dd.mm.yyyy ') || SUBSTR(S.N_NAL,1,5),'dd.mm.yyyy hh24:mi'),
      TO_DATE(TO_CHAR(S.K_NALD,'dd.mm.yyyy ') || SUBSTR(S.K_NAL,1,5),'dd.mm.yyyy hh24:mi'),
      TO_DATE(TO_CHAR(S.DATA_O,'dd.mm.yyyy ') || SUBSTR(S.TIMEP,1,5),'dd.mm.yyyy hh24:mi'),
      S.KODPASP,S.KOD_NPR,S.MESTO,S.NARIAD_ID FROM load_buffer.SVED_REESTR S
	WHERE S.MESTO=vMesto AND
	      not exists (SELECT A.id FROM master.SVED A WHERE A.id=S.SVED_ID AND A.MESTO_ID=vMesto AND A.FLG_OPERDATA=1));

--- Удаляем записи из SVED_REESTR
IF vType=0 THEN  --- Если полная оперативка
  DELETE FROM master.SVED A WHERE A.FLG_OPERDATA=1 AND A.FROM_DBF=1 AND A.Mesto_id=vMesto AND
     (NOT EXISTS (SELECT S.SVED_ID from load_buffer.SVED_REESTR S WHERE S.SVED_ID = A.id) OR
      EXISTS (SELECT k.ID from master.SVED k WHERE k.FLG_OPERDATA=0 AND k.ID=A.ID));
ELSE  --- Если краткая оперативка
  DELETE FROM master.SVED A WHERE A.FLG_OPERDATA=1 AND A.FROM_DBF=1 AND A.Mesto_id=vMesto AND
     (EXISTS (SELECT k.ID from master.SVED k WHERE k.FLG_OPERDATA=0 AND k.ID=A.ID));
END IF;
COMMIT;

RENEW_KLS_VALSVED_REESTR_MESTO(DATE_BEG,DATE_END,param1,param2,param3);

UPDATE master.SVED SET
  (DATE_EDIT) =
  (SELECT MAX(K.DATE_EDIT) FROM master.KVIT K WHERE K.SVED_ID=master.SVED.id AND K.FLG_OPERDATA=master.SVED.FLG_OPERDATA AND K.Mesto_id=MASTER.SVED.MESTO_ID)
 WHERE master.SVED.flg_operdata=1 AND master.SVED.FROM_DBF=1 AND MASTER.SVED.MESTO_ID=vMesto
   AND exists (SELECT null FROM master.KVIT where master.KVIT.SVED_ID=master.SVED.id AND master.KVIT.FLG_OPERDATA=master.SVED.FLG_OPERDATA AND master.KVIT.Mesto_id=MASTER.SVED.MESTO_ID);
COMMIT;

END RENEW_SVED_REESTR_MESTO;

/

