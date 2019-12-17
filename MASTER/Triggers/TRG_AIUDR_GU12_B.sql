--
-- TRG_AIUDR_GU12_B  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_GU12_B
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.GU12_B
FOR EACH ROW
DECLARE
  v_old GU12_B%ROWTYPE;
  v_new GU12_B%ROWTYPE;
  vNOM_Z GU12_A.NOM_Z%TYPE;
  vFROM_DATE GU12_A.FROM_DATE%TYPE;
  vSTAN_ID KLS_STAN.ID%TYPE;
  vSTAN_KOD KLS_STAN.STAN_KOD%TYPE;
  vSTAN_NAME KLS_STAN.STAN_NAME%TYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN
  -- Выборка из родительской таблицы
  IF DELETING() THEN
    SELECT a.NOM_Z,a.FROM_DATE
	  INTO vNOM_Z,vFROM_DATE
	  FROM GU12_A a
	 WHERE a.ID=:old.ID_A;

    vSTAN_ID := :OLD.STAN_ID;
  ELSE
    SELECT a.NOM_Z,a.FROM_DATE
	  INTO vNOM_Z,vFROM_DATE
	  FROM GU12_A a
	 WHERE a.ID=:new.ID_A;

    vSTAN_ID := :NEW.STAN_ID;
  END IF;

  IF NVL(vSTAN_ID,0)<>0 THEN
    SELECT s.STAN_KOD,s.STAN_NAME
      INTO vSTAN_KOD,vSTAN_NAME
      FROM KLS_STAN s
     WHERE ID=vSTAN_ID;
  ELSE
    vSTAN_KOD:='';
	vSTAN_NAME:='';	 
  END IF;	 

  --
  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.PDATE := :OLD.PDATE;
    v_old.SOBSTVVAG_ID := :OLD.SOBSTVVAG_ID;
    v_old.STAN_ID := :OLD.STAN_ID;
    v_old.STAN_PER_ID := :OLD.STAN_PER_ID;
    v_old.GRUZPOL_ID := :OLD.GRUZPOL_ID;
    v_old.KOL_VAG := :OLD.KOL_VAG;
    v_old.VES := :OLD.VES;
    v_old.VIDOTPR_ID := :OLD.VIDOTPR_ID;
    v_old.MRK := :OLD.MRK;
    v_old.ID_A := :OLD.ID_A;
    v_old.ID := :OLD.ID;
    v_old.PLAT_ID := :OLD.PLAT_ID;
    v_old.FOX_KOD := :OLD.FOX_KOD;
    v_old.ISCOR := :OLD.ISCOR;
    v_old.DATE_LETTER := :OLD.DATE_LETTER;
    v_old.NOM_LETTER := :OLD.NOM_LETTER;
    v_old.DATE_VHOD := :OLD.DATE_VHOD;
    v_old.NOM_VHOD := :OLD.NOM_VHOD;
    v_old.PRINVAG_ID := :OLD.PRINVAG_ID;
    v_old.OLD_ID := :OLD.OLD_ID;
    v_old.STATES_ID := :OLD.STATES_ID;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
    -- Добавление в теневую таблицу
    INSERT INTO MASTER_SHADOW.GU12_B_DELETED
      (PDATE,SOBSTVVAG_ID,STAN_ID,STAN_PER_ID,GRUZPOL_ID,KOL_VAG,VES,VIDOTPR_ID,MRK,ID_A,ID,PLAT_ID,FOX_KOD,ISCOR,DATE_LETTER,NOM_LETTER,DATE_VHOD,NOM_VHOD,PRINVAG_ID,OLD_ID,STATES_ID)
    VALUES
      (v_old.PDATE,v_old.SOBSTVVAG_ID,v_old.STAN_ID,v_old.STAN_PER_ID,v_old.GRUZPOL_ID,v_old.KOL_VAG,v_old.VES,v_old.VIDOTPR_ID,v_old.MRK,v_old.ID_A,v_old.ID,v_old.PLAT_ID,v_old.FOX_KOD,v_old.ISCOR,v_old.DATE_LETTER,v_old.NOM_LETTER,v_old.DATE_VHOD,v_old.NOM_VHOD,v_old.PRINVAG_ID,v_old.OLD_ID,v_old.STATES_ID);

    -- Запись в лог
    IF 1=1 THEN
      SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
      INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
        SELECT LogId,'GU12_B',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D',EMPTY_CLOB()
          FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');

      SELECT WhatWasDone INTO cl_WhatWasDone
        FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG
       WHERE ID = LogId
         FOR UPDATE;

      WritePos:=1;

      WriteStr:='Заявка № ' || (vNOM_Z) || ' от ' || TO_CHAR(vFROM_DATE,'dd.mm.yyyy hh24:mi:ss') ||
	            ' Станция '|| vSTAN_KOD ||' ' || (vSTAN_NAME) || CHR(13);
      dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
      WritePos:=WritePos+LENGTH(WriteStr);
    END IF;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.PDATE := :NEW.PDATE;
    v_new.SOBSTVVAG_ID := :NEW.SOBSTVVAG_ID;
    v_new.STAN_ID := :NEW.STAN_ID;
    v_new.STAN_PER_ID := :NEW.STAN_PER_ID;
    v_new.GRUZPOL_ID := :NEW.GRUZPOL_ID;
    v_new.KOL_VAG := :NEW.KOL_VAG;
    v_new.VES := :NEW.VES;
    v_new.VIDOTPR_ID := :NEW.VIDOTPR_ID;
    v_new.MRK := :NEW.MRK;
    v_new.ID_A := :NEW.ID_A;
    v_new.ID := :NEW.ID;
    v_new.PLAT_ID := :NEW.PLAT_ID;
    v_new.FOX_KOD := :NEW.FOX_KOD;
    v_new.ISCOR := :NEW.ISCOR;
    v_new.DATE_LETTER := :NEW.DATE_LETTER;
    v_new.NOM_LETTER := :NEW.NOM_LETTER;
    v_new.DATE_VHOD := :NEW.DATE_VHOD;
    v_new.NOM_VHOD := :NEW.NOM_VHOD;
    v_new.PRINVAG_ID := :NEW.PRINVAG_ID;
    v_new.OLD_ID := :NEW.OLD_ID;
    v_new.STATES_ID := :NEW.STATES_ID;

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
            SELECT LogId,'GU12_B',TO_CHAR(V_OLD.ID),osuser,terminal,MODULE,'D',EMPTY_CLOB()
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');

          SELECT WhatWasDone INTO cl_WhatWasDone
            FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG
           WHERE ID = LogId
             FOR UPDATE;

          WritePos:=1;

          WriteStr:='Заявка № ' || (vNOM_Z) || ' от ' || TO_CHAR(vFROM_DATE,'dd.mm.yyyy hh24:mi:ss') ||
	                ' Станция '|| vSTAN_KOD ||' ' || (vSTAN_NAME) || CHR(13);
          dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
          WritePos:=WritePos+LENGTH(WriteStr);
        END IF;

        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'GU12_B',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;
      ELSE
        -- PRIMARY KEY не изменился, добавляем в лог 1 запись
        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
            SELECT LogId,'GU12_B',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'U',EMPTY_CLOB()
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');

          SELECT WhatWasDone INTO cl_WhatWasDone
            FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG
            WHERE ID = LogId
            FOR UPDATE;

          WritePos:=1;

          IF V_OLD.PDATE<>V_NEW.PDATE THEN
            WriteStr:=':OLD.PDATE=' || TO_CHAR(V_OLD.PDATE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.PDATE=' || TO_CHAR(V_NEW.PDATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.SOBSTVVAG_ID,0)<>NVL(V_NEW.SOBSTVVAG_ID,0) THEN
            WriteStr:=':OLD.SOBSTVVAG_ID=' || TO_CHAR(V_OLD.SOBSTVVAG_ID) || ' :NEW.SOBSTVVAG_ID=' || TO_CHAR(V_NEW.SOBSTVVAG_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.STAN_ID,0)<>NVL(V_NEW.STAN_ID,0) THEN
            WriteStr:=':OLD.STAN_ID=' || TO_CHAR(V_OLD.STAN_ID) || ' :NEW.STAN_ID=' || TO_CHAR(V_NEW.STAN_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.STAN_PER_ID,0)<>NVL(V_NEW.STAN_PER_ID,0) THEN
            WriteStr:=':OLD.STAN_PER_ID=' || TO_CHAR(V_OLD.STAN_PER_ID) || ' :NEW.STAN_PER_ID=' || TO_CHAR(V_NEW.STAN_PER_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.GRUZPOL_ID,0)<>NVL(V_NEW.GRUZPOL_ID,0) THEN
            WriteStr:=':OLD.GRUZPOL_ID=' || TO_CHAR(V_OLD.GRUZPOL_ID) || ' :NEW.GRUZPOL_ID=' || TO_CHAR(V_NEW.GRUZPOL_ID) || CHR(13);
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
          IF NVL(V_OLD.VIDOTPR_ID,0)<>NVL(V_NEW.VIDOTPR_ID,0) THEN
            WriteStr:=':OLD.VIDOTPR_ID=' || TO_CHAR(V_OLD.VIDOTPR_ID) || ' :NEW.VIDOTPR_ID=' || TO_CHAR(V_NEW.VIDOTPR_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.MRK||' '<>V_NEW.MRK||' ' THEN
            WriteStr:=':OLD.MRK=' || (V_OLD.MRK) || ' :NEW.MRK=' || (V_NEW.MRK) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.ID_A<>V_NEW.ID_A THEN
            WriteStr:=':OLD.ID_A=' || TO_CHAR(V_OLD.ID_A) || ' :NEW.ID_A=' || TO_CHAR(V_NEW.ID_A) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.ID<>V_NEW.ID THEN
            WriteStr:=':OLD.ID=' || TO_CHAR(V_OLD.ID) || ' :NEW.ID=' || TO_CHAR(V_NEW.ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.PLAT_ID,0)<>NVL(V_NEW.PLAT_ID,0) THEN
            WriteStr:=':OLD.PLAT_ID=' || TO_CHAR(V_OLD.PLAT_ID) || ' :NEW.PLAT_ID=' || TO_CHAR(V_NEW.PLAT_ID) || CHR(13);
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
          IF NVL(V_OLD.DATE_LETTER,TO_DATE('01.01.1900','dd.mm.yyyy'))<>NVL(V_NEW.DATE_LETTER,TO_DATE('01.01.1900','dd.mm.yyyy')) THEN
            WriteStr:=':OLD.DATE_LETTER=' || TO_CHAR(V_OLD.DATE_LETTER,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_LETTER=' || TO_CHAR(V_NEW.DATE_LETTER,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NOM_LETTER||' '<>V_NEW.NOM_LETTER||' ' THEN
            WriteStr:=':OLD.NOM_LETTER=' || (V_OLD.NOM_LETTER) || ' :NEW.NOM_LETTER=' || (V_NEW.NOM_LETTER) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.DATE_VHOD,TO_DATE('01.01.1900','dd.mm.yyyy'))<>NVL(V_NEW.DATE_VHOD,TO_DATE('01.01.1900','dd.mm.yyyy')) THEN
            WriteStr:=':OLD.DATE_VHOD=' || TO_CHAR(V_OLD.DATE_VHOD,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_VHOD=' || TO_CHAR(V_NEW.DATE_VHOD,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NOM_VHOD||' '<>V_NEW.NOM_VHOD||' ' THEN
            WriteStr:=':OLD.NOM_VHOD=' || (V_OLD.NOM_VHOD) || ' :NEW.NOM_VHOD=' || (V_NEW.NOM_VHOD) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.PRINVAG_ID,0)<>NVL(V_NEW.PRINVAG_ID,0) THEN
            WriteStr:=':OLD.PRINVAG_ID=' || TO_CHAR(V_OLD.PRINVAG_ID) || ' :NEW.PRINVAG_ID=' || TO_CHAR(V_NEW.PRINVAG_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.OLD_ID<>V_NEW.OLD_ID THEN
            WriteStr:=':OLD.OLD_ID=' || TO_CHAR(V_OLD.OLD_ID) || ' :NEW.OLD_ID=' || TO_CHAR(V_NEW.OLD_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF NVL(V_OLD.STATES_ID,0)<>NVL(V_NEW.STATES_ID,0) THEN
            WriteStr:=':OLD.STATES_ID=' || TO_CHAR(V_OLD.STATES_ID) || ' :NEW.STATES_ID=' || TO_CHAR(V_NEW.STATES_ID) || CHR(13);
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
          SELECT LogId,'GU12_B',TO_CHAR(V_NEW.ID),osuser,terminal,MODULE,'I'
            FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
      END IF;
    END IF;

  END IF;
END;
/


