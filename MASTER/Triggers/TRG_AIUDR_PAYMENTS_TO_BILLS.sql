--
-- TRG_AIUDR_PAYMENTS_TO_BILLS  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_PAYMENTS_TO_BILLS
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.PAYMENTS_TO_BILLS
FOR EACH ROW
DECLARE
  v_old PAYMENTS_TO_BILLS%ROWTYPE;
  v_new PAYMENTS_TO_BILLS%ROWTYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.PAYMENTS_ID := :OLD.PAYMENTS_ID;
    v_old.NOM_DOK := :OLD.NOM_DOK;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
    -- Запись в лог
    IF 1=1 THEN
      SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
      INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
        SELECT LogId,'PAYMENTS_TO_BILLS',TO_CHAR(V_OLD.PAYMENTS_ID) || TO_CHAR(V_OLD.NOM_DOK),osuser,terminal,MODULE,'D'
          FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
    END IF;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.PAYMENTS_ID := :NEW.PAYMENTS_ID;
    v_new.NOM_DOK := :NEW.NOM_DOK;

    -- После обновления
    IF UPDATING() THEN
      NULL;
      -- Запись в лог
      IF V_OLD.PAYMENTS_ID<>V_NEW.PAYMENTS_ID OR V_OLD.NOM_DOK<>V_NEW.NOM_DOK THEN
        -- Изменился PRIMARY KEY, добавляем в лог 2 записи
        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'PAYMENTS_TO_BILLS',TO_CHAR(V_OLD.PAYMENTS_ID) || TO_CHAR(V_OLD.NOM_DOK),osuser,terminal,MODULE,'D'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;

        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'PAYMENTS_TO_BILLS',TO_CHAR(V_NEW.PAYMENTS_ID) || TO_CHAR(V_NEW.NOM_DOK),osuser,terminal,MODULE,'I'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;
      ELSE
        -- PRIMARY KEY не изменился, добавляем в лог 1 запись
        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
            SELECT LogId,'PAYMENTS_TO_BILLS',TO_CHAR(V_NEW.PAYMENTS_ID) || TO_CHAR(V_NEW.NOM_DOK),osuser,terminal,MODULE,'U',EMPTY_CLOB()
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');

          SELECT WhatWasDone INTO cl_WhatWasDone
            FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG
            WHERE ID = LogId
            FOR UPDATE;

          WritePos:=1;

          IF V_OLD.PAYMENTS_ID<>V_NEW.PAYMENTS_ID THEN
            WriteStr:=':OLD.PAYMENTS_ID=' || TO_CHAR(V_OLD.PAYMENTS_ID) || ' :NEW.PAYMENTS_ID=' || TO_CHAR(V_NEW.PAYMENTS_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NOM_DOK<>V_NEW.NOM_DOK THEN
            WriteStr:=':OLD.NOM_DOK=' || TO_CHAR(V_OLD.NOM_DOK) || ' :NEW.NOM_DOK=' || TO_CHAR(V_NEW.NOM_DOK) || CHR(13);
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
          SELECT LogId,'PAYMENTS_TO_BILLS',TO_CHAR(V_NEW.PAYMENTS_ID) || TO_CHAR(V_NEW.NOM_DOK),osuser,terminal,MODULE,'I'
            FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
      END IF;
    END IF;

  END IF;
END;
/


