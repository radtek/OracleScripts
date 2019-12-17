--
-- TRG_BIUDR_LOAD_FIL_PROD  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_LOAD_FIL_PROD
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.LOAD_FIL_PROD
FOR EACH ROW
DECLARE
  v_old LOAD_FIL_PROD%ROWTYPE;
  v_new LOAD_FIL_PROD%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.TAG := :OLD.TAG;
    v_old.NAME := :OLD.NAME;
    v_old.IS_AUTO_LINK := :OLD.IS_AUTO_LINK;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.TAG := :NEW.TAG;
    v_new.NAME := :NEW.NAME;
    v_new.IS_AUTO_LINK := :NEW.IS_AUTO_LINK;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_LOAD_FIL_PROD.NEXTVAL INTO v_new.ID FROM DUAL;
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
      NULL;
    END IF;

    -- Сохранение новых значений
    :NEW.ID := v_new.ID;
    :NEW.TAG := v_new.TAG;
    :NEW.NAME := v_new.NAME;
    :NEW.IS_AUTO_LINK := v_new.IS_AUTO_LINK;
    :NEW.PROD_ID_NPR := v_new.PROD_ID_NPR;
  END IF;
END;
/


