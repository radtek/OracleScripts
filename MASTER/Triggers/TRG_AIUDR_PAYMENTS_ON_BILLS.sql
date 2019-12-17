--
-- TRG_AIUDR_PAYMENTS_ON_BILLS  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_PAYMENTS_ON_BILLS
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.PAYMENTS_ON_BILLS
FOR EACH ROW
DECLARE
  v_old PAYMENTS_ON_BILLS%ROWTYPE;
  v_new PAYMENTS_ON_BILLS%ROWTYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.NOM_DOK := :OLD.NOM_DOK;
    v_old.BILL_POS_ID := :OLD.BILL_POS_ID;
    v_old.PAYMENTS_ID := :OLD.PAYMENTS_ID;
    v_old.SUMMA := :OLD.SUMMA;
    v_old.DATE_REALIZ := :OLD.DATE_REALIZ;
    v_old.SUMMA_NDS := :OLD.SUMMA_NDS;
    v_old.SUMMA_AKCIZ := :OLD.SUMMA_AKCIZ;
    v_old.VES := :OLD.VES;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
    -- Запись в лог
    IF 1=1 THEN
      SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
      INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
        SELECT LogId,'PAYMENTS_ON_BILLS',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D',EMPTY_CLOB()
          FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');

      SELECT WhatWasDone INTO cl_WhatWasDone
        FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG
        WHERE ID = LogId
        FOR UPDATE;

      WritePos:=1;
      WriteStr:='NOM_DOK=' || TO_CHAR(V_OLD.NOM_DOK) || ' BILL_POS_ID=' || TO_CHAR(V_OLD.BILL_POS_ID) || ' PAYMENTS_ID=' || TO_CHAR(V_OLD.PAYMENTS_ID) || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
    END IF;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.NOM_DOK := :NEW.NOM_DOK;
    v_new.BILL_POS_ID := :NEW.BILL_POS_ID;
    v_new.PAYMENTS_ID := :NEW.PAYMENTS_ID;
    v_new.SUMMA := :NEW.SUMMA;
    v_new.DATE_REALIZ := :NEW.DATE_REALIZ;
    v_new.SUMMA_NDS := :NEW.SUMMA_NDS;
    v_new.SUMMA_AKCIZ := :NEW.SUMMA_AKCIZ;
    v_new.VES := :NEW.VES;

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
            SELECT LogId,'PAYMENTS_ON_BILLS',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;

        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'PAYMENTS_ON_BILLS',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;
      ELSE
        -- PRIMARY KEY не изменился, добавляем в лог 1 запись
        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
            SELECT LogId,'PAYMENTS_ON_BILLS',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'U',EMPTY_CLOB()
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
          IF V_OLD.NOM_DOK<>V_NEW.NOM_DOK THEN
            WriteStr:=':OLD.NOM_DOK=' || TO_CHAR(V_OLD.NOM_DOK) || ' :NEW.NOM_DOK=' || TO_CHAR(V_NEW.NOM_DOK) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.BILL_POS_ID<>V_NEW.BILL_POS_ID THEN
            WriteStr:=':OLD.BILL_POS_ID=' || TO_CHAR(V_OLD.BILL_POS_ID) || ' :NEW.BILL_POS_ID=' || TO_CHAR(V_NEW.BILL_POS_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PAYMENTS_ID<>V_NEW.PAYMENTS_ID THEN
            WriteStr:=':OLD.PAYMENTS_ID=' || TO_CHAR(V_OLD.PAYMENTS_ID) || ' :NEW.PAYMENTS_ID=' || TO_CHAR(V_NEW.PAYMENTS_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SUMMA<>V_NEW.SUMMA THEN
            WriteStr:=':OLD.SUMMA=' || TO_CHAR(V_OLD.SUMMA) || ' :NEW.SUMMA=' || TO_CHAR(V_NEW.SUMMA) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DATE_REALIZ<>V_NEW.DATE_REALIZ THEN
            WriteStr:=':OLD.DATE_REALIZ=' || TO_CHAR(V_OLD.DATE_REALIZ,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_REALIZ=' || TO_CHAR(V_NEW.DATE_REALIZ,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SUMMA_NDS<>V_NEW.SUMMA_NDS THEN
            WriteStr:=':OLD.SUMMA_NDS=' || TO_CHAR(V_OLD.SUMMA_NDS) || ' :NEW.SUMMA_NDS=' || TO_CHAR(V_NEW.SUMMA_NDS) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SUMMA_AKCIZ<>V_NEW.SUMMA_AKCIZ THEN
            WriteStr:=':OLD.SUMMA_AKCIZ=' || TO_CHAR(V_OLD.SUMMA_AKCIZ) || ' :NEW.SUMMA_AKCIZ=' || TO_CHAR(V_NEW.SUMMA_AKCIZ) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.VES<>V_NEW.VES THEN
            WriteStr:=':OLD.VES=' || TO_CHAR(V_OLD.VES) || ' :NEW.VES=' || TO_CHAR(V_NEW.VES) || CHR(13);
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
        INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
          SELECT LogId,'PAYMENTS_ON_BILLS',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I',EMPTY_CLOB()
            FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');

        SELECT WhatWasDone INTO cl_WhatWasDone
          FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG
          WHERE ID = LogId
          FOR UPDATE;
        WritePos:=1;
        WriteStr:='NOM_DOK=' || TO_CHAR(V_NEW.NOM_DOK) || ' BILL_POS_ID=' || TO_CHAR(V_NEW.BILL_POS_ID) || ' PAYMENTS_ID=' || TO_CHAR(V_NEW.PAYMENTS_ID);
        dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      END IF;
    END IF;

  END IF;
END;
/


