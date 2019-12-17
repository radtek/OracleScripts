--
-- TRG_BIUDR_NOMEN_PROD_LINK  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_NOMEN_PROD_LINK
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.PARUS_NOMEN_PROD_LINK
FOR EACH ROW
DECLARE
  v_old PARUS_NOMEN_PROD_LINK%ROWTYPE;
  v_new PARUS_NOMEN_PROD_LINK%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.NOMEN_RN := :OLD.NOMEN_RN;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.IS_AUTO_LINK := :OLD.IS_AUTO_LINK;
    v_old.IS_MAIN := :OLD.IS_MAIN;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.NOMEN_RN := :NEW.NOMEN_RN;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.IS_AUTO_LINK := :NEW.IS_AUTO_LINK;
    v_new.IS_MAIN := :NEW.IS_MAIN;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_PARUS_NOMEN_PROD_LINK.nextval INTO v_new.ID FROM DUAL;
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
    :NEW.NOMEN_RN := v_new.NOMEN_RN;
    :NEW.PROD_ID_NPR := v_new.PROD_ID_NPR;
    :NEW.IS_AUTO_LINK := v_new.IS_AUTO_LINK;
    :NEW.IS_MAIN := v_new.IS_MAIN;
  END IF;
END;
/


