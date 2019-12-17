--
-- TRG_BIUDR_LINK_PARUS_PREDPR  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_LINK_PARUS_PREDPR
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.LINK_PARUS_PREDPR
FOR EACH ROW
DECLARE
  v_old LINK_PARUS_PREDPR%ROWTYPE;
  v_new LINK_PARUS_PREDPR%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.RN := :OLD.RN;
    v_old.PREDPR_ID := :OLD.PREDPR_ID;
    v_old.IS_AUTO_LINK := :OLD.IS_AUTO_LINK;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.RN := :NEW.RN;
    v_new.PREDPR_ID := :NEW.PREDPR_ID;
    v_new.IS_AUTO_LINK := :NEW.IS_AUTO_LINK;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_LINK_PARUS_PREDPR.NEXTVAL INTO v_new.ID FROM DUAL;
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
    :NEW.RN := v_new.RN;
    :NEW.PREDPR_ID := v_new.PREDPR_ID;
    :NEW.IS_AUTO_LINK := v_new.IS_AUTO_LINK;
  END IF;
END;
/


