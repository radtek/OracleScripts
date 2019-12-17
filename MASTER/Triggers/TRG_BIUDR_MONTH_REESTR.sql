--
-- TRG_BIUDR_MONTH_REESTR  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_MONTH_REESTR
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.MONTH_REESTR
FOR EACH ROW
DECLARE
  v_old MONTH_REESTR%ROWTYPE;
  v_new MONTH_REESTR%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.NUM_REE := :OLD.NUM_REE;
    v_old.DATE_REE := :OLD.DATE_REE;
    v_old.DATE_TO := :OLD.DATE_TO;
    v_old.DATE_PLAN := :OLD.DATE_PLAN;
    v_old.USE_GRAFIK := :OLD.USE_GRAFIK;
    v_old.GRAFIK_DATE_FROM := :OLD.GRAFIK_DATE_FROM;
    v_old.GRAFIK_DATE_TO := :OLD.GRAFIK_DATE_TO;
    v_old.STATUS := :OLD.STATUS;
    v_old.DOP_REE := :OLD.DOP_REE;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.NUM_REE := :NEW.NUM_REE;
    v_new.DATE_REE := :NEW.DATE_REE;
    v_new.DATE_TO := :NEW.DATE_TO;
    v_new.DATE_PLAN := :NEW.DATE_PLAN;
    v_new.USE_GRAFIK := :NEW.USE_GRAFIK;
    v_new.GRAFIK_DATE_FROM := :NEW.GRAFIK_DATE_FROM;
    v_new.GRAFIK_DATE_TO := :NEW.GRAFIK_DATE_TO;
    v_new.STATUS := :NEW.STATUS;
    v_new.DOP_REE := :NEW.DOP_REE;

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
    :NEW.NUM_REE := v_new.NUM_REE;
    :NEW.DATE_REE := v_new.DATE_REE;
    :NEW.DATE_TO := v_new.DATE_TO;
    :NEW.DATE_PLAN := v_new.DATE_PLAN;
    :NEW.USE_GRAFIK := v_new.USE_GRAFIK;
    :NEW.GRAFIK_DATE_FROM := v_new.GRAFIK_DATE_FROM;
    :NEW.GRAFIK_DATE_TO := v_new.GRAFIK_DATE_TO;
    :NEW.STATUS := v_new.STATUS;
    :NEW.DOP_REE := v_new.DOP_REE;
  END IF;
END;
/


