--
-- T99_LOG_ZAKAZ_HIST  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.T99_LOG_ZAKAZ_HIST
/* ---------------------------------------------
  Генератор скриптов для MASTER
  PSV v1.04
--------------------------------------------- */
 AFTER DELETE OR INSERT OR UPDATE ON MASTER.ZAKAZ_HIST  FOR EACH ROW
DECLARE
  v_old ZAKAZ_HIST%ROWTYPE;
  v_new ZAKAZ_HIST%ROWTYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.ZAKAZ_ID := :OLD.ZAKAZ_ID;
    v_old.SORTBY := :OLD.SORTBY;
    v_old.STATUS_ZAKAZ_ID := :OLD.STATUS_ZAKAZ_ID;
    v_old.CLIENT_NUMBER := :OLD.CLIENT_NUMBER;
    v_old.CLIENT_DATE := :OLD.CLIENT_DATE;
    v_old.INPUT_NUMBER := :OLD.INPUT_NUMBER;
    v_old.INPUT_DATE := :OLD.INPUT_DATE;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.OLD_STAN_ID := :OLD.OLD_STAN_ID;
    v_old.STAN_ID := :OLD.STAN_ID;
    v_old.POLUCH_ID := :OLD.POLUCH_ID;
    v_old.PRICE := :OLD.PRICE;
    v_old.VES := :OLD.VES;
    v_old.KOL := :OLD.KOL;
    v_old.SPEED_VES := :OLD.SPEED_VES;
    v_old.SPEED_KOL := :OLD.SPEED_KOL;
    v_old.NOM_ZD := :OLD.NOM_ZD;
    v_old.FACT_VES := :OLD.FACT_VES;
    v_old.FACT_KOL := :OLD.FACT_KOL;
    v_old.GU12_A_ID := :OLD.GU12_A_ID;
    v_old.IS_AUTO := :OLD.IS_AUTO;
    v_old.BEGIN_DATE := :OLD.BEGIN_DATE;
    v_old.GRAFIK := :OLD.GRAFIK;
    v_old.POTREB_ID := :OLD.POTREB_ID;
    v_old.LOAD_VES := :OLD.LOAD_VES;
    v_old.LOAD_KOL := :OLD.LOAD_KOL;
    v_old.LINK_ID := :OLD.LINK_ID;
    v_old.LINK_HIST_ID := :OLD.LINK_HIST_ID;
    v_old.IS_AUTO_MONTH := :OLD.IS_AUTO_MONTH;
    v_old.KOD_ISU := :OLD.KOD_ISU;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
    -- Запись в лог
    IF 1=1 THEN
      SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
      INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
        SELECT LogId,'ZAKAZ_HIST',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D',EMPTY_CLOB()
          FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
          
      SELECT WhatWasDone INTO cl_WhatWasDone
            FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG
            WHERE ID = LogId
            FOR UPDATE;

      WritePos:=1;

      WriteStr:=':OLD.ZAKAZ_ID=' || TO_CHAR(V_OLD.ZAKAZ_ID) || ' :NEW.ZAKAZ_ID=' || TO_CHAR(V_NEW.ZAKAZ_ID) || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      WritePos:=WritePos+LENGTH(WriteStr);
      WriteStr:=':OLD.STATUS_ZAKAZ_ID=' || TO_CHAR(V_OLD.STATUS_ZAKAZ_ID) || ' :NEW.STATUS_ZAKAZ_ID=' || TO_CHAR(V_NEW.STATUS_ZAKAZ_ID) || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      WritePos:=WritePos+LENGTH(WriteStr);
      WriteStr:=':OLD.CLIENT_NUMBER=' || (V_OLD.CLIENT_NUMBER) || ' :NEW.CLIENT_NUMBER=' || (V_NEW.CLIENT_NUMBER) || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      WritePos:=WritePos+LENGTH(WriteStr);
      WriteStr:=':OLD.INPUT_NUMBER=' || (V_OLD.INPUT_NUMBER) || ' :NEW.INPUT_NUMBER=' || (V_NEW.INPUT_NUMBER) || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      WritePos:=WritePos+LENGTH(WriteStr);
      WriteStr:=':OLD.VES=' || TO_CHAR(V_OLD.VES) || ' :NEW.VES=' || TO_CHAR(V_NEW.VES) || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      WritePos:=WritePos+LENGTH(WriteStr);
      WriteStr:=':OLD.KOL=' || TO_CHAR(V_OLD.KOL) || ' :NEW.KOL=' || TO_CHAR(V_NEW.KOL) || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      WritePos:=WritePos+LENGTH(WriteStr);
      WriteStr:=':OLD.NOM_ZD=' || (V_OLD.NOM_ZD) || ' :NEW.NOM_ZD=' || (V_NEW.NOM_ZD) || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      WritePos:=WritePos+LENGTH(WriteStr);
      WriteStr:=':OLD.IS_AUTO=' || TO_CHAR(V_OLD.IS_AUTO) || ' :NEW.IS_AUTO=' || TO_CHAR(V_NEW.IS_AUTO) || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      WritePos:=WritePos+LENGTH(WriteStr);
      WriteStr:=':OLD.LOAD_VES=' || TO_CHAR(V_OLD.LOAD_VES) || ' :NEW.LOAD_VES=' || TO_CHAR(V_NEW.LOAD_VES) || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      WritePos:=WritePos+LENGTH(WriteStr);
      WriteStr:=':OLD.LOAD_KOL=' || TO_CHAR(V_OLD.LOAD_KOL) || ' :NEW.LOAD_KOL=' || TO_CHAR(V_NEW.LOAD_KOL) || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      WritePos:=WritePos+LENGTH(WriteStr);
      WriteStr:=':OLD.LINK_ID=' || TO_CHAR(V_OLD.LINK_ID) || ' :NEW.LINK_ID=' || TO_CHAR(V_NEW.LINK_ID) || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      WritePos:=WritePos+LENGTH(WriteStr);
      WriteStr:=':OLD.LINK_HIST_ID=' || TO_CHAR(V_OLD.LINK_HIST_ID) || ' :NEW.LINK_HIST_ID=' || TO_CHAR(V_NEW.LINK_HIST_ID) || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      WritePos:=WritePos+LENGTH(WriteStr);
      WriteStr:=':OLD.IS_AUTO_MONTH=' || TO_CHAR(V_OLD.IS_AUTO_MONTH) || ' :NEW.IS_AUTO_MONTH=' || TO_CHAR(V_NEW.IS_AUTO_MONTH) || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      WritePos:=WritePos+LENGTH(WriteStr);
      WriteStr:=':OLD.KOD_ISU=' || (V_OLD.KOD_ISU) || ' :NEW.KOD_ISU=' || (V_NEW.KOD_ISU) || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      WritePos:=WritePos+LENGTH(WriteStr);
    END IF;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.ZAKAZ_ID := :NEW.ZAKAZ_ID;
    v_new.SORTBY := :NEW.SORTBY;
    v_new.STATUS_ZAKAZ_ID := :NEW.STATUS_ZAKAZ_ID;
    v_new.CLIENT_NUMBER := :NEW.CLIENT_NUMBER;
    v_new.CLIENT_DATE := :NEW.CLIENT_DATE;
    v_new.INPUT_NUMBER := :NEW.INPUT_NUMBER;
    v_new.INPUT_DATE := :NEW.INPUT_DATE;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.OLD_STAN_ID := :NEW.OLD_STAN_ID;
    v_new.STAN_ID := :NEW.STAN_ID;
    v_new.POLUCH_ID := :NEW.POLUCH_ID;
    v_new.PRICE := :NEW.PRICE;
    v_new.VES := :NEW.VES;
    v_new.KOL := :NEW.KOL;
    v_new.SPEED_VES := :NEW.SPEED_VES;
    v_new.SPEED_KOL := :NEW.SPEED_KOL;
    v_new.NOM_ZD := :NEW.NOM_ZD;
    v_new.FACT_VES := :NEW.FACT_VES;
    v_new.FACT_KOL := :NEW.FACT_KOL;
    v_new.GU12_A_ID := :NEW.GU12_A_ID;
    v_new.IS_AUTO := :NEW.IS_AUTO;
    v_new.BEGIN_DATE := :NEW.BEGIN_DATE;
    v_new.GRAFIK := :NEW.GRAFIK;
    v_new.POTREB_ID := :NEW.POTREB_ID;
    v_new.LOAD_VES := :NEW.LOAD_VES;
    v_new.LOAD_KOL := :NEW.LOAD_KOL;
    v_new.LINK_ID := :NEW.LINK_ID;
    v_new.LINK_HIST_ID := :NEW.LINK_HIST_ID;
    v_new.IS_AUTO_MONTH := :NEW.IS_AUTO_MONTH;
    v_new.KOD_ISU := :NEW.KOD_ISU;

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
            SELECT LogId,'ZAKAZ_HIST',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;

        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'ZAKAZ_HIST',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;
      ELSE
        -- PRIMARY KEY не изменился, добавляем в лог 1 запись
        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
            SELECT LogId,'ZAKAZ_HIST',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'U',EMPTY_CLOB()
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
          IF V_OLD.ZAKAZ_ID<>V_NEW.ZAKAZ_ID THEN
            WriteStr:=':OLD.ZAKAZ_ID=' || TO_CHAR(V_OLD.ZAKAZ_ID) || ' :NEW.ZAKAZ_ID=' || TO_CHAR(V_NEW.ZAKAZ_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SORTBY<>V_NEW.SORTBY THEN
            WriteStr:=':OLD.SORTBY=' || TO_CHAR(V_OLD.SORTBY) || ' :NEW.SORTBY=' || TO_CHAR(V_NEW.SORTBY) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.STATUS_ZAKAZ_ID<>V_NEW.STATUS_ZAKAZ_ID THEN
            WriteStr:=':OLD.STATUS_ZAKAZ_ID=' || TO_CHAR(V_OLD.STATUS_ZAKAZ_ID) || ' :NEW.STATUS_ZAKAZ_ID=' || TO_CHAR(V_NEW.STATUS_ZAKAZ_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.CLIENT_NUMBER||' '<>V_NEW.CLIENT_NUMBER||' ' THEN
            WriteStr:=':OLD.CLIENT_NUMBER=' || (V_OLD.CLIENT_NUMBER) || ' :NEW.CLIENT_NUMBER=' || (V_NEW.CLIENT_NUMBER) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.CLIENT_DATE<>V_NEW.CLIENT_DATE THEN
            WriteStr:=':OLD.CLIENT_DATE=' || TO_CHAR(V_OLD.CLIENT_DATE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.CLIENT_DATE=' || TO_CHAR(V_NEW.CLIENT_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.INPUT_NUMBER||' '<>V_NEW.INPUT_NUMBER||' ' THEN
            WriteStr:=':OLD.INPUT_NUMBER=' || (V_OLD.INPUT_NUMBER) || ' :NEW.INPUT_NUMBER=' || (V_NEW.INPUT_NUMBER) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.INPUT_DATE<>V_NEW.INPUT_DATE THEN
            WriteStr:=':OLD.INPUT_DATE=' || TO_CHAR(V_OLD.INPUT_DATE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.INPUT_DATE=' || TO_CHAR(V_NEW.INPUT_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PROD_ID_NPR||' '<>V_NEW.PROD_ID_NPR||' ' THEN
            WriteStr:=':OLD.PROD_ID_NPR=' || (V_OLD.PROD_ID_NPR) || ' :NEW.PROD_ID_NPR=' || (V_NEW.PROD_ID_NPR) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.OLD_STAN_ID<>V_NEW.OLD_STAN_ID THEN
            WriteStr:=':OLD.OLD_STAN_ID=' || TO_CHAR(V_OLD.OLD_STAN_ID) || ' :NEW.OLD_STAN_ID=' || TO_CHAR(V_NEW.OLD_STAN_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.STAN_ID<>V_NEW.STAN_ID THEN
            WriteStr:=':OLD.STAN_ID=' || TO_CHAR(V_OLD.STAN_ID) || ' :NEW.STAN_ID=' || TO_CHAR(V_NEW.STAN_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.POLUCH_ID<>V_NEW.POLUCH_ID THEN
            WriteStr:=':OLD.POLUCH_ID=' || TO_CHAR(V_OLD.POLUCH_ID) || ' :NEW.POLUCH_ID=' || TO_CHAR(V_NEW.POLUCH_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PRICE<>V_NEW.PRICE THEN
            WriteStr:=':OLD.PRICE=' || TO_CHAR(V_OLD.PRICE) || ' :NEW.PRICE=' || TO_CHAR(V_NEW.PRICE) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.VES<>V_NEW.VES THEN
            WriteStr:=':OLD.VES=' || TO_CHAR(V_OLD.VES) || ' :NEW.VES=' || TO_CHAR(V_NEW.VES) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.KOL<>V_NEW.KOL THEN
            WriteStr:=':OLD.KOL=' || TO_CHAR(V_OLD.KOL) || ' :NEW.KOL=' || TO_CHAR(V_NEW.KOL) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SPEED_VES<>V_NEW.SPEED_VES THEN
            WriteStr:=':OLD.SPEED_VES=' || TO_CHAR(V_OLD.SPEED_VES) || ' :NEW.SPEED_VES=' || TO_CHAR(V_NEW.SPEED_VES) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SPEED_KOL<>V_NEW.SPEED_KOL THEN
            WriteStr:=':OLD.SPEED_KOL=' || TO_CHAR(V_OLD.SPEED_KOL) || ' :NEW.SPEED_KOL=' || TO_CHAR(V_NEW.SPEED_KOL) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NOM_ZD||' '<>V_NEW.NOM_ZD||' ' THEN
            WriteStr:=':OLD.NOM_ZD=' || (V_OLD.NOM_ZD) || ' :NEW.NOM_ZD=' || (V_NEW.NOM_ZD) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
/*          IF V_OLD.FACT_VES<>V_NEW.FACT_VES THEN
            WriteStr:=':OLD.FACT_VES=' || TO_CHAR(V_OLD.FACT_VES) || ' :NEW.FACT_VES=' || TO_CHAR(V_NEW.FACT_VES) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.FACT_KOL<>V_NEW.FACT_KOL THEN
            WriteStr:=':OLD.FACT_KOL=' || TO_CHAR(V_OLD.FACT_KOL) || ' :NEW.FACT_KOL=' || TO_CHAR(V_NEW.FACT_KOL) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;*/
          IF V_OLD.GU12_A_ID<>V_NEW.GU12_A_ID THEN
            WriteStr:=':OLD.GU12_A_ID=' || TO_CHAR(V_OLD.GU12_A_ID) || ' :NEW.GU12_A_ID=' || TO_CHAR(V_NEW.GU12_A_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.IS_AUTO<>V_NEW.IS_AUTO THEN
            WriteStr:=':OLD.IS_AUTO=' || TO_CHAR(V_OLD.IS_AUTO) || ' :NEW.IS_AUTO=' || TO_CHAR(V_NEW.IS_AUTO) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.BEGIN_DATE<>V_NEW.BEGIN_DATE THEN
            WriteStr:=':OLD.BEGIN_DATE=' || TO_CHAR(V_OLD.BEGIN_DATE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.BEGIN_DATE=' || TO_CHAR(V_NEW.BEGIN_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.GRAFIK||' '<>V_NEW.GRAFIK||' ' THEN
            WriteStr:=':OLD.GRAFIK=' || (V_OLD.GRAFIK) || ' :NEW.GRAFIK=' || (V_NEW.GRAFIK) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.POTREB_ID<>V_NEW.POTREB_ID THEN
            WriteStr:=':OLD.POTREB_ID=' || TO_CHAR(V_OLD.POTREB_ID) || ' :NEW.POTREB_ID=' || TO_CHAR(V_NEW.POTREB_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.LOAD_VES<>V_NEW.LOAD_VES THEN
            WriteStr:=':OLD.LOAD_VES=' || TO_CHAR(V_OLD.LOAD_VES) || ' :NEW.LOAD_VES=' || TO_CHAR(V_NEW.LOAD_VES) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.LOAD_KOL<>V_NEW.LOAD_KOL THEN
            WriteStr:=':OLD.LOAD_KOL=' || TO_CHAR(V_OLD.LOAD_KOL) || ' :NEW.LOAD_KOL=' || TO_CHAR(V_NEW.LOAD_KOL) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.LINK_ID<>V_NEW.LINK_ID THEN
            WriteStr:=':OLD.LINK_ID=' || TO_CHAR(V_OLD.LINK_ID) || ' :NEW.LINK_ID=' || TO_CHAR(V_NEW.LINK_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.LINK_HIST_ID<>V_NEW.LINK_HIST_ID THEN
            WriteStr:=':OLD.LINK_HIST_ID=' || TO_CHAR(V_OLD.LINK_HIST_ID) || ' :NEW.LINK_HIST_ID=' || TO_CHAR(V_NEW.LINK_HIST_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.IS_AUTO_MONTH<>V_NEW.IS_AUTO_MONTH THEN
            WriteStr:=':OLD.IS_AUTO_MONTH=' || TO_CHAR(V_OLD.IS_AUTO_MONTH) || ' :NEW.IS_AUTO_MONTH=' || TO_CHAR(V_NEW.IS_AUTO_MONTH) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.KOD_ISU||' '<>V_NEW.KOD_ISU||' ' THEN
            WriteStr:=':OLD.KOD_ISU=' || (V_OLD.KOD_ISU) || ' :NEW.KOD_ISU=' || (V_NEW.KOD_ISU) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
        
          IF WritePos=1 THEN
            DELETE FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG WHERE ID = LogId;
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
          SELECT LogId,'ZAKAZ_HIST',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I',EMPTY_CLOB()
            FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');

        SELECT WhatWasDone INTO cl_WhatWasDone
            FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG
            WHERE ID = LogId
            FOR UPDATE;

        WritePos:=1;

        WriteStr:=':OLD.ZAKAZ_ID=' || TO_CHAR(V_OLD.ZAKAZ_ID) || ' :NEW.ZAKAZ_ID=' || TO_CHAR(V_NEW.ZAKAZ_ID) || CHR(13);
        dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
        WritePos:=WritePos+LENGTH(WriteStr);
        WriteStr:=':OLD.STATUS_ZAKAZ_ID=' || TO_CHAR(V_OLD.STATUS_ZAKAZ_ID) || ' :NEW.STATUS_ZAKAZ_ID=' || TO_CHAR(V_NEW.STATUS_ZAKAZ_ID) || CHR(13);
        dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
        WritePos:=WritePos+LENGTH(WriteStr);
        WriteStr:=':OLD.CLIENT_NUMBER=' || (V_OLD.CLIENT_NUMBER) || ' :NEW.CLIENT_NUMBER=' || (V_NEW.CLIENT_NUMBER) || CHR(13);
        dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
        WritePos:=WritePos+LENGTH(WriteStr);
        WriteStr:=':OLD.INPUT_NUMBER=' || (V_OLD.INPUT_NUMBER) || ' :NEW.INPUT_NUMBER=' || (V_NEW.INPUT_NUMBER) || CHR(13);
        dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
        WritePos:=WritePos+LENGTH(WriteStr);
        WriteStr:=':OLD.VES=' || TO_CHAR(V_OLD.VES) || ' :NEW.VES=' || TO_CHAR(V_NEW.VES) || CHR(13);
        dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
        WritePos:=WritePos+LENGTH(WriteStr);
        WriteStr:=':OLD.KOL=' || TO_CHAR(V_OLD.KOL) || ' :NEW.KOL=' || TO_CHAR(V_NEW.KOL) || CHR(13);
        dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
        WritePos:=WritePos+LENGTH(WriteStr);
        WriteStr:=':OLD.NOM_ZD=' || (V_OLD.NOM_ZD) || ' :NEW.NOM_ZD=' || (V_NEW.NOM_ZD) || CHR(13);
        dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
        WritePos:=WritePos+LENGTH(WriteStr);
        WriteStr:=':OLD.IS_AUTO=' || TO_CHAR(V_OLD.IS_AUTO) || ' :NEW.IS_AUTO=' || TO_CHAR(V_NEW.IS_AUTO) || CHR(13);
        dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
        WritePos:=WritePos+LENGTH(WriteStr);
        WriteStr:=':OLD.LOAD_VES=' || TO_CHAR(V_OLD.LOAD_VES) || ' :NEW.LOAD_VES=' || TO_CHAR(V_NEW.LOAD_VES) || CHR(13);
        dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
        WritePos:=WritePos+LENGTH(WriteStr);
        WriteStr:=':OLD.LOAD_KOL=' || TO_CHAR(V_OLD.LOAD_KOL) || ' :NEW.LOAD_KOL=' || TO_CHAR(V_NEW.LOAD_KOL) || CHR(13);
        dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
        WritePos:=WritePos+LENGTH(WriteStr);
        WriteStr:=':OLD.LINK_ID=' || TO_CHAR(V_OLD.LINK_ID) || ' :NEW.LINK_ID=' || TO_CHAR(V_NEW.LINK_ID) || CHR(13);
        dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
        WritePos:=WritePos+LENGTH(WriteStr);
        WriteStr:=':OLD.LINK_HIST_ID=' || TO_CHAR(V_OLD.LINK_HIST_ID) || ' :NEW.LINK_HIST_ID=' || TO_CHAR(V_NEW.LINK_HIST_ID) || CHR(13);
        dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
        WritePos:=WritePos+LENGTH(WriteStr);
        WriteStr:=':OLD.IS_AUTO_MONTH=' || TO_CHAR(V_OLD.IS_AUTO_MONTH) || ' :NEW.IS_AUTO_MONTH=' || TO_CHAR(V_NEW.IS_AUTO_MONTH) || CHR(13);
        dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
        WritePos:=WritePos+LENGTH(WriteStr);
        WriteStr:=':OLD.KOD_ISU=' || (V_OLD.KOD_ISU) || ' :NEW.KOD_ISU=' || (V_NEW.KOD_ISU) || CHR(13);
        dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
        WritePos:=WritePos+LENGTH(WriteStr);
      END IF;
    END IF;

  END IF;
END;
/


ALTER TRIGGER MASTER.T99_LOG_ZAKAZ_HIST DISABLE;


