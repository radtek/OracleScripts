--
-- TRG_BIUDR_PLAN_POST_SVOD  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_PLAN_POST_SVOD
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.PLAN_POST_SVOD
FOR EACH ROW
DECLARE
  v_old PLAN_POST_SVOD%ROWTYPE;
  v_new PLAN_POST_SVOD%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.DATE_PLAN := :OLD.DATE_PLAN;
    v_old.VES := :OLD.VES;
    v_old.HRAN := :OLD.HRAN;
    v_old.SUPPLIER_ID := :OLD.SUPPLIER_ID;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.DATE_PLAN := TRUNC(:NEW.DATE_PLAN);
    v_new.VES := :NEW.VES;
    v_new.HRAN := :NEW.HRAN;
    v_new.SUPPLIER_ID := :NEW.SUPPLIER_ID;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_PLAN_POST_SVOD.NEXTVAL INTO v_new.ID FROM DUAL;
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
    :NEW.DATE_PLAN := v_new.DATE_PLAN;
    :NEW.VES := v_new.VES;
    :NEW.HRAN := v_new.HRAN;
    :NEW.SUPPLIER_ID := v_new.SUPPLIER_ID;
    :NEW.PROD_ID_NPR := v_new.PROD_ID_NPR;
  END IF;
END;
/


