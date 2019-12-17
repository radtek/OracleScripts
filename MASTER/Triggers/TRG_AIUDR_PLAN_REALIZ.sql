--
-- TRG_AIUDR_PLAN_REALIZ  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_PLAN_REALIZ
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.PLAN_REALIZ
FOR EACH ROW
DECLARE
  v_old PLAN_REALIZ%ROWTYPE;
  v_new PLAN_REALIZ%ROWTYPE;
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
    v_old.SUPPLIER_ID := :OLD.SUPPLIER_ID;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.TIP_REAL_ID := :OLD.TIP_REAL_ID;
    v_old.VID_REAL_ID := :OLD.VID_REAL_ID;
    v_old.ORG_KIND_ID := :OLD.ORG_KIND_ID;
    v_old.ORG_STRU_ID := :OLD.ORG_STRU_ID;
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
    v_new.SUPPLIER_ID := :NEW.SUPPLIER_ID;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.TIP_REAL_ID := :NEW.TIP_REAL_ID;
    v_new.VID_REAL_ID := :NEW.VID_REAL_ID;
    v_new.ORG_KIND_ID := :NEW.ORG_KIND_ID;
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


