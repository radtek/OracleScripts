--
-- TRG_BIUDR_REPL_SESSION_LOG  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_REPL_SESSION_LOG
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.REPL_SESSION_LOG
FOR EACH ROW
DECLARE
  v_old REPL_SESSION_LOG%ROWTYPE;
  v_new REPL_SESSION_LOG%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.SESSION_ID := :OLD.SESSION_ID;
    v_old.STATUS := :OLD.STATUS;
    v_old.DESCRIPT := :OLD.DESCRIPT;
    v_old.LOG_TIME := :OLD.LOG_TIME;
    v_old.SITE_RN := :OLD.SITE_RN;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.SESSION_ID := :NEW.SESSION_ID;
    v_new.STATUS := :NEW.STATUS;
    v_new.DESCRIPT := :NEW.DESCRIPT;
    v_new.LOG_TIME := :NEW.LOG_TIME;
    v_NEW.SITE_RN:=NVL(:NEW.SITE_RN,0);

    -- Уникальный ID
    IF v_new.ID=0 OR v_new.ID IS NULL THEN
      v_new.ID:=GET_SEQ_LOCAL();
    END IF;

    -- Сохранение новых значений
    :NEW.ID := v_new.ID;
    :NEW.SESSION_ID := v_new.SESSION_ID;
    :NEW.STATUS := v_new.STATUS;
    :NEW.DESCRIPT := v_new.DESCRIPT;
    :NEW.LOG_TIME := v_new.LOG_TIME;
    :NEW.SITE_RN := v_new.SITE_RN;
  END IF;
END;
/


