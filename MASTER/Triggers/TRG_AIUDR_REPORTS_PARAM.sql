--
-- TRG_AIUDR_REPORTS_PARAM  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_REPORTS_PARAM
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.REPORTS_PARAM
FOR EACH ROW
DECLARE
  v_old REPORTS_PARAM%ROWTYPE;
  v_new REPORTS_PARAM%ROWTYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.REPORTS_ID := :OLD.REPORTS_ID;
    v_old.PARAM_NAME := :OLD.PARAM_NAME;
    v_old.PARAM_ORDER := :OLD.PARAM_ORDER;
    v_old.PARAM_VISIBLE := :OLD.PARAM_VISIBLE;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.REPORTS_ID := :NEW.REPORTS_ID;
    v_new.PARAM_NAME := :NEW.PARAM_NAME;
    v_new.PARAM_ORDER := :NEW.PARAM_ORDER;
    v_new.PARAM_VISIBLE := :NEW.PARAM_VISIBLE;

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


