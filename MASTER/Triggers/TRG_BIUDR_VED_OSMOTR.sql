--
-- TRG_BIUDR_VED_OSMOTR  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_VED_OSMOTR
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.VED_OSMOTR
FOR EACH ROW
DECLARE
  v_old VED_OSMOTR%ROWTYPE;
  v_new VED_OSMOTR%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.VED_NUM := :OLD.VED_NUM;
    v_old.VED_DATE := :OLD.VED_DATE;
    v_old.FROM_DATE := :OLD.FROM_DATE;
    v_old.TO_DATE := :OLD.TO_DATE;
    v_old.FIO1 := :OLD.FIO1;
    v_old.FIO2 := :OLD.FIO2;
    v_old.FIO3 := :OLD.FIO3;
    v_old.SIGN1 := :OLD.SIGN1;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.VED_NUM := :NEW.VED_NUM;
    v_new.VED_DATE := :NEW.VED_DATE;
    v_new.FROM_DATE := :NEW.FROM_DATE;
    v_new.TO_DATE := :NEW.TO_DATE;
    v_new.FIO1 := :NEW.FIO1;
    v_new.FIO2 := :NEW.FIO2;
    v_new.FIO3 := :NEW.FIO3;
    v_new.SIGN1 := :NEW.SIGN1;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_ID.nextval INTO v_new.ID FROM DUAL;
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
    :NEW.VED_NUM := v_new.VED_NUM;
    :NEW.VED_DATE := v_new.VED_DATE;
    :NEW.FROM_DATE := v_new.FROM_DATE;
    :NEW.TO_DATE := v_new.TO_DATE;
    :NEW.FIO1 := v_new.FIO1;
    :NEW.FIO2 := v_new.FIO2;
    :NEW.FIO3 := v_new.FIO3;
    :NEW.SIGN1 := v_new.SIGN1;
  END IF;
END;
/


