--
-- TRG_AIUDR_SPECIF  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_SPECIF
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.SPECIF
FOR EACH ROW
DECLARE
  v_old SPECIF%ROWTYPE;
  v_new SPECIF%ROWTYPE;
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
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.LOAD_ABBR := :OLD.LOAD_ABBR;
    v_old.STANOTP_ID := :OLD.STANOTP_ID;
    v_old.STAN_ID := :OLD.STAN_ID;
    v_old.VETKA_ID := :OLD.VETKA_ID;
    v_old.POLUCH_ID := :OLD.POLUCH_ID;
    v_old.POTREB_ID := :OLD.POTREB_ID;
    v_old.PRIM := :OLD.PRIM;
    v_old.GR4 := :OLD.GR4;
    v_old.M1 := :OLD.M1;
    v_old.M2 := :OLD.M2;
    v_old.M3 := :OLD.M3;
    v_old.M4 := :OLD.M4;
    v_old.M5 := :OLD.M5;
    v_old.M6 := :OLD.M6;
    v_old.M7 := :OLD.M7;
    v_old.M8 := :OLD.M8;
    v_old.M9 := :OLD.M9;
    v_old.M10 := :OLD.M10;
    v_old.M11 := :OLD.M11;
    v_old.M12 := :OLD.M12;
    v_old.KV1 := :OLD.KV1;
    v_old.KV2 := :OLD.KV2;
    v_old.KV3 := :OLD.KV3;
    v_old.KV4 := :OLD.KV4;
    v_old.VES_ALL := :OLD.VES_ALL;
    v_old.APPL_TAG := :OLD.APPL_TAG;
    v_old.BEGIN_DATE := :OLD.BEGIN_DATE;
    v_old.END_DATE := :OLD.END_DATE;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
    -- Удаление из теневой таблицы
--    DELETE FROM MASTER_SHADOW.SPECIF_SHADOW
--     WHERE ID=v_old.ID;
    -- Запись в лог
    IF v_old.APPL_TAG='MASTER' THEN
      SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
      INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
        SELECT LogId,'SPECIF',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D'
          FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
    END IF;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.DOG_ID := :NEW.DOG_ID;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.LOAD_ABBR := :NEW.LOAD_ABBR;
    v_new.STANOTP_ID := :NEW.STANOTP_ID;
    v_new.STAN_ID := :NEW.STAN_ID;
    v_new.VETKA_ID := :NEW.VETKA_ID;
    v_new.POLUCH_ID := :NEW.POLUCH_ID;
    v_new.POTREB_ID := :NEW.POTREB_ID;
    v_new.PRIM := :NEW.PRIM;
    v_new.GR4 := :NEW.GR4;
    v_new.M1 := :NEW.M1;
    v_new.M2 := :NEW.M2;
    v_new.M3 := :NEW.M3;
    v_new.M4 := :NEW.M4;
    v_new.M5 := :NEW.M5;
    v_new.M6 := :NEW.M6;
    v_new.M7 := :NEW.M7;
    v_new.M8 := :NEW.M8;
    v_new.M9 := :NEW.M9;
    v_new.M10 := :NEW.M10;
    v_new.M11 := :NEW.M11;
    v_new.M12 := :NEW.M12;
    v_new.KV1 := :NEW.KV1;
    v_new.KV2 := :NEW.KV2;
    v_new.KV3 := :NEW.KV3;
    v_new.KV4 := :NEW.KV4;
    v_new.VES_ALL := :NEW.VES_ALL;
    v_new.APPL_TAG := :NEW.APPL_TAG;
    v_new.BEGIN_DATE := :NEW.BEGIN_DATE;
    v_new.END_DATE := :NEW.END_DATE;

    -- Обновление теневой таблицы
