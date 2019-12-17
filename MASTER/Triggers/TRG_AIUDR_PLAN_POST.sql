--
-- TRG_AIUDR_PLAN_POST  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_PLAN_POST
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.PLAN_POST
FOR EACH ROW
DECLARE
  v_old PLAN_POST%ROWTYPE;
  v_new PLAN_POST%ROWTYPE;
  v_tmp NUMBER;
  v_num_izm NUMBER;
  v_per_id NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.PLAN_CENA := :OLD.PLAN_CENA;
    v_old.PLAN_VES := :OLD.PLAN_VES;
    v_old.PLAN_SUM := :OLD.PLAN_SUM;
    v_old.DATE_CENA := :OLD.DATE_CENA;
    v_old.PLAN_ID := :OLD.PLAN_ID;
    v_old.PLAN_PER_ID := :OLD.PLAN_PER_ID;
    v_old.PLANSTRU_ID := :OLD.PLANSTRU_ID;
    v_old.DOG_ID := :OLD.DOG_ID;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.PAYFORM_ID := :OLD.PAYFORM_ID;
    v_old.CAT_CEN_ID := :OLD.CAT_CEN_ID;
    v_old.APPL_TAG := :OLD.APPL_TAG;
  END IF;
  
  IF DELETING() THEN
	v_per_id := :OLD.PLAN_PER_ID;
  ELSE	
	v_per_id := :NEW.PLAN_PER_ID;
  END IF;

  -- Определение номера текущего изменения плана
  BEGIN
    SELECT NUM_IZM_POST
      INTO v_num_izm
      FROM PLAN_PERIODS
      WHERE ID=v_per_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_ROW, 'Плановый период не открыт');
	  v_num_izm := 0;
  END;
  
  -- После удаления
  IF DELETING() THEN
    NULL;
    -- Удаление из теневой таблицы
/*
    DELETE FROM MASTER_SHADOW.PLAN_POST_SHADOW
     WHERE ID=v_old.ID;
*/	 
    -- Запись в лог
    IF v_old.APPL_TAG='MASTER' THEN
      SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
      INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
        SELECT LogId,'PLAN_POST',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D'
          FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
    END IF;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.PLAN_CENA := :NEW.PLAN_CENA;
    v_new.PLAN_VES := :NEW.PLAN_VES;
    v_new.PLAN_SUM := :NEW.PLAN_SUM;
    v_new.DATE_CENA := :NEW.DATE_CENA;
    v_new.PLAN_ID := :NEW.PLAN_ID;
    v_new.PLAN_PER_ID := :NEW.PLAN_PER_ID;
    v_new.PLANSTRU_ID := :NEW.PLANSTRU_ID;
    v_new.DOG_ID := :NEW.DOG_ID;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.PAYFORM_ID := :NEW.PAYFORM_ID;
    v_new.CAT_CEN_ID := :NEW.CAT_CEN_ID;
    v_new.APPL_TAG := :NEW.APPL_TAG;

    -- Обновление теневой таблицы
