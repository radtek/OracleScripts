--
-- TRG_AIUDR_NPR_PRICES  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_NPR_PRICES
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.NPR_PRICES
FOR EACH ROW
DECLARE
  v_old NPR_PRICES%ROWTYPE;
  v_new NPR_PRICES%ROWTYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.CAT_CEN_ID := :OLD.CAT_CEN_ID;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.CENA := :OLD.CENA;
    v_old.NDS20 := :OLD.NDS20;
    v_old.NGSM25 := :OLD.NGSM25;
    v_old.AKCIZ := :OLD.AKCIZ;
    v_old.CENA_OTP := :OLD.CENA_OTP;
    v_old.BEGIN_DATE := :OLD.BEGIN_DATE;
    v_old.END_DATE := :OLD.END_DATE;
    v_old.INPUT_DATE := :OLD.INPUT_DATE;
    v_old.OWNERSHIP_ID := :OLD.OWNERSHIP_ID;
    v_old.SUPPLIER_ID := :OLD.SUPPLIER_ID;
    v_old.PROTOKOL_DATE := :OLD.PROTOKOL_DATE;
    v_old.PROTOKOL_NUM := :OLD.PROTOKOL_NUM;
    v_old.IS_ORIGINAL := :OLD.IS_ORIGINAL;
    v_old.PROTOKOL_BEGIN_DATE := :OLD.PROTOKOL_BEGIN_DATE;
    v_old.NDS20_NPO := :OLD.NDS20_NPO;
    v_old.CENA_NPO := :OLD.CENA_NPO;
    v_old.CENA_OTP_NPO := :OLD.CENA_OTP_NPO;
    v_old.NO_AKCIZ := :OLD.NO_AKCIZ;
    v_old.CENA_BN := :OLD.CENA_BN;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
    -- Запись в лог
    IF 1=1 THEN
      SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
      INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
        SELECT LogId,'NPR_PRICES',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D'
          FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
    END IF;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.CAT_CEN_ID := :NEW.CAT_CEN_ID;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.CENA := :NEW.CENA;
    v_new.NDS20 := :NEW.NDS20;
    v_new.NGSM25 := :NEW.NGSM25;
    v_new.AKCIZ := :NEW.AKCIZ;
    v_new.CENA_OTP := :NEW.CENA_OTP;
    v_new.BEGIN_DATE := :NEW.BEGIN_DATE;
    v_new.END_DATE := :NEW.END_DATE;
    v_new.INPUT_DATE := :NEW.INPUT_DATE;
    v_new.OWNERSHIP_ID := :NEW.OWNERSHIP_ID;
    v_new.SUPPLIER_ID := :NEW.SUPPLIER_ID;
    v_new.PROTOKOL_DATE := :NEW.PROTOKOL_DATE;
    v_new.PROTOKOL_NUM := :NEW.PROTOKOL_NUM;
    v_new.IS_ORIGINAL := :NEW.IS_ORIGINAL;
    v_new.PROTOKOL_BEGIN_DATE := :NEW.PROTOKOL_BEGIN_DATE;
    v_new.NDS20_NPO := :NEW.NDS20_NPO;
    v_new.CENA_NPO := :NEW.CENA_NPO;
    v_new.CENA_OTP_NPO := :NEW.CENA_OTP_NPO;
    v_new.NO_AKCIZ := :NEW.NO_AKCIZ;
    v_new.CENA_BN := :NEW.CENA_BN;

    -- После обновления
    IF UPDATING() THEN
      NULL;
      -- Запись в лог
      IF V_OLD.ID<>V_NEW.ID THEN
        -- Изменился PRIMARY KEY, добавляем в лог 2 записи
        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'NPR_PRICES',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;

        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'NPR_PRICES',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;
      ELSE
        -- PRIMARY KEY не изменился, добавляем в лог 1 запись
        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
            SELECT LogId,'NPR_PRICES',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'U',EMPTY_CLOB()
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');

          SELECT WhatWasDone INTO cl_WhatWasDone
            FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG
            WHERE ID = LogId
            FOR UPDATE;

          WritePos:=1;

          IF V_OLD.ID<>V_NEW.ID THEN
            WriteStr:=':OLD.ID=' || TO_CHAR(V_OLD.ID) || ' :NEW.ID=' || TO_CHAR(V_NEW.ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.CAT_CEN_ID<>V_NEW.CAT_CEN_ID THEN
            WriteStr:=':OLD.CAT_CEN_ID=' || TO_CHAR(V_OLD.CAT_CEN_ID) || ' :NEW.CAT_CEN_ID=' || TO_CHAR(V_NEW.CAT_CEN_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PROD_ID_NPR<>V_NEW.PROD_ID_NPR THEN
            WriteStr:=':OLD.PROD_ID_NPR=' || (V_OLD.PROD_ID_NPR) || ' :NEW.PROD_ID_NPR=' || (V_NEW.PROD_ID_NPR) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.CENA<>V_NEW.CENA THEN
            WriteStr:=':OLD.CENA=' || TO_CHAR(V_OLD.CENA) || ' :NEW.CENA=' || TO_CHAR(V_NEW.CENA) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NDS20<>V_NEW.NDS20 THEN
            WriteStr:=':OLD.NDS20=' || TO_CHAR(V_OLD.NDS20) || ' :NEW.NDS20=' || TO_CHAR(V_NEW.NDS20) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NGSM25<>V_NEW.NGSM25 THEN
            WriteStr:=':OLD.NGSM25=' || TO_CHAR(V_OLD.NGSM25) || ' :NEW.NGSM25=' || TO_CHAR(V_NEW.NGSM25) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.AKCIZ<>V_NEW.AKCIZ THEN
            WriteStr:=':OLD.AKCIZ=' || TO_CHAR(V_OLD.AKCIZ) || ' :NEW.AKCIZ=' || TO_CHAR(V_NEW.AKCIZ) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.CENA_OTP<>V_NEW.CENA_OTP THEN
            WriteStr:=':OLD.CENA_OTP=' || TO_CHAR(V_OLD.CENA_OTP) || ' :NEW.CENA_OTP=' || TO_CHAR(V_NEW.CENA_OTP) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.BEGIN_DATE<>V_NEW.BEGIN_DATE THEN
            WriteStr:=':OLD.BEGIN_DATE=' || TO_CHAR(V_OLD.BEGIN_DATE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.BEGIN_DATE=' || TO_CHAR(V_NEW.BEGIN_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.END_DATE<>V_NEW.END_DATE THEN
            WriteStr:=':OLD.END_DATE=' || TO_CHAR(V_OLD.END_DATE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.END_DATE=' || TO_CHAR(V_NEW.END_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.INPUT_DATE<>V_NEW.INPUT_DATE THEN
            WriteStr:=':OLD.INPUT_DATE=' || TO_CHAR(V_OLD.INPUT_DATE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.INPUT_DATE=' || TO_CHAR(V_NEW.INPUT_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.OWNERSHIP_ID<>V_NEW.OWNERSHIP_ID THEN
            WriteStr:=':OLD.OWNERSHIP_ID=' || TO_CHAR(V_OLD.OWNERSHIP_ID) || ' :NEW.OWNERSHIP_ID=' || TO_CHAR(V_NEW.OWNERSHIP_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SUPPLIER_ID<>V_NEW.SUPPLIER_ID THEN
            WriteStr:=':OLD.SUPPLIER_ID=' || TO_CHAR(V_OLD.SUPPLIER_ID) || ' :NEW.SUPPLIER_ID=' || TO_CHAR(V_NEW.SUPPLIER_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PROTOKOL_DATE<>V_NEW.PROTOKOL_DATE THEN
            WriteStr:=':OLD.PROTOKOL_DATE=' || TO_CHAR(V_OLD.PROTOKOL_DATE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.PROTOKOL_DATE=' || TO_CHAR(V_NEW.PROTOKOL_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PROTOKOL_NUM<>V_NEW.PROTOKOL_NUM THEN
            WriteStr:=':OLD.PROTOKOL_NUM=' || (V_OLD.PROTOKOL_NUM) || ' :NEW.PROTOKOL_NUM=' || (V_NEW.PROTOKOL_NUM) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.IS_ORIGINAL<>V_NEW.IS_ORIGINAL THEN
            WriteStr:=':OLD.IS_ORIGINAL=' || TO_CHAR(V_OLD.IS_ORIGINAL) || ' :NEW.IS_ORIGINAL=' || TO_CHAR(V_NEW.IS_ORIGINAL) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PROTOKOL_BEGIN_DATE<>V_NEW.PROTOKOL_BEGIN_DATE THEN
            WriteStr:=':OLD.PROTOKOL_BEGIN_DATE=' || TO_CHAR(V_OLD.PROTOKOL_BEGIN_DATE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.PROTOKOL_BEGIN_DATE=' || TO_CHAR(V_NEW.PROTOKOL_BEGIN_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NDS20_NPO<>V_NEW.NDS20_NPO THEN
            WriteStr:=':OLD.NDS20_NPO=' || TO_CHAR(V_OLD.NDS20_NPO) || ' :NEW.NDS20_NPO=' || TO_CHAR(V_NEW.NDS20_NPO) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.CENA_NPO<>V_NEW.CENA_NPO THEN
            WriteStr:=':OLD.CENA_NPO=' || TO_CHAR(V_OLD.CENA_NPO) || ' :NEW.CENA_NPO=' || TO_CHAR(V_NEW.CENA_NPO) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.CENA_OTP_NPO<>V_NEW.CENA_OTP_NPO THEN
            WriteStr:=':OLD.CENA_OTP_NPO=' || TO_CHAR(V_OLD.CENA_OTP_NPO) || ' :NEW.CENA_OTP_NPO=' || TO_CHAR(V_NEW.CENA_OTP_NPO) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NO_AKCIZ<>V_NEW.NO_AKCIZ THEN
            WriteStr:=':OLD.NO_AKCIZ=' || TO_CHAR(V_OLD.NO_AKCIZ) || ' :NEW.NO_AKCIZ=' || TO_CHAR(V_NEW.NO_AKCIZ) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.CENA_BN<>V_NEW.CENA_BN THEN
            WriteStr:=':OLD.CENA_BN=' || TO_CHAR(V_OLD.CENA_BN) || ' :NEW.CENA_BN=' || TO_CHAR(V_NEW.CENA_BN) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
        END IF;
      END IF;
    END IF;

    -- После добавления
    IF INSERTING() THEN
      NULL;
      -- Запись в лог
      IF 1=1 THEN
        SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
        INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
          SELECT LogId,'NPR_PRICES',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
            FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
      END IF;
    END IF;

  END IF;
END;
/


