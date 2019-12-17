--
-- TRG_BIUDR_R3_CAT_CEN  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_R3_CAT_CEN
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.R3_CAT_CEN
FOR EACH ROW
DECLARE
  v_old R3_CAT_CEN%ROWTYPE;
  v_new R3_CAT_CEN%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.NUM_ISP := :OLD.NUM_ISP;
    v_old.CUSTOMERS_ID := :OLD.CUSTOMERS_ID;
    v_old.NAME := :OLD.NAME;
    v_old.CAT_CEN_ID := :OLD.CAT_CEN_ID;
    v_old.IS_AUTO_LINK := :OLD.IS_AUTO_LINK;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.NUM_ISP := :NEW.NUM_ISP;
    v_new.CUSTOMERS_ID := :NEW.CUSTOMERS_ID;
    v_new.NAME := :NEW.NAME;
    v_new.CAT_CEN_ID := :NEW.CAT_CEN_ID;
    v_new.IS_AUTO_LINK := :NEW.IS_AUTO_LINK;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_R3_CAT_CEN.NEXTVAL INTO v_new.ID FROM DUAL;
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
    :NEW.NUM_ISP := v_new.NUM_ISP;
    :NEW.CUSTOMERS_ID := v_new.CUSTOMERS_ID;
    :NEW.NAME := v_new.NAME;
    :NEW.CAT_CEN_ID := v_new.CAT_CEN_ID;
    :NEW.IS_AUTO_LINK := v_new.IS_AUTO_LINK;
  END IF;
END;
/


