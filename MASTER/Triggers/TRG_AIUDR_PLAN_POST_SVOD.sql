--
-- TRG_AIUDR_PLAN_POST_SVOD  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_PLAN_POST_SVOD
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.PLAN_POST_SVOD
FOR EACH ROW
DECLARE
  v_old PLAN_POST_SVOD%ROWTYPE;
  v_new PLAN_POST_SVOD%ROWTYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.DATE_PLAN := :OLD.DATE_PLAN;
    v_old.VES := :OLD.VES;
    v_old.HRAN := :OLD.HRAN;
    v_old.SUPPLIER_ID := :OLD.SUPPLIER_ID;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.DATE_PLAN := :NEW.DATE_PLAN;
    v_new.VES := :NEW.VES;
    v_new.HRAN := :NEW.HRAN;
    v_new.SUPPLIER_ID := :NEW.SUPPLIER_ID;
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