/*
    UPDATE MASTER_SHADOW.PLAN_POST_SHADOW SET
      (ID,PLAN_CENA,PLAN_VES,PLAN_SUM,PLAN_ID,PLAN_PER_ID,PLANSTRU_ID,DOG_ID,PROD_ID_NPR,PAYFORM_ID,DATE_CENA,CAT_CEN_ID,APPL_TAG)=
      (SELECT v_new.ID,v_new.PLAN_CENA,v_new.PLAN_VES,v_new.PLAN_SUM,v_new.PLAN_ID,v_new.PLAN_PER_ID,v_new.PLANSTRU_ID,v_new.DOG_ID,v_new.PROD_ID_NPR,v_new.PAYFORM_ID,v_new.DATE_CENA,v_new.CAT_CEN_ID,v_new.APPL_TAG FROM dual)
      WHERE ID=v_old.ID;

    IF SQL%NOTFOUND THEN
      INSERT INTO MASTER_SHADOW.PLAN_POST_SHADOW
        (ID,PLAN_CENA,PLAN_VES,PLAN_SUM,PLAN_ID,PLAN_PER_ID,PLANSTRU_ID,DOG_ID,PROD_ID_NPR,PAYFORM_ID,DATE_CENA,CAT_CEN_ID,APPL_TAG)
        VALUES
        (v_new.ID,v_new.PLAN_CENA,v_new.PLAN_VES,v_new.PLAN_SUM,v_new.PLAN_ID,v_new.PLAN_PER_ID,v_new.PLANSTRU_ID,v_new.DOG_ID,v_new.PROD_ID_NPR,v_new.PAYFORM_ID,v_new.DATE_CENA,v_new.CAT_CEN_ID,v_new.APPL_TAG);
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
            SELECT LogId,'PLAN_POST',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;

        -- Запись в лог
        IF v_new.APPL_TAG='MASTER' THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'PLAN_POST',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;
      ELSE
        -- PRIMARY KEY не изменился, добавляем в лог 1 запись
        -- Запись в лог
        IF v_new.APPL_TAG='MASTER' THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
            SELECT LogId,'PLAN_POST',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'U',EMPTY_CLOB()
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');

          SELECT WhatWasDone INTO cl_WhatWasDone
            FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG
            WHERE ID = LogId
            FOR UPDATE;

          WritePos:=1;

          IF V_OLD.PLAN_CENA<>V_NEW.PLAN_CENA THEN
            WriteStr:=':OLD.PLAN_CENA=' || TO_CHAR(V_OLD.PLAN_CENA) || ' :NEW.PLAN_CENA=' || TO_CHAR(V_NEW.PLAN_CENA) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PLAN_VES<>V_NEW.PLAN_VES THEN
            WriteStr:=':OLD.PLAN_VES=' || TO_CHAR(V_OLD.PLAN_VES) || ' :NEW.PLAN_VES=' || TO_CHAR(V_NEW.PLAN_VES) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PLAN_ID<>V_NEW.PLAN_ID THEN
            WriteStr:=':OLD.PLAN_ID=' || TO_CHAR(V_OLD.PLAN_ID) || ' :NEW.PLAN_ID=' || TO_CHAR(V_NEW.PLAN_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PLAN_PER_ID<>V_NEW.PLAN_PER_ID THEN
            WriteStr:=':OLD.PLAN_PER_ID=' || TO_CHAR(V_OLD.PLAN_PER_ID) || ' :NEW.PLAN_PER_ID=' || TO_CHAR(V_NEW.PLAN_PER_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PLANSTRU_ID<>V_NEW.PLANSTRU_ID THEN
            WriteStr:=':OLD.PLANSTRU_ID=' || TO_CHAR(V_OLD.PLANSTRU_ID) || ' :NEW.PLANSTRU_ID=' || TO_CHAR(V_NEW.PLANSTRU_ID) || CHR(13);
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
          IF V_OLD.PAYFORM_ID<>V_NEW.PAYFORM_ID THEN
            WriteStr:=':OLD.PAYFORM_ID=' || TO_CHAR(V_OLD.PAYFORM_ID) || ' :NEW.PAYFORM_ID=' || TO_CHAR(V_NEW.PAYFORM_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DATE_CENA<>V_NEW.DATE_CENA THEN
            WriteStr:=':OLD.DATE_CENA=' || TO_CHAR(V_OLD.DATE_CENA,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_CENA=' || TO_CHAR(V_NEW.DATE_CENA,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.CAT_CEN_ID<>V_NEW.CAT_CEN_ID THEN
            WriteStr:=':OLD.CAT_CEN_ID=' || TO_CHAR(V_OLD.CAT_CEN_ID) || ' :NEW.CAT_CEN_ID=' || TO_CHAR(V_NEW.CAT_CEN_ID) || CHR(13);
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
          SELECT LogId,'PLAN_POST',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
            FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
      END IF;
    END IF;

  END IF;
END;
/


