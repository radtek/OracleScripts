--
-- TRG_BIUDR_STAN_PREDPR  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_STAN_PREDPR
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.STAN_PREDPR
FOR EACH ROW
DECLARE
  v_old STAN_PREDPR%ROWTYPE;
  v_new STAN_PREDPR%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.PREDPR_ID := :OLD.PREDPR_ID;
    v_old.STAN_ID := :OLD.STAN_ID;
    v_old.VETKA_ID := :OLD.VETKA_ID;
    v_old.PREDPR_GDKOD := :OLD.PREDPR_GDKOD;
    v_old.IS_MAIN := :OLD.IS_MAIN;
    v_old.ID := :OLD.ID;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.PREDPR_ID := :NEW.PREDPR_ID;
    v_new.STAN_ID := :NEW.STAN_ID;
    v_new.VETKA_ID := :NEW.VETKA_ID;
    v_new.PREDPR_GDKOD := :NEW.PREDPR_GDKOD;
    v_new.IS_MAIN := :NEW.IS_MAIN;
    v_new.ID := :NEW.ID;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_STAN_PREDPR.NEXTVAL INTO v_new.ID FROM DUAL;
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
    :NEW.PREDPR_ID := v_new.PREDPR_ID;
    :NEW.STAN_ID := v_new.STAN_ID;
    :NEW.VETKA_ID := v_new.VETKA_ID;
    :NEW.PREDPR_GDKOD := v_new.PREDPR_GDKOD;
    :NEW.IS_MAIN := v_new.IS_MAIN;
    :NEW.ID := v_new.ID;
  END IF;
END;
/


