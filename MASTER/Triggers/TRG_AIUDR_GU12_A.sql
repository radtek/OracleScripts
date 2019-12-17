--
-- TRG_AIUDR_GU12_A  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_GU12_A
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.GU12_A
FOR EACH ROW
DECLARE
  v_old GU12_A%ROWTYPE;
  v_new GU12_A%ROWTYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.NOM_Z := :OLD.NOM_Z;
    v_old.FROM_DATE := :OLD.FROM_DATE;
    v_old.TO_DATE := :OLD.TO_DATE;
    v_old.SOGL_DATE := :OLD.SOGL_DATE;
    v_old.REG_DATE := :OLD.REG_DATE;
    v_old.DOGOVOR := :OLD.DOGOVOR;
    v_old.STANOTPR_ID := :OLD.STANOTPR_ID;
    v_old.GROTP_ID := :OLD.GROTP_ID;
    v_old.EXPED_ID := :OLD.EXPED_ID;
    v_old.GR_GRUZ_ID := :OLD.GR_GRUZ_ID;
    v_old.VIDSOOB_ID := :OLD.VIDSOOB_ID;
    v_old.PODACH_ID := :OLD.PODACH_ID;
    v_old.SOGL := :OLD.SOGL;
    v_old.PLATTAR_ID := :OLD.PLATTAR_ID;
    v_old.PROD_ID := :OLD.PROD_ID;
    v_old.PRIZNOTPR_ID := :OLD.PRIZNOTPR_ID;
    v_old.VLADPUT_ID := :OLD.VLADPUT_ID;
    v_old.RODVAG_ID := :OLD.RODVAG_ID;
    v_old.ID_NOSOGL := :OLD.ID_NOSOGL;
    v_old.FOX_KOD := :OLD.FOX_KOD;
    v_old.ISCOR := :OLD.ISCOR;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
    -- Добавить в теневую таблицы
    INSERT INTO MASTER_SHADOW.GU12_A_DELETED
     (ID,NOM_Z,FROM_DATE,TO_DATE,SOGL_DATE,REG_DATE,DOGOVOR,STANOTPR_ID,GROTP_ID,EXPED_ID,GR_GRUZ_ID,VIDSOOB_ID,PODACH_ID,SOGL,PLATTAR_ID,PROD_ID,PRIZNOTPR_ID,VLADPUT_ID,RODVAG_ID,ID_NOSOGL,FOX_KOD,ISCOR)
    VALUES
     (v_old.ID,v_old.NOM_Z,v_old.FROM_DATE,v_old.TO_DATE,v_old.SOGL_DATE,v_old.REG_DATE,v_old.DOGOVOR,v_old.STANOTPR_ID,v_old.GROTP_ID,v_old.EXPED_ID,v_old.GR_GRUZ_ID,v_old.VIDSOOB_ID,v_old.PODACH_ID,v_old.SOGL,v_old.PLATTAR_ID,v_old.PROD_ID,v_old.PRIZNOTPR_ID,v_old.VLADPUT_ID,v_old.RODVAG_ID,v_old.ID_NOSOGL,v_old.FOX_KOD,v_old.ISCOR);

    -- Запись в лог
    IF 1=1 THEN
      SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
      INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
        SELECT LogId,'GU12_A',TO_CHAR(V_OLD.ID),osuser,terminal,SUBSTR(MODULE,1,20),'D',EMPTY_CLOB()
          FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');

      SELECT WhatWasDone INTO cl_WhatWasDone
        FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG
       WHERE ID = LogId
         FOR UPDATE;

      WritePos:=1;

      -- Допишем альтернативный ключ
      WriteStr:='Заявка № ' || (V_OLD.NOM_Z) || ' от ' || TO_CHAR(V_OLD.FROM_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      WritePos:=WritePos+LENGTH(WriteStr);
    END IF;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.NOM_Z := :NEW.NOM_Z;
    v_new.FROM_DATE := :NEW.FROM_DATE;
    v_new.TO_DATE := :NEW.TO_DATE;
    v_new.SOGL_DATE := :NEW.SOGL_DATE;
    v_new.REG_DATE := :NEW.REG_DATE;
    v_new.DOGOVOR := :NEW.DOGOVOR;
    v_new.STANOTPR_ID := :NEW.STANOTPR_ID;
    v_new.GROTP_ID := :NEW.GROTP_ID;
    v_new.EXPED_ID := :NEW.EXPED_ID;
    v_new.GR_GRUZ_ID := :NEW.GR_GRUZ_ID;
    v_new.VIDSOOB_ID := :NEW.VIDSOOB_ID;
    v_new.PODACH_ID := :NEW.PODACH_ID;
    v_new.SOGL := :NEW.SOGL;
    v_new.PLATTAR_ID := :NEW.PLATTAR_ID;
    v_new.PROD_ID := :NEW.PROD_ID;
    v_new.PRIZNOTPR_ID := :NEW.PRIZNOTPR_ID;
    v_new.VLADPUT_ID := :NEW.VLADPUT_ID;
    v_new.RODVAG_ID := :NEW.RODVAG_ID;
    v_new.ID_NOSOGL := :NEW.ID_NOSOGL;
    v_new.FOX_KOD := :NEW.FOX_KOD;
    v_new.ISCOR := :NEW.ISCOR;

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
            SELECT LogId,'GU12_A',TO_CHAR(V_OLD.ID),osuser,terminal,SUBSTR(MODULE,1,20),'D',EMPTY_CLOB()
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');

          SELECT WhatWasDone INTO cl_WhatWasDone
            FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG
            WHERE ID = LogId
            FOR UPDATE;

          WritePos:=1;

		  -- Допишем альтернативный ключ
          WriteStr:='Заявка № ' || (V_OLD.NOM_Z) || ' от ' || TO_CHAR(V_OLD.FROM_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
          dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
          WritePos:=WritePos+LENGTH(WriteStr);
        END IF;

        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'GU12_A',TO_CHAR(V_NEW.ID),osuser,terminal,SUBSTR(MODULE,1,20),'I'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;
      ELSE
        -- PRIMARY KEY не изменился, добавляем в лог 1 запись
        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
            SELECT LogId,'GU12_A',TO_CHAR(V_NEW.ID),osuser,terminal,SUBSTR(MODULE,1,20),'U',EMPTY_CLOB()
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
          IF V_OLD.NOM_Z||' '<>V_NEW.NOM_Z||' ' THEN
            WriteStr:=':OLD.NOM_Z=' || (V_OLD.NOM_Z) || ' :NEW.NOM_Z=' || (V_NEW.NOM_Z) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.FROM_DATE,TO_DATE('01.01.1900','dd.mm.yyyy'))<>NVL(V_NEW.FROM_DATE,TO_DATE('01.01.1900','dd.mm.yyyy')) THEN
            WriteStr:=':OLD.FROM_DATE=' || TO_CHAR(V_OLD.FROM_DATE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.FROM_DATE=' || TO_CHAR(V_NEW.FROM_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.TO_DATE,TO_DATE('01.01.1900','dd.mm.yyyy'))<>NVL(V_NEW.TO_DATE,TO_DATE('01.01.1900','dd.mm.yyyy')) THEN
            WriteStr:=':OLD.TO_DATE=' || TO_CHAR(V_OLD.TO_DATE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.TO_DATE=' || TO_CHAR(V_NEW.TO_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.SOGL_DATE,TO_DATE('01.01.1900','dd.mm.yyyy'))<>NVL(V_NEW.SOGL_DATE,TO_DATE('01.01.1900','dd.mm.yyyy')) THEN
            WriteStr:=':OLD.SOGL_DATE=' || TO_CHAR(V_OLD.SOGL_DATE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.SOGL_DATE=' || TO_CHAR(V_NEW.SOGL_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.REG_DATE,TO_DATE('01.01.1900','dd.mm.yyyy'))<>NVL(V_NEW.REG_DATE,TO_DATE('01.01.1900','dd.mm.yyyy')) THEN
            WriteStr:=':OLD.REG_DATE=' || TO_CHAR(V_OLD.REG_DATE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.REG_DATE=' || TO_CHAR(V_NEW.REG_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DOGOVOR||' '<>V_NEW.DOGOVOR||' ' THEN
            WriteStr:=':OLD.DOGOVOR=' || (V_OLD.DOGOVOR) || ' :NEW.DOGOVOR=' || (V_NEW.DOGOVOR) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.STANOTPR_ID,0)<>NVL(V_NEW.STANOTPR_ID,0) THEN
            WriteStr:=':OLD.STANOTPR_ID=' || TO_CHAR(V_OLD.STANOTPR_ID) || ' :NEW.STANOTPR_ID=' || TO_CHAR(V_NEW.STANOTPR_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.GROTP_ID,0)<>NVL(V_NEW.GROTP_ID,0) THEN
            WriteStr:=':OLD.GROTP_ID=' || TO_CHAR(V_OLD.GROTP_ID) || ' :NEW.GROTP_ID=' || TO_CHAR(V_NEW.GROTP_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.EXPED_ID,0)<>NVL(V_NEW.EXPED_ID,0) THEN
            WriteStr:=':OLD.EXPED_ID=' || TO_CHAR(V_OLD.EXPED_ID) || ' :NEW.EXPED_ID=' || TO_CHAR(V_NEW.EXPED_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.GR_GRUZ_ID,0)<>NVL(V_NEW.GR_GRUZ_ID,0) THEN
            WriteStr:=':OLD.GR_GRUZ_ID=' || TO_CHAR(V_OLD.GR_GRUZ_ID) || ' :NEW.GR_GRUZ_ID=' || TO_CHAR(V_NEW.GR_GRUZ_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.VIDSOOB_ID,0)<>NVL(V_NEW.VIDSOOB_ID,0) THEN
            WriteStr:=':OLD.VIDSOOB_ID=' || TO_CHAR(V_OLD.VIDSOOB_ID) || ' :NEW.VIDSOOB_ID=' || TO_CHAR(V_NEW.VIDSOOB_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.PODACH_ID,0)<>NVL(V_NEW.PODACH_ID,0) THEN
            WriteStr:=':OLD.PODACH_ID=' || TO_CHAR(V_OLD.PODACH_ID) || ' :NEW.PODACH_ID=' || TO_CHAR(V_NEW.PODACH_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.SOGL,0)<>NVL(V_NEW.SOGL,0) THEN
            WriteStr:=':OLD.SOGL=' || TO_CHAR(V_OLD.SOGL) || ' :NEW.SOGL=' || TO_CHAR(V_NEW.SOGL) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.PLATTAR_ID,0)<>NVL(V_NEW.PLATTAR_ID,0) THEN
            WriteStr:=':OLD.PLATTAR_ID=' || TO_CHAR(V_OLD.PLATTAR_ID) || ' :NEW.PLATTAR_ID=' || TO_CHAR(V_NEW.PLATTAR_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.PROD_ID,0)<>NVL(V_NEW.PROD_ID,0) THEN
            WriteStr:=':OLD.PROD_ID=' || TO_CHAR(V_OLD.PROD_ID) || ' :NEW.PROD_ID=' || TO_CHAR(V_NEW.PROD_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.PRIZNOTPR_ID,0)<>NVL(V_NEW.PRIZNOTPR_ID,0) THEN
            WriteStr:=':OLD.PRIZNOTPR_ID=' || TO_CHAR(V_OLD.PRIZNOTPR_ID) || ' :NEW.PRIZNOTPR_ID=' || TO_CHAR(V_NEW.PRIZNOTPR_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.VLADPUT_ID,0)<>NVL(V_NEW.VLADPUT_ID,0) THEN
            WriteStr:=':OLD.VLADPUT_ID=' || TO_CHAR(V_OLD.VLADPUT_ID) || ' :NEW.VLADPUT_ID=' || TO_CHAR(V_NEW.VLADPUT_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.RODVAG_ID,0)<>NVL(V_NEW.RODVAG_ID,0) THEN
            WriteStr:=':OLD.RODVAG_ID=' || TO_CHAR(V_OLD.RODVAG_ID) || ' :NEW.RODVAG_ID=' || TO_CHAR(V_NEW.RODVAG_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.ID_NOSOGL,0)<>NVL(V_NEW.ID_NOSOGL,0) THEN
            WriteStr:=':OLD.ID_NOSOGL=' || TO_CHAR(V_OLD.ID_NOSOGL) || ' :NEW.ID_NOSOGL=' || TO_CHAR(V_NEW.ID_NOSOGL) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.FOX_KOD<>V_NEW.FOX_KOD THEN
            WriteStr:=':OLD.FOX_KOD=' || (V_OLD.FOX_KOD) || ' :NEW.FOX_KOD=' || (V_NEW.FOX_KOD) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.ISCOR,0)<>NVL(V_NEW.ISCOR,0) THEN
            WriteStr:=':OLD.ISCOR=' || TO_CHAR(V_OLD.ISCOR) || ' :NEW.ISCOR=' || TO_CHAR(V_NEW.ISCOR) || CHR(13);
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
          SELECT LogId,'GU12_A',TO_CHAR(V_NEW.ID),osuser,terminal,SUBSTR(MODULE,1,20),'I'
            FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
      END IF;
    END IF;

  END IF;
END;
/


