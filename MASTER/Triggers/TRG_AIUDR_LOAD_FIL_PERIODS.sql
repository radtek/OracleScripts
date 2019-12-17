--
-- TRG_AIUDR_LOAD_FIL_PERIODS  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_LOAD_FIL_PERIODS
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.LOAD_FIL_PERIODS
FOR EACH ROW
DECLARE
  v_old LOAD_FIL_PERIODS%ROWTYPE;
  v_new LOAD_FIL_PERIODS%ROWTYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.FILIAL_ID := :OLD.FILIAL_ID;
    v_old.DATE_REPORT := :OLD.DATE_REPORT;
    v_old.FILENAME := :OLD.FILENAME;
    v_old.DATE_LOAD := :OLD.DATE_LOAD;
    v_old.USER_LOAD := :OLD.USER_LOAD;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.FILIAL_ID := :NEW.FILIAL_ID;
    v_new.DATE_REPORT := :NEW.DATE_REPORT;
    v_new.FILENAME := :NEW.FILENAME;
    v_new.DATE_LOAD := :NEW.DATE_LOAD;
    v_new.USER_LOAD := :NEW.USER_LOAD;

    -- После обновления
    IF UPDATING() THEN
      NULL;
    END IF;

    -- После добавления
    IF INSERTING() THEN
      NULL;
    END IF;

  END IF;
END;
/


