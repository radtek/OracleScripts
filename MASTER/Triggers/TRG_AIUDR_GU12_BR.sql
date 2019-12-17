--
-- TRG_AIUDR_GU12_BR  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_GU12_BR
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.GU12_BR
FOR EACH ROW
DECLARE
  v_old GU12_BR%ROWTYPE;
  v_new GU12_BR%ROWTYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.ID_B := :OLD.ID_B;
    v_old.DATE_R := :OLD.DATE_R;
    v_old.KOL_VAG := :OLD.KOL_VAG;
    v_old.VES := :OLD.VES;
    v_old.ID_NPR := :OLD.ID_NPR;
    v_old.METKA := :OLD.METKA;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
    -- Добавление в теневую таблицу
    INSERT INTO MASTER_SHADOW.GU12_BR_DELETED
        (ID,ID_B,DATE_R,KOL_VAG,VES,ID_NPR,METKA)
        VALUES
        (v_old.ID,v_old.ID_B,v_old.DATE_R,v_old.KOL_VAG,v_old.VES,v_old.ID_NPR,v_old.METKA);
    -- Запись в лог
    IF 1=1 THEN
      SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
      INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
        SELECT LogId,'GU12_BR',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D',EMPTY_CLOB()
          FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');

      SELECT WhatWasDone INTO cl_WhatWasDone
        FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG
       WHERE ID = LogId
         FOR UPDATE;

      WritePos:=1;
      WriteStr:='ID_B=' || TO_CHAR(V_OLD.ID_B) || ' DATE_R=' || TO_CHAR(V_OLD.DATE_R,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      WritePos:=WritePos+LENGTH(WriteStr);
    END IF;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.ID_B := :NEW.ID_B;
    v_new.DATE_R := :NEW.DATE_R;
    v_new.KOL_VAG := :NEW.KOL_VAG;
    v_new.VES := :NEW.VES;
    v_new.ID_NPR := :NEW.ID_NPR;
    v_new.METKA := :NEW.METKA;

    -- После обновления
    IF UPDATING() THEN
      NULL;
      -- Запись в лог
      IF V_OLD.ID<>V_NEW.ID THEN
        -- Изменился PRIMARY KEY, добавляем в лог 2 записи
        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
            SELECT LogId,'GU12_BR',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D',EMPTY_CLOB()
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');

          SELECT WhatWasDone INTO cl_WhatWasDone
           FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG
           WHERE ID = LogId
             FOR UPDATE;

          WritePos:=1;
          WriteStr:='ID_B=' || TO_CHAR(V_OLD.ID_B) || ' DATE_R=' || TO_CHAR(V_OLD.DATE_R,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
          dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
          WritePos:=WritePos+LENGTH(WriteStr);
        END IF;

        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'GU12_BR',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;
      ELSE
        -- PRIMARY KEY не изменился, добавляем в лог 1 запись
        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
            SELECT LogId,'GU12_BR',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'U',EMPTY_CLOB()
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
          IF V_OLD.ID_B<>V_NEW.ID_B THEN
            WriteStr:=':OLD.ID_B=' || TO_CHAR(V_OLD.ID_B) || ' :NEW.ID_B=' || TO_CHAR(V_NEW.ID_B) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DATE_R<>V_NEW.DATE_R THEN
            WriteStr:=':OLD.DATE_R=' || TO_CHAR(V_OLD.DATE_R,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_R=' || TO_CHAR(V_NEW.DATE_R,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.KOL_VAG,0)<>NVL(V_NEW.KOL_VAG,0) THEN
            WriteStr:=':OLD.KOL_VAG=' || TO_CHAR(V_OLD.KOL_VAG) || ' :NEW.KOL_VAG=' || TO_CHAR(V_NEW.KOL_VAG) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.VES,0)<>NVL(V_NEW.VES,0) THEN
            WriteStr:=':OLD.VES=' || TO_CHAR(V_OLD.VES) || ' :NEW.VES=' || TO_CHAR(V_NEW.VES) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.ID_NPR||' '<>V_NEW.ID_NPR||' ' THEN
            WriteStr:=':OLD.ID_NPR=' || (V_OLD.ID_NPR) || ' :NEW.ID_NPR=' || (V_NEW.ID_NPR) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.METKA<>V_NEW.METKA THEN
            WriteStr:=':OLD.METKA=' || TO_CHAR(V_OLD.METKA) || ' :NEW.METKA=' || TO_CHAR(V_NEW.METKA) || CHR(13);
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
          SELECT LogId,'GU12_BR',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
            FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
      END IF;
    END IF;

  END IF;
END;
/