/*    UPDATE MASTER_SHADOW.SPECIF_SHADOW SET
      (ID,DOG_ID,PROD_ID_NPR,LOAD_ABBR,STANOTP_ID,STAN_ID,VETKA_ID,POLUCH_ID,POTREB_ID,PRIM,GR4,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,KV1,KV2,KV3,KV4,VES_ALL,APPL_TAG,BEGIN_DATE,END_DATE)=
      (SELECT v_new.ID,v_new.DOG_ID,v_new.PROD_ID_NPR,v_new.LOAD_ABBR,v_new.STANOTP_ID,v_new.STAN_ID,v_new.VETKA_ID,v_new.POLUCH_ID,v_new.POTREB_ID,v_new.PRIM,v_new.GR4,v_new.M1,v_new.M2,v_new.M3,v_new.M4,v_new.M5,v_new.M6,v_new.M7,v_new.M8,v_new.M9,v_new.M10,v_new.M11,v_new.M12,v_new.KV1,v_new.KV2,v_new.KV3,v_new.KV4,v_new.VES_ALL,v_new.APPL_TAG,v_new.BEGIN_DATE,v_new.END_DATE FROM dual)
      WHERE ID=v_old.ID;

    IF SQL%NOTFOUND THEN
      INSERT INTO MASTER_SHADOW.SPECIF_SHADOW
        (ID,DOG_ID,PROD_ID_NPR,LOAD_ABBR,STANOTP_ID,STAN_ID,VETKA_ID,POLUCH_ID,POTREB_ID,PRIM,GR4,M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,KV1,KV2,KV3,KV4,VES_ALL,APPL_TAG,BEGIN_DATE,END_DATE)
        VALUES
        (v_new.ID,v_new.DOG_ID,v_new.PROD_ID_NPR,v_new.LOAD_ABBR,v_new.STANOTP_ID,v_new.STAN_ID,v_new.VETKA_ID,v_new.POLUCH_ID,v_new.POTREB_ID,v_new.PRIM,v_new.GR4,v_new.M1,v_new.M2,v_new.M3,v_new.M4,v_new.M5,v_new.M6,v_new.M7,v_new.M8,v_new.M9,v_new.M10,v_new.M11,v_new.M12,v_new.KV1,v_new.KV2,v_new.KV3,v_new.KV4,v_new.VES_ALL,v_new.APPL_TAG,v_new.BEGIN_DATE,v_new.END_DATE);
    END IF;
*/
    -- После обновления
    IF UPDATING() THEN
      NULL;
      -- Запись в лог
      IF V_OLD.ID<>V_NEW.ID THEN
        -- Изменился PRIMARY KEY, добавляем в лог 2 записи
        -- Запись в лог
        IF v_old.APPL_TAG='MASTER' THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'SPECIF',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;

        -- Запись в лог
        IF v_new.APPL_TAG='MASTER' THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'SPECIF',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;
      ELSE
        -- PRIMARY KEY не изменился, добавляем в лог 1 запись
        -- Запись в лог
        IF v_new.APPL_TAG='MASTER' THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
            SELECT LogId,'SPECIF',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'U',EMPTY_CLOB()
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
          IF V_OLD.PROD_ID_NPR<>V_NEW.PROD_ID_NPR THEN
            WriteStr:=':OLD.PROD_ID_NPR=' || (V_OLD.PROD_ID_NPR) || ' :NEW.PROD_ID_NPR=' || (V_NEW.PROD_ID_NPR) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.LOAD_ABBR<>V_NEW.LOAD_ABBR THEN
            WriteStr:=':OLD.LOAD_ABBR=' || (V_OLD.LOAD_ABBR) || ' :NEW.LOAD_ABBR=' || (V_NEW.LOAD_ABBR) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.STANOTP_ID<>V_NEW.STANOTP_ID THEN
            WriteStr:=':OLD.STANOTP_ID=' || TO_CHAR(V_OLD.STANOTP_ID) || ' :NEW.STANOTP_ID=' || TO_CHAR(V_NEW.STANOTP_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.STAN_ID<>V_NEW.STAN_ID THEN
            WriteStr:=':OLD.STAN_ID=' || TO_CHAR(V_OLD.STAN_ID) || ' :NEW.STAN_ID=' || TO_CHAR(V_NEW.STAN_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.VETKA_ID<>V_NEW.VETKA_ID THEN
            WriteStr:=':OLD.VETKA_ID=' || TO_CHAR(V_OLD.VETKA_ID) || ' :NEW.VETKA_ID=' || TO_CHAR(V_NEW.VETKA_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.POLUCH_ID<>V_NEW.POLUCH_ID THEN
            WriteStr:=':OLD.POLUCH_ID=' || TO_CHAR(V_OLD.POLUCH_ID) || ' :NEW.POLUCH_ID=' || TO_CHAR(V_NEW.POLUCH_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.POTREB_ID<>V_NEW.POTREB_ID THEN
            WriteStr:=':OLD.POTREB_ID=' || TO_CHAR(V_OLD.POTREB_ID) || ' :NEW.POTREB_ID=' || TO_CHAR(V_NEW.POTREB_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PRIM<>V_NEW.PRIM THEN
            WriteStr:=':OLD.PRIM=' || (V_OLD.PRIM) || ' :NEW.PRIM=' || (V_NEW.PRIM) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.GR4<>V_NEW.GR4 THEN
            WriteStr:=':OLD.GR4=' || (V_OLD.GR4) || ' :NEW.GR4=' || (V_NEW.GR4) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.M1<>V_NEW.M1 THEN
            WriteStr:=':OLD.M1=' || TO_CHAR(V_OLD.M1) || ' :NEW.M1=' || TO_CHAR(V_NEW.M1) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.M2<>V_NEW.M2 THEN
            WriteStr:=':OLD.M2=' || TO_CHAR(V_OLD.M2) || ' :NEW.M2=' || TO_CHAR(V_NEW.M2) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.M3<>V_NEW.M3 THEN
            WriteStr:=':OLD.M3=' || TO_CHAR(V_OLD.M3) || ' :NEW.M3=' || TO_CHAR(V_NEW.M3) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.M4<>V_NEW.M4 THEN
            WriteStr:=':OLD.M4=' || TO_CHAR(V_OLD.M4) || ' :NEW.M4=' || TO_CHAR(V_NEW.M4) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.M5<>V_NEW.M5 THEN
            WriteStr:=':OLD.M5=' || TO_CHAR(V_OLD.M5) || ' :NEW.M5=' || TO_CHAR(V_NEW.M5) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.M6<>V_NEW.M6 THEN
            WriteStr:=':OLD.M6=' || TO_CHAR(V_OLD.M6) || ' :NEW.M6=' || TO_CHAR(V_NEW.M6) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.M7<>V_NEW.M7 THEN
            WriteStr:=':OLD.M7=' || TO_CHAR(V_OLD.M7) || ' :NEW.M7=' || TO_CHAR(V_NEW.M7) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.M8<>V_NEW.M8 THEN
            WriteStr:=':OLD.M8=' || TO_CHAR(V_OLD.M8) || ' :NEW.M8=' || TO_CHAR(V_NEW.M8) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.M9<>V_NEW.M9 THEN
            WriteStr:=':OLD.M9=' || TO_CHAR(V_OLD.M9) || ' :NEW.M9=' || TO_CHAR(V_NEW.M9) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.M10<>V_NEW.M10 THEN
            WriteStr:=':OLD.M10=' || TO_CHAR(V_OLD.M10) || ' :NEW.M10=' || TO_CHAR(V_NEW.M10) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.M11<>V_NEW.M11 THEN
            WriteStr:=':OLD.M11=' || TO_CHAR(V_OLD.M11) || ' :NEW.M11=' || TO_CHAR(V_NEW.M11) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.M12<>V_NEW.M12 THEN
            WriteStr:=':OLD.M12=' || TO_CHAR(V_OLD.M12) || ' :NEW.M12=' || TO_CHAR(V_NEW.M12) || CHR(13);
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
        END IF;
      END IF;
    END IF;

    -- После добавления
    IF INSERTING() THEN
      NULL;
      -- Запись в лог
      IF v_new.APPL_TAG='MASTER' THEN
        SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
        INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
          SELECT LogId,'SPECIF',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
            FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
      END IF;
    END IF;

  END IF;
END;
/


