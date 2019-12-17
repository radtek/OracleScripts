--
-- TRG_AIUDR_PAYMENTS  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_PAYMENTS
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.PAYMENTS
FOR EACH ROW
DECLARE
  v_old PAYMENTS%ROWTYPE;
  v_new PAYMENTS%ROWTYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.DOG_ID := :OLD.DOG_ID;
    v_old.BANK_ID := :OLD.BANK_ID;
    v_old.RS := :OLD.RS;
    v_old.SUMMA := :OLD.SUMMA;
    v_old.NAZN_PLAT := :OLD.NAZN_PLAT;
    v_old.OURBANK_ID := :OLD.OURBANK_ID;
    v_old.NUM_PLAT := :OLD.NUM_PLAT;
    v_old.DATE_PLAT := :OLD.DATE_PLAT;
    v_old.PAYFORM_ID := :OLD.PAYFORM_ID;
    v_old.DATE_POST := :OLD.DATE_POST;
    v_old.DEST_ID := :OLD.DEST_ID;
    v_old.RS_ID := :OLD.RS_ID;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
    -- Запись в лог
    IF 1=1 THEN
      SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
      INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
        SELECT LogId,'PAYMENTS',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D'
          FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
    END IF;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.DOG_ID := :NEW.DOG_ID;
    v_new.BANK_ID := :NEW.BANK_ID;
    v_new.RS := :NEW.RS;
    v_new.SUMMA := :NEW.SUMMA;
    v_new.NAZN_PLAT := :NEW.NAZN_PLAT;
    v_new.OURBANK_ID := :NEW.OURBANK_ID;
    v_new.NUM_PLAT := :NEW.NUM_PLAT;
    v_new.DATE_PLAT := :NEW.DATE_PLAT;
    v_new.PAYFORM_ID := :NEW.PAYFORM_ID;
    v_new.DATE_POST := :NEW.DATE_POST;
    v_new.DEST_ID := :NEW.DEST_ID;
    v_new.RS_ID := :NEW.RS_ID;

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
            SELECT LogId,'PAYMENTS',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;

        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'PAYMENTS',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;
      ELSE
        -- PRIMARY KEY не изменился, добавляем в лог 1 запись
        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
            SELECT LogId,'PAYMENTS',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'U',EMPTY_CLOB()
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
          IF V_OLD.DOG_ID<>V_NEW.DOG_ID THEN
            WriteStr:=':OLD.DOG_ID=' || TO_CHAR(V_OLD.DOG_ID) || ' :NEW.DOG_ID=' || TO_CHAR(V_NEW.DOG_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.BANK_ID<>V_NEW.BANK_ID THEN
            WriteStr:=':OLD.BANK_ID=' || TO_CHAR(V_OLD.BANK_ID) || ' :NEW.BANK_ID=' || TO_CHAR(V_NEW.BANK_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.RS<>V_NEW.RS THEN
            WriteStr:=':OLD.RS=' || (V_OLD.RS) || ' :NEW.RS=' || (V_NEW.RS) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SUMMA<>V_NEW.SUMMA THEN
            WriteStr:=':OLD.SUMMA=' || TO_CHAR(V_OLD.SUMMA) || ' :NEW.SUMMA=' || TO_CHAR(V_NEW.SUMMA) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NAZN_PLAT<>V_NEW.NAZN_PLAT THEN
            WriteStr:=':OLD.NAZN_PLAT=' || (V_OLD.NAZN_PLAT) || ' :NEW.NAZN_PLAT=' || (V_NEW.NAZN_PLAT) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.OURBANK_ID<>V_NEW.OURBANK_ID THEN
            WriteStr:=':OLD.OURBANK_ID=' || TO_CHAR(V_OLD.OURBANK_ID) || ' :NEW.OURBANK_ID=' || TO_CHAR(V_NEW.OURBANK_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NUM_PLAT<>V_NEW.NUM_PLAT THEN
            WriteStr:=':OLD.NUM_PLAT=' || (V_OLD.NUM_PLAT) || ' :NEW.NUM_PLAT=' || (V_NEW.NUM_PLAT) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DATE_PLAT<>V_NEW.DATE_PLAT THEN
            WriteStr:=':OLD.DATE_PLAT=' || TO_CHAR(V_OLD.DATE_PLAT,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_PLAT=' || TO_CHAR(V_NEW.DATE_PLAT,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PAYFORM_ID<>V_NEW.PAYFORM_ID THEN
            WriteStr:=':OLD.PAYFORM_ID=' || TO_CHAR(V_OLD.PAYFORM_ID) || ' :NEW.PAYFORM_ID=' || TO_CHAR(V_NEW.PAYFORM_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DATE_POST<>V_NEW.DATE_POST THEN
            WriteStr:=':OLD.DATE_POST=' || TO_CHAR(V_OLD.DATE_POST,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_POST=' || TO_CHAR(V_NEW.DATE_POST,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DEST_ID<>V_NEW.DEST_ID THEN
            WriteStr:=':OLD.DEST_ID=' || TO_CHAR(V_OLD.DEST_ID) || ' :NEW.DEST_ID=' || TO_CHAR(V_NEW.DEST_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.RS_ID<>V_NEW.RS_ID THEN
            WriteStr:=':OLD.RS_ID=' || TO_CHAR(V_OLD.RS_ID) || ' :NEW.RS_ID=' || TO_CHAR(V_NEW.RS_ID) || CHR(13);
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
          SELECT LogId,'PAYMENTS',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
            FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
      END IF;
    END IF;

  END IF;
END;
/


