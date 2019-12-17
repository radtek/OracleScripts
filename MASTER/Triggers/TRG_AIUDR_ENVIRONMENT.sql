--
-- TRG_AIUDR_ENVIRONMENT  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_ENVIRONMENT
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.ENVIRONMENT
FOR EACH ROW
DECLARE
  v_old ENVIRONMENT%ROWTYPE;
  v_new ENVIRONMENT%ROWTYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.ENV_NAME := :OLD.ENV_NAME;
    v_old.ENV_VALUE := :OLD.ENV_VALUE;
    v_old.ENV_COMMENT := :OLD.ENV_COMMENT;
    v_old.SOURCESQL := :OLD.SOURCESQL;
    v_old.ENV_TYPES_ID := :OLD.ENV_TYPES_ID;
    v_old.ENV_GRP_ID := :OLD.ENV_GRP_ID;
    v_old.MASTER_ID := :OLD.MASTER_ID;
    v_old.NETUSER := :OLD.NETUSER;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.ENV_NAME := :NEW.ENV_NAME;
    v_new.ENV_VALUE := :NEW.ENV_VALUE;
    v_new.ENV_COMMENT := :NEW.ENV_COMMENT;
    v_new.SOURCESQL := :NEW.SOURCESQL;
    v_new.ENV_TYPES_ID := :NEW.ENV_TYPES_ID;
    v_new.ENV_GRP_ID := :NEW.ENV_GRP_ID;
    v_new.MASTER_ID := :NEW.MASTER_ID;
    v_new.NETUSER := :NEW.NETUSER;

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


