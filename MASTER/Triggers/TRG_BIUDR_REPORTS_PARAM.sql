--
-- TRG_BIUDR_REPORTS_PARAM  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_REPORTS_PARAM
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.REPORTS_PARAM
FOR EACH ROW
DECLARE
  v_old REPORTS_PARAM%ROWTYPE;
  v_new REPORTS_PARAM%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.REPORTS_ID := :OLD.REPORTS_ID;
    v_old.PARAM_NAME := :OLD.PARAM_NAME;
    v_old.PARAM_ORDER := :OLD.PARAM_ORDER;
    v_old.PARAM_VISIBLE := :OLD.PARAM_VISIBLE;
  END IF;

  -- До удаления
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

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_REPORTS_PARAM.NEXTVAL INTO v_new.ID FROM DUAL;
      END IF;
      -- Проверка новых значений
      NULL;
    END IF;

    IF UPDATING() THEN
      NULL;
      -- Проверка на изменение PRIMARY KEY
      IF v_old.ID<>v_new.ID THEN
        RAISE_APPLICATION_ERROR(For_Scripts.SG$PK_CHANGE, For_Scripts.SG$PK_CHANGE_TXT);
      END IF;

    END IF;

    -- До обновления
    IF UPDATING() THEN
      NULL;
    END IF;

    -- До добавления
    IF INSERTING() THEN
      NULL;
    END IF;

    -- Сохранение новых значений
    :NEW.ID := v_new.ID;
    :NEW.REPORTS_ID := v_new.REPORTS_ID;
    :NEW.PARAM_NAME := v_new.PARAM_NAME;
    :NEW.PARAM_ORDER := v_new.PARAM_ORDER;
    :NEW.PARAM_VISIBLE := v_new.PARAM_VISIBLE;
  END IF;
END;
/


