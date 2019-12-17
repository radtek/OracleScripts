--
-- TRG_AIUDR_KLS_CAT_CEN  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_KLS_CAT_CEN
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.KLS_CAT_CEN
FOR EACH ROW
DECLARE
  v_old KLS_CAT_CEN%ROWTYPE;
  v_new KLS_CAT_CEN%ROWTYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.CAT_CEN_NAME := :OLD.CAT_CEN_NAME;
    v_old.GROUPDOG_ID := :OLD.GROUPDOG_ID;
    v_old.PREDPR_ID := :OLD.PREDPR_ID;
    v_old.CAT_CEN_GROUP_ID := :OLD.CAT_CEN_GROUP_ID;
    v_old.FOX_ID := :OLD.FOX_ID;
    v_old.DOG_ID := :OLD.DOG_ID;
    v_old.For_Azc := :OLD.For_Azc;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
    -- Запись в лог
    IF 1=1 THEN
      SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
      INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
        SELECT LogId,'KLS_CAT_CEN',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D'
          FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
    END IF;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.CAT_CEN_NAME := :NEW.CAT_CEN_NAME;
    v_new.GROUPDOG_ID := :NEW.GROUPDOG_ID;
    v_new.PREDPR_ID := :NEW.PREDPR_ID;
    v_new.CAT_CEN_GROUP_ID := :NEW.CAT_CEN_GROUP_ID;
    v_new.FOX_ID := :NEW.FOX_ID;
    v_new.DOG_ID := :NEW.DOG_ID;
    v_new.For_Azc := :NEW.For_Azc;

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
            SELECT LogId,'KLS_CAT_CEN',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;

        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'KLS_CAT_CEN',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;
      ELSE
        -- PRIMARY KEY не изменился, добавляем в лог 1 запись
        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
            SELECT LogId,'KLS_CAT_CEN',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'U',EMPTY_CLOB()
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
          IF V_OLD.CAT_CEN_NAME<>V_NEW.CAT_CEN_NAME THEN
            WriteStr:=':OLD.CAT_CEN_NAME=' || (V_OLD.CAT_CEN_NAME) || ' :NEW.CAT_CEN_NAME=' || (V_NEW.CAT_CEN_NAME) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.GROUPDOG_ID<>V_NEW.GROUPDOG_ID THEN
            WriteStr:=':OLD.GROUPDOG_ID=' || TO_CHAR(V_OLD.GROUPDOG_ID) || ' :NEW.GROUPDOG_ID=' || TO_CHAR(V_NEW.GROUPDOG_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PREDPR_ID<>V_NEW.PREDPR_ID THEN
            WriteStr:=':OLD.PREDPR_ID=' || TO_CHAR(V_OLD.PREDPR_ID) || ' :NEW.PREDPR_ID=' || TO_CHAR(V_NEW.PREDPR_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.CAT_CEN_GROUP_ID<>V_NEW.CAT_CEN_GROUP_ID THEN
            WriteStr:=':OLD.CAT_CEN_GROUP_ID=' || TO_CHAR(V_OLD.CAT_CEN_GROUP_ID) || ' :NEW.CAT_CEN_GROUP_ID=' || TO_CHAR(V_NEW.CAT_CEN_GROUP_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.FOX_ID<>V_NEW.FOX_ID THEN
            WriteStr:=':OLD.FOX_ID=' || TO_CHAR(V_OLD.FOX_ID) || ' :NEW.FOX_ID=' || TO_CHAR(V_NEW.FOX_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DOG_ID<>V_NEW.DOG_ID THEN
            WriteStr:=':OLD.DOG_ID=' || TO_CHAR(V_OLD.DOG_ID) || ' :NEW.DOG_ID=' || TO_CHAR(V_NEW.DOG_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.For_Azc<>V_NEW.For_Azc THEN
            WriteStr:=':OLD.FOR_AZC=' || (V_OLD.For_Azc) || ' :NEW.FOR_AZC=' || (V_NEW.For_Azc) || CHR(13);
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
          SELECT LogId,'KLS_CAT_CEN',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
            FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
      END IF;
    END IF;

  END IF;
END;
/


