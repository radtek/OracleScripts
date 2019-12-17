--
-- TRG_AIUDR_MONTH_VISIR  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_MONTH_VISIR
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.MONTH_VISIR
FOR EACH ROW
DECLARE
  v_old MONTH_VISIR%ROWTYPE;
  v_new MONTH_VISIR%ROWTYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.DATE_REE := :OLD.DATE_REE;
    v_old.DOP_REE := :OLD.DOP_REE;
    v_old.NOM_ZD := :OLD.NOM_ZD;
    v_old.PRICHIN := :OLD.PRICHIN;
    v_old.APP_USERS_ID := :OLD.APP_USERS_ID;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
    -- Запись в лог
    IF 1=1 THEN
      SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
      INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
        SELECT LogId,'MONTH_VISIR',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D'
          FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
    END IF;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.DATE_REE := :NEW.DATE_REE;
    v_new.DOP_REE := :NEW.DOP_REE;
    v_new.NOM_ZD := :NEW.NOM_ZD;
    v_new.PRICHIN := :NEW.PRICHIN;
    v_new.APP_USERS_ID := :NEW.APP_USERS_ID;

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
            SELECT LogId,'MONTH_VISIR',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;

        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'MONTH_VISIR',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;
      ELSE
        -- PRIMARY KEY не изменился, добавляем в лог 1 запись
        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
            SELECT LogId,'MONTH_VISIR',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'U',EMPTY_CLOB()
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
          IF V_OLD.DATE_REE<>V_NEW.DATE_REE THEN
            WriteStr:=':OLD.DATE_REE=' || TO_CHAR(V_OLD.DATE_REE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_REE=' || TO_CHAR(V_NEW.DATE_REE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DOP_REE<>V_NEW.DOP_REE THEN
            WriteStr:=':OLD.DOP_REE=' || TO_CHAR(V_OLD.DOP_REE) || ' :NEW.DOP_REE=' || TO_CHAR(V_NEW.DOP_REE) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NOM_ZD<>V_NEW.NOM_ZD THEN
            WriteStr:=':OLD.NOM_ZD=' || (V_OLD.NOM_ZD) || ' :NEW.NOM_ZD=' || (V_NEW.NOM_ZD) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PRICHIN<>V_NEW.PRICHIN THEN
            WriteStr:=':OLD.PRICHIN=' || (V_OLD.PRICHIN) || ' :NEW.PRICHIN=' || (V_NEW.PRICHIN) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.APP_USERS_ID<>V_NEW.APP_USERS_ID THEN
            WriteStr:=':OLD.APP_USERS_ID=' || TO_CHAR(V_OLD.APP_USERS_ID) || ' :NEW.APP_USERS_ID=' || TO_CHAR(V_NEW.APP_USERS_ID) || CHR(13);
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
          SELECT LogId,'MONTH_VISIR',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
            FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
      END IF;
    END IF;

  END IF;
END;
/


