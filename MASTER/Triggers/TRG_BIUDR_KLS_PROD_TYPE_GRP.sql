--
-- TRG_BIUDR_KLS_PROD_TYPE_GRP  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_KLS_PROD_TYPE_GRP
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.KLS_PROD_TYPE_GRP
FOR EACH ROW
DECLARE
  v_old KLS_PROD_TYPE_GRP%ROWTYPE;
  v_new KLS_PROD_TYPE_GRP%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.NAME := :OLD.NAME;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.NAME := :NEW.NAME;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_KLS_PROD_TYPE_GRP.NEXTVAL INTO v_new.ID FROM DUAL;
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
    :NEW.NAME := v_new.NAME;
  END IF;
END;
/


