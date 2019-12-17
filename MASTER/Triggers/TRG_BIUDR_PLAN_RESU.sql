--
-- TRG_BIUDR_PLAN_RESU  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_PLAN_RESU
BEFORE INSERT OR DELETE OR UPDATE OF ID, PLAN_ID, PLAN_UTMSK, OSTAT_UTMSK, PROD_ID_NPR, PLAN_PER_ID, SOBSTV_ID, REFINER_ID, HRAN_UTMSK
ON MASTER.PLAN_RESU
FOR EACH ROW
DECLARE
  v_old PLAN_RESU%ROWTYPE;
  v_new PLAN_RESU%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.PLAN_UTMSK := :OLD.PLAN_UTMSK;
    v_old.HRAN_UTMSK := :OLD.HRAN_UTMSK;
    v_old.OSTAT_UTMSK := :OLD.OSTAT_UTMSK;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.PLAN_ID := :OLD.PLAN_ID;
    v_old.PLAN_PER_ID := :OLD.PLAN_PER_ID;
    v_old.SOBSTV_ID := :OLD.SOBSTV_ID;
    v_old.REFINER_ID := :OLD.REFINER_ID;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.PLAN_UTMSK := :NEW.PLAN_UTMSK;
    v_new.HRAN_UTMSK := :NEW.HRAN_UTMSK;
    v_new.OSTAT_UTMSK := :NEW.OSTAT_UTMSK;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.PLAN_ID := :NEW.PLAN_ID;
    v_new.PLAN_PER_ID := :NEW.PLAN_PER_ID;
    v_new.SOBSTV_ID := :NEW.SOBSTV_ID;
    v_new.REFINER_ID := :NEW.REFINER_ID;

    -- Уникальный ID
    IF v_new.ID=0 OR v_new.ID IS NULL THEN
      SELECT SEQ_PLAN_RESU.NEXTVAL INTO v_new.ID FROM DUAL;
    END IF;

    -- Проверка новых значений

    -- До обновления
    IF UPDATING() THEN
      NULL;
      IF v_old.ID<>v_new.ID THEN
        RAISE_APPLICATION_ERROR(FOR_SCRIPTS.SG$PK_CHANGE, 'Нельзя менять PRIMARY KEY');
      END IF;
      IF v_old.PLAN_ID<>v_new.PLAN_ID THEN
        RAISE_APPLICATION_ERROR(FOR_SCRIPTS.SG$FK_CHANGE, 'Нельзя менять план. Удалите запись и введите заново!');
      END IF;
      IF v_old.PLAN_PER_ID<>v_new.PLAN_PER_ID THEN
        RAISE_APPLICATION_ERROR(FOR_SCRIPTS.SG$FK_CHANGE, 'Нельзя менять плановый период. Удалите запись и введите заново!');
      END IF;
    END IF;

    -- До добавления
    IF INSERTING() THEN
      NULL;
    END IF;

    -- Сохранение новых значений
    :NEW.ID := v_new.ID;
    :NEW.PLAN_UTMSK := v_new.PLAN_UTMSK;
    :NEW.HRAN_UTMSK := v_new.HRAN_UTMSK;
    :NEW.OSTAT_UTMSK := v_new.OSTAT_UTMSK;
    :NEW.PROD_ID_NPR := v_new.PROD_ID_NPR;
    :NEW.PLAN_ID := v_new.PLAN_ID;
    :NEW.PLAN_PER_ID := v_new.PLAN_PER_ID;
    :NEW.SOBSTV_ID := v_new.SOBSTV_ID;
    :NEW.REFINER_ID := v_new.REFINER_ID;
  END IF;
END;
/


