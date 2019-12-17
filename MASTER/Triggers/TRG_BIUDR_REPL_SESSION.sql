--
-- TRG_BIUDR_REPL_SESSION  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_REPL_SESSION
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.REPL_SESSION FOR EACH ROW
DECLARE
  v_old REPL_SESSION%ROWTYPE;
  v_new REPL_SESSION%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.STATUS := :OLD.STATUS;
    v_old.DATE_START := :OLD.DATE_START;
    v_old.DATE_FINISH := :OLD.DATE_FINISH;
    v_old.DESCRIPT := :OLD.DESCRIPT;
    v_old.OSUSER_NAME := :OLD.OSUSER_NAME;
    v_old.TERMINAL_NAME := :OLD.TERMINAL_NAME;
    v_old.APPL_NAME := :OLD.APPL_NAME;
    v_old.SESSIONID:=:OLD.SESSIONID;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.STATUS := :NEW.STATUS;
    v_new.DATE_START := :NEW.DATE_START;
    v_new.DATE_FINISH := :NEW.DATE_FINISH;
    v_new.DESCRIPT := :NEW.DESCRIPT;
    v_new.OSUSER_NAME := :NEW.OSUSER_NAME;
    v_new.TERMINAL_NAME := :NEW.TERMINAL_NAME;
    v_new.APPL_NAME := :NEW.APPL_NAME;
    v_new.SESSIONID:=:NEW.SESSIONID;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        v_new.ID:=GET_SEQ_LOCAL();
      END IF;
      -- Проверка новых значений
      NULL;
    END IF;

    IF UPDATING() THEN
      NULL;
    END IF;

    -- До обновления
    IF UPDATING() THEN
      NULL;
    END IF;

    -- До добавления
    IF INSERTING() THEN
  	  V_NEW.TERMINAL_NAME:=For_Init.GetCurrTerm;
	  V_NEW.OSUSER_NAME:=For_Init.GetCurrUser;
      V_NEW.SESSIONID:=For_Init.GetCurrSessionId;
    END IF;

    -- Сохранение новых значений
    :NEW.ID := v_new.ID;
    :NEW.STATUS := v_new.STATUS;
    :NEW.DATE_START := v_new.DATE_START;
    :NEW.DATE_FINISH := v_new.DATE_FINISH;
    :NEW.DESCRIPT := v_new.DESCRIPT;
    :NEW.OSUSER_NAME := v_new.OSUSER_NAME;
    :NEW.TERMINAL_NAME := v_new.TERMINAL_NAME;
    :NEW.APPL_NAME := v_new.APPL_NAME;
    :NEW.SESSIONID:=v_new.SESSIONID;
  END IF;
END;
/


