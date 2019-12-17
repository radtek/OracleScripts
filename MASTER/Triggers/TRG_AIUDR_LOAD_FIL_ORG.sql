--
-- TRG_AIUDR_LOAD_FIL_ORG  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_LOAD_FIL_ORG
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.LOAD_FIL_ORG
FOR EACH ROW
DECLARE
  v_old LOAD_FIL_ORG%ROWTYPE;
  v_new LOAD_FIL_ORG%ROWTYPE;
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
    v_old.ORG_KIND_ID := :OLD.ORG_KIND_ID;
    v_old.IS_AUTO_LINK := :OLD.IS_AUTO_LINK;
    v_old.ORG_STRU_ID := :OLD.ORG_STRU_ID;
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
    v_new.ORG_KIND_ID := :NEW.ORG_KIND_ID;
    v_new.IS_AUTO_LINK := :NEW.IS_AUTO_LINK;
    v_new.ORG_STRU_ID := :NEW.ORG_STRU_ID;

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


