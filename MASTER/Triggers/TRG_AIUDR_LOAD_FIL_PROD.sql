--
-- TRG_AIUDR_LOAD_FIL_PROD  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_LOAD_FIL_PROD
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.LOAD_FIL_PROD
FOR EACH ROW
DECLARE
  v_old LOAD_FIL_PROD%ROWTYPE;
  v_new LOAD_FIL_PROD%ROWTYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.TAG := :OLD.TAG;
    v_old.NAME := :OLD.NAME;
    v_old.IS_AUTO_LINK := :OLD.IS_AUTO_LINK;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.TAG := :NEW.TAG;
    v_new.NAME := :NEW.NAME;
    v_new.IS_AUTO_LINK := :NEW.IS_AUTO_LINK;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;

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


