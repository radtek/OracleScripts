--
-- TRG_AIUDR_R3_CAT_CEN  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_R3_CAT_CEN
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.R3_CAT_CEN
FOR EACH ROW
DECLARE
  v_old R3_CAT_CEN%ROWTYPE;
  v_new R3_CAT_CEN%ROWTYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.NUM_ISP := :OLD.NUM_ISP;
    v_old.CUSTOMERS_ID := :OLD.CUSTOMERS_ID;
    v_old.NAME := :OLD.NAME;
    v_old.CAT_CEN_ID := :OLD.CAT_CEN_ID;
    v_old.IS_AUTO_LINK := :OLD.IS_AUTO_LINK;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.NUM_ISP := :NEW.NUM_ISP;
    v_new.CUSTOMERS_ID := :NEW.CUSTOMERS_ID;
    v_new.NAME := :NEW.NAME;
    v_new.CAT_CEN_ID := :NEW.CAT_CEN_ID;
    v_new.IS_AUTO_LINK := :NEW.IS_AUTO_LINK;

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


