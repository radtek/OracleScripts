--
-- T99_LOG_ZAKAZ  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.T99_LOG_ZAKAZ
/* ---------------------------------------------
  Генератор скриптов для MASTER
  PSV v1.04
--------------------------------------------- */
 AFTER DELETE OR INSERT OR UPDATE ON MASTER.ZAKAZ  FOR EACH ROW
DECLARE
  v_old ZAKAZ%ROWTYPE;
  v_new ZAKAZ%ROWTYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.IS_AGENT := :OLD.IS_AGENT;
    v_old.DATE_PLAN := :OLD.DATE_PLAN;
    v_old.CLIENT_NUMBER := :OLD.CLIENT_NUMBER;
    v_old.CLIENT_DATE := :OLD.CLIENT_DATE;
    v_old.INPUT_NUMBER := :OLD.INPUT_NUMBER;
    v_old.INPUT_DATE := :OLD.INPUT_DATE;
    v_old.BEGIN_DATE := :OLD.BEGIN_DATE;
    v_old.IS_ACCEPT := :OLD.IS_ACCEPT;
    v_old.FILIAL_ID := :OLD.FILIAL_ID;
    v_old.PLAT_ID := :OLD.PLAT_ID;
    v_old.DOG_ID := :OLD.DOG_ID;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.USL_OPL_ID := :OLD.USL_OPL_ID;
    v_old.LOAD_ABBR := :OLD.LOAD_ABBR;
    v_old.STAN_ID := :OLD.STAN_ID;
    v_old.VETKA_ID := :OLD.VETKA_ID;
    v_old.POLUCH_ID := :OLD.POLUCH_ID;
    v_old.POTREB_ID := :OLD.POTREB_ID;
    v_old.POTREB_NAME := :OLD.POTREB_NAME;
    v_old.NEFTEBASA := :OLD.NEFTEBASA;
    v_old.PAYFORM_ID := :OLD.PAYFORM_ID;
    v_old.PLANSTRU_ID := :OLD.PLANSTRU_ID;
    v_old.PRICE_CLIENT := :OLD.PRICE_CLIENT;
    v_old.PRICE := :OLD.PRICE;
    v_old.VES := :OLD.VES;
    v_old.KOL := :OLD.KOL;
    v_old.SPEED_VES := :OLD.SPEED_VES;
    v_old.SPEED_KOL := :OLD.SPEED_KOL;
    v_old.NOM_ZD_LIST := :OLD.NOM_ZD_LIST;
    v_old.FACT_VES := :OLD.FACT_VES;
    v_old.FACT_KOL := :OLD.FACT_KOL;
    v_old.PRIM := :OLD.PRIM;
    v_old.GR4 := :OLD.GR4;
    v_old.LOAD_VES := :OLD.LOAD_VES;
    v_old.LOAD_KOL := :OLD.LOAD_KOL;
    v_old.ZAKAZ_PREV_ID := :OLD.ZAKAZ_PREV_ID;
    v_old.GOSPROG_ID := :OLD.GOSPROG_ID;
    v_old.GP_NAPR_ID := :OLD.GP_NAPR_ID;
    v_old.LUKDOG_ID := :OLD.LUKDOG_ID;
    v_old.IS_AUTO := :OLD.IS_AUTO;
    v_old.LINK_ID := :OLD.LINK_ID;
    v_old.LINK_HIST_ID := :OLD.LINK_HIST_ID;
    v_old.PERIOD_ID := :OLD.PERIOD_ID;
    v_old.TIP_CORP_ID := :OLD.TIP_CORP_ID;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
    -- Запись в лог
    IF 1=1 THEN
      SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
      INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
        SELECT LogId,'ZAKAZ',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D'
          FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
    END IF;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.IS_AGENT := :NEW.IS_AGENT;
    v_new.DATE_PLAN := :NEW.DATE_PLAN;
    v_new.CLIENT_NUMBER := :NEW.CLIENT_NUMBER;
    v_new.CLIENT_DATE := :NEW.CLIENT_DATE;
    v_new.INPUT_NUMBER := :NEW.INPUT_NUMBER;
    v_new.INPUT_DATE := :NEW.INPUT_DATE;
    v_new.BEGIN_DATE := :NEW.BEGIN_DATE;
    v_new.IS_ACCEPT := :NEW.IS_ACCEPT;
    v_new.FILIAL_ID := :NEW.FILIAL_ID;
    v_new.PLAT_ID := :NEW.PLAT_ID;
    v_new.DOG_ID := :NEW.DOG_ID;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.USL_OPL_ID := :NEW.USL_OPL_ID;
    v_new.LOAD_ABBR := :NEW.LOAD_ABBR;
    v_new.STAN_ID := :NEW.STAN_ID;
    v_new.VETKA_ID := :NEW.VETKA_ID;
    v_new.POLUCH_ID := :NEW.POLUCH_ID;
    v_new.POTREB_ID := :NEW.POTREB_ID;
    v_new.POTREB_NAME := :NEW.POTREB_NAME;
    v_new.NEFTEBASA := :NEW.NEFTEBASA;
    v_new.PAYFORM_ID := :NEW.PAYFORM_ID;
    v_new.PLANSTRU_ID := :NEW.PLANSTRU_ID;
    v_new.PRICE_CLIENT := :NEW.PRICE_CLIENT;
    v_new.PRICE := :NEW.PRICE;
    v_new.VES := :NEW.VES;
    v_new.KOL := :NEW.KOL;
    v_new.SPEED_VES := :NEW.SPEED_VES;
    v_new.SPEED_KOL := :NEW.SPEED_KOL;
    v_new.NOM_ZD_LIST := :NEW.NOM_ZD_LIST;
    v_new.FACT_VES := :NEW.FACT_VES;
    v_new.FACT_KOL := :NEW.FACT_KOL;
    v_new.PRIM := :NEW.PRIM;
    v_new.GR4 := :NEW.GR4;
    v_new.LOAD_VES := :NEW.LOAD_VES;
    v_new.LOAD_KOL := :NEW.LOAD_KOL;
    v_new.ZAKAZ_PREV_ID := :NEW.ZAKAZ_PREV_ID;
    v_new.GOSPROG_ID := :NEW.GOSPROG_ID;
    v_new.GP_NAPR_ID := :NEW.GP_NAPR_ID;
    v_new.LUKDOG_ID := :NEW.LUKDOG_ID;
    v_new.IS_AUTO := :NEW.IS_AUTO;
    v_new.LINK_ID := :NEW.LINK_ID;
    v_new.LINK_HIST_ID := :NEW.LINK_HIST_ID;
    v_new.PERIOD_ID := :NEW.PERIOD_ID;
    v_new.TIP_CORP_ID := :NEW.TIP_CORP_ID;

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
            SELECT LogId,'ZAKAZ',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;

        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'ZAKAZ',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;
      ELSE
        -- PRIMARY KEY не изменился, добавляем в лог 1 запись
        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
            SELECT LogId,'ZAKAZ',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'U',EMPTY_CLOB()
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
          IF V_OLD.IS_AGENT<>V_NEW.IS_AGENT THEN
            WriteStr:=':OLD.IS_AGENT=' || TO_CHAR(V_OLD.IS_AGENT) || ' :NEW.IS_AGENT=' || TO_CHAR(V_NEW.IS_AGENT) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DATE_PLAN<>V_NEW.DATE_PLAN THEN
            WriteStr:=':OLD.DATE_PLAN=' || TO_CHAR(V_OLD.DATE_PLAN,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_PLAN=' || TO_CHAR(V_NEW.DATE_PLAN,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
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
          IF V_OLD.BEGIN_DATE<>V_NEW.BEGIN_DATE THEN
            WriteStr:=':OLD.BEGIN_DATE=' || TO_CHAR(V_OLD.BEGIN_DATE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.BEGIN_DATE=' || TO_CHAR(V_NEW.BEGIN_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.IS_ACCEPT<>V_NEW.IS_ACCEPT THEN
            WriteStr:=':OLD.IS_ACCEPT=' || TO_CHAR(V_OLD.IS_ACCEPT) || ' :NEW.IS_ACCEPT=' || TO_CHAR(V_NEW.IS_ACCEPT) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.FILIAL_ID<>V_NEW.FILIAL_ID THEN
            WriteStr:=':OLD.FILIAL_ID=' || TO_CHAR(V_OLD.FILIAL_ID) || ' :NEW.FILIAL_ID=' || TO_CHAR(V_NEW.FILIAL_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PLAT_ID<>V_NEW.PLAT_ID THEN
            WriteStr:=':OLD.PLAT_ID=' || TO_CHAR(V_OLD.PLAT_ID) || ' :NEW.PLAT_ID=' || TO_CHAR(V_NEW.PLAT_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DOG_ID<>V_NEW.DOG_ID THEN
            WriteStr:=':OLD.DOG_ID=' || TO_CHAR(V_OLD.DOG_ID) || ' :NEW.DOG_ID=' || TO_CHAR(V_NEW.DOG_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PROD_ID_NPR||' '<>V_NEW.PROD_ID_NPR||' ' THEN
            WriteStr:=':OLD.PROD_ID_NPR=' || (V_OLD.PROD_ID_NPR) || ' :NEW.PROD_ID_NPR=' || (V_NEW.PROD_ID_NPR) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.USL_OPL_ID<>V_NEW.USL_OPL_ID THEN
            WriteStr:=':OLD.USL_OPL_ID=' || TO_CHAR(V_OLD.USL_OPL_ID) || ' :NEW.USL_OPL_ID=' || TO_CHAR(V_NEW.USL_OPL_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.LOAD_ABBR||' '<>V_NEW.LOAD_ABBR||' ' THEN
            WriteStr:=':OLD.LOAD_ABBR=' || (V_OLD.LOAD_ABBR) || ' :NEW.LOAD_ABBR=' || (V_NEW.LOAD_ABBR) || CHR(13);
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
          IF V_OLD.POTREB_NAME||' '<>V_NEW.POTREB_NAME||' ' THEN
            WriteStr:=':OLD.POTREB_NAME=' || (V_OLD.POTREB_NAME) || ' :NEW.POTREB_NAME=' || (V_NEW.POTREB_NAME) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NEFTEBASA||' '<>V_NEW.NEFTEBASA||' ' THEN
            WriteStr:=':OLD.NEFTEBASA=' || (V_OLD.NEFTEBASA) || ' :NEW.NEFTEBASA=' || (V_NEW.NEFTEBASA) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PAYFORM_ID<>V_NEW.PAYFORM_ID THEN
            WriteStr:=':OLD.PAYFORM_ID=' || TO_CHAR(V_OLD.PAYFORM_ID) || ' :NEW.PAYFORM_ID=' || TO_CHAR(V_NEW.PAYFORM_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PLANSTRU_ID<>V_NEW.PLANSTRU_ID THEN
            WriteStr:=':OLD.PLANSTRU_ID=' || TO_CHAR(V_OLD.PLANSTRU_ID) || ' :NEW.PLANSTRU_ID=' || TO_CHAR(V_NEW.PLANSTRU_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PRICE_CLIENT<>V_NEW.PRICE_CLIENT THEN
            WriteStr:=':OLD.PRICE_CLIENT=' || TO_CHAR(V_OLD.PRICE_CLIENT) || ' :NEW.PRICE_CLIENT=' || TO_CHAR(V_NEW.PRICE_CLIENT) || CHR(13);
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
          IF V_OLD.NOM_ZD_LIST||' '<>V_NEW.NOM_ZD_LIST||' ' THEN
            WriteStr:=':OLD.NOM_ZD_LIST=' || (V_OLD.NOM_ZD_LIST) || ' :NEW.NOM_ZD_LIST=' || (V_NEW.NOM_ZD_LIST) || CHR(13);
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
          IF V_OLD.PRIM||' '<>V_NEW.PRIM||' ' THEN
            WriteStr:=':OLD.PRIM=' || (V_OLD.PRIM) || ' :NEW.PRIM=' || (V_NEW.PRIM) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.GR4||' '<>V_NEW.GR4||' ' THEN
            WriteStr:=':OLD.GR4=' || (V_OLD.GR4) || ' :NEW.GR4=' || (V_NEW.GR4) || CHR(13);
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
          IF V_OLD.ZAKAZ_PREV_ID<>V_NEW.ZAKAZ_PREV_ID THEN
            WriteStr:=':OLD.ZAKAZ_PREV_ID=' || TO_CHAR(V_OLD.ZAKAZ_PREV_ID) || ' :NEW.ZAKAZ_PREV_ID=' || TO_CHAR(V_NEW.ZAKAZ_PREV_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.GOSPROG_ID<>V_NEW.GOSPROG_ID THEN
            WriteStr:=':OLD.GOSPROG_ID=' || TO_CHAR(V_OLD.GOSPROG_ID) || ' :NEW.GOSPROG_ID=' || TO_CHAR(V_NEW.GOSPROG_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.GP_NAPR_ID<>V_NEW.GP_NAPR_ID THEN
            WriteStr:=':OLD.GP_NAPR_ID=' || TO_CHAR(V_OLD.GP_NAPR_ID) || ' :NEW.GP_NAPR_ID=' || TO_CHAR(V_NEW.GP_NAPR_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.LUKDOG_ID<>V_NEW.LUKDOG_ID THEN
            WriteStr:=':OLD.LUKDOG_ID=' || TO_CHAR(V_OLD.LUKDOG_ID) || ' :NEW.LUKDOG_ID=' || TO_CHAR(V_NEW.LUKDOG_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.IS_AUTO<>V_NEW.IS_AUTO THEN
            WriteStr:=':OLD.IS_AUTO=' || TO_CHAR(V_OLD.IS_AUTO) || ' :NEW.IS_AUTO=' || TO_CHAR(V_NEW.IS_AUTO) || CHR(13);
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
          IF V_OLD.PERIOD_ID<>V_NEW.PERIOD_ID THEN
            WriteStr:=':OLD.PERIOD_ID=' || TO_CHAR(V_OLD.PERIOD_ID) || ' :NEW.PERIOD_ID=' || TO_CHAR(V_NEW.PERIOD_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.TIP_CORP_ID<>V_NEW.TIP_CORP_ID THEN
            WriteStr:=':OLD.TIP_CORP_ID=' || TO_CHAR(V_OLD.TIP_CORP_ID) || ' :NEW.TIP_CORP_ID=' || TO_CHAR(V_NEW.TIP_CORP_ID) || CHR(13);
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
        INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
          SELECT LogId,'ZAKAZ',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
            FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
      END IF;
    END IF;

  END IF;
END;
/


ALTER TRIGGER MASTER.T99_LOG_ZAKAZ DISABLE;


