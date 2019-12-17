--
-- TRG_BIUDR_KLS_PREDPR_RS  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_KLS_PREDPR_RS
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.KLS_PREDPR_RS
FOR EACH ROW
DECLARE
  v_old KLS_PREDPR_RS%ROWTYPE;
  v_new KLS_PREDPR_RS%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.PREDPR_ID := :OLD.PREDPR_ID;
    v_old.BANKS_ID := :OLD.BANKS_ID;
    v_old.RS := :OLD.RS;
    v_old.IS_MAIN := :OLD.IS_MAIN;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.PREDPR_ID := :NEW.PREDPR_ID;
    v_new.BANKS_ID := :NEW.BANKS_ID;
    v_new.RS := :NEW.RS;
    v_new.IS_MAIN := :NEW.IS_MAIN;

    IF INSERTING() THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_KLS_PREDPR_RS.NEXTVAL INTO v_new.ID FROM DUAL;
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
    :NEW.PREDPR_ID := v_new.PREDPR_ID;
    :NEW.BANKS_ID := v_new.BANKS_ID;
    :NEW.RS := v_new.RS;
    :NEW.IS_MAIN := v_new.IS_MAIN;
  END IF;
END;
/


