--
-- TRG_BIUDR_STORE_ORG_STRU_LINK  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_STORE_ORG_STRU_LINK
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.PARUS_STORE_ORG_STRU_LINK
FOR EACH ROW
DECLARE
  v_old PARUS_STORE_ORG_STRU_LINK%ROWTYPE;
  v_new PARUS_STORE_ORG_STRU_LINK%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.STORE_RN := :OLD.STORE_RN;
    v_old.ORG_STRU_ID := :OLD.ORG_STRU_ID;
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
    v_new.STORE_RN := :NEW.STORE_RN;
    v_new.ORG_STRU_ID := :NEW.ORG_STRU_ID;
    v_new.IS_AUTO_LINK := :NEW.IS_AUTO_LINK;
    v_new.IS_MAIN := :NEW.IS_MAIN;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_PARUS_STORE_ORG_STRU_LINK.nextval INTO v_new.ID FROM DUAL;
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
    :NEW.STORE_RN := v_new.STORE_RN;
    :NEW.ORG_STRU_ID := v_new.ORG_STRU_ID;
    :NEW.IS_AUTO_LINK := v_new.IS_AUTO_LINK;
    :NEW.IS_MAIN := v_new.IS_MAIN;
  END IF;
END;
/


