--
-- TRG_BIUDR_LOAD_FIL_PERIODS  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_LOAD_FIL_PERIODS
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.LOAD_FIL_PERIODS
FOR EACH ROW
DECLARE
  v_old LOAD_FIL_PERIODS%ROWTYPE;
  v_new LOAD_FIL_PERIODS%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.FILIAL_ID := :OLD.FILIAL_ID;
    v_old.DATE_REPORT := :OLD.DATE_REPORT;
    v_old.FILENAME := :OLD.FILENAME;
    v_old.DATE_LOAD := :OLD.DATE_LOAD;
    v_old.USER_LOAD := :OLD.USER_LOAD;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.FILIAL_ID := :NEW.FILIAL_ID;
    v_new.DATE_REPORT := :NEW.DATE_REPORT;
    v_new.FILENAME := :NEW.FILENAME;
    v_new.DATE_LOAD := :NEW.DATE_LOAD;
    v_new.USER_LOAD := :NEW.USER_LOAD;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_LOAD_FIL_PERIODS.NEXTVAL INTO v_new.ID FROM DUAL;
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
    :NEW.DATE_REPORT := v_new.DATE_REPORT;
    :NEW.FILENAME := v_new.FILENAME;
    :NEW.DATE_LOAD := v_new.DATE_LOAD;
    :NEW.USER_LOAD := v_new.USER_LOAD;
  END IF;
END;
/


