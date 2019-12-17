--
-- TRG_BIUDR_LOAD_FIL_REALIZ  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_LOAD_FIL_REALIZ
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.LOAD_FIL_REALIZ
FOR EACH ROW
DECLARE
  v_old LOAD_FIL_REALIZ%ROWTYPE;
  v_new LOAD_FIL_REALIZ%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.FILIAL_ID := :OLD.FILIAL_ID;
    v_old.FIL_PERIOD_ID := :OLD.FIL_PERIOD_ID;
    v_old.FIL_ORG_ID := :OLD.FIL_ORG_ID;
    v_old.FIL_PROD_ID := :OLD.FIL_PROD_ID;
    v_old.FACT := :OLD.FACT;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.FILIAL_ID := :NEW.FILIAL_ID;
    v_new.FIL_PERIOD_ID := :NEW.FIL_PERIOD_ID;
    v_new.FIL_ORG_ID := :NEW.FIL_ORG_ID;
    v_new.FIL_PROD_ID := :NEW.FIL_PROD_ID;
    v_new.FACT := :NEW.FACT;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_LOAD_FIL_REALIZ.NEXTVAL INTO v_new.ID FROM DUAL;
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
    :NEW.FILIAL_ID := v_new.FILIAL_ID;
    :NEW.FIL_PERIOD_ID := v_new.FIL_PERIOD_ID;
    :NEW.FIL_ORG_ID := v_new.FIL_ORG_ID;
    :NEW.FIL_PROD_ID := v_new.FIL_PROD_ID;
    :NEW.FACT := v_new.FACT;
  END IF;
END;
/


