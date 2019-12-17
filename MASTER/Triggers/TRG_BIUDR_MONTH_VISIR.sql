--
-- TRG_BIUDR_MONTH_VISIR  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_MONTH_VISIR
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.MONTH_VISIR
FOR EACH ROW
DECLARE
  v_old MONTH_VISIR%ROWTYPE;
  v_new MONTH_VISIR%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.DATE_REE := :OLD.DATE_REE;
    v_old.DOP_REE := :OLD.DOP_REE;
    v_old.NOM_ZD := :OLD.NOM_ZD;
    v_old.PRICHIN := :OLD.PRICHIN;
    v_old.APP_USERS_ID := :OLD.APP_USERS_ID;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.DATE_REE := :NEW.DATE_REE;
    v_new.DOP_REE := :NEW.DOP_REE;
    v_new.NOM_ZD := :NEW.NOM_ZD;
    v_new.PRICHIN := :NEW.PRICHIN;
    v_new.APP_USERS_ID := :NEW.APP_USERS_ID;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_MONTH_VISIR.NEXTVAL INTO v_new.ID FROM DUAL;
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
    :NEW.DATE_REE := v_new.DATE_REE;
    :NEW.DOP_REE := v_new.DOP_REE;
    :NEW.NOM_ZD := v_new.NOM_ZD;
    :NEW.PRICHIN := v_new.PRICHIN;
    :NEW.APP_USERS_ID := v_new.APP_USERS_ID;
  END IF;
END;
/


