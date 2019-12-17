--
-- TRG_AIUDR_KLS_VOZN_RST  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_KLS_VOZN_RST
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.KLS_VOZN_RST
FOR EACH ROW
DECLARE
  v_old KLS_VOZN_RST%ROWTYPE;
  v_new KLS_VOZN_RST%ROWTYPE;
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
    v_old.BEGIN_DATE := :OLD.BEGIN_DATE;
    v_old.END_DATE := :OLD.END_DATE;
    v_old.ID_GROUP_NPR := :OLD.ID_GROUP_NPR;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.VAGOWN_TYP_ID := :OLD.VAGOWN_TYP_ID;
    v_old.RAST_MIN := :OLD.RAST_MIN;
    v_old.RAST_MAX := :OLD.RAST_MAX;
    v_old.CENA_VOZN := :OLD.CENA_VOZN;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.IS_AGENT := :NEW.IS_AGENT;
    v_new.BEGIN_DATE := :NEW.BEGIN_DATE;
    v_new.END_DATE := :NEW.END_DATE;
    v_new.ID_GROUP_NPR := :NEW.ID_GROUP_NPR;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.VAGOWN_TYP_ID := :NEW.VAGOWN_TYP_ID;
    v_new.RAST_MIN := :NEW.RAST_MIN;
    v_new.RAST_MAX := :NEW.RAST_MAX;
    v_new.CENA_VOZN := :NEW.CENA_VOZN;

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


