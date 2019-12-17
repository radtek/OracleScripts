--
-- TRG_BIUDR_PLAN_REALIZ  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_PLAN_REALIZ
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.PLAN_REALIZ
FOR EACH ROW
DECLARE
  v_old PLAN_REALIZ%ROWTYPE;
  v_new PLAN_REALIZ%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.DATE_PLAN := :OLD.DATE_PLAN;
    v_old.VES := :OLD.VES;
    v_old.SUPPLIER_ID := :OLD.SUPPLIER_ID;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.TIP_REAL_ID := :OLD.TIP_REAL_ID;
    v_old.VID_REAL_ID := :OLD.VID_REAL_ID;
    v_old.ORG_KIND_ID := :OLD.ORG_KIND_ID;
    v_old.ORG_STRU_ID := :OLD.ORG_STRU_ID;
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
    v_new.SUPPLIER_ID := :NEW.SUPPLIER_ID;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.TIP_REAL_ID := :NEW.TIP_REAL_ID;
    v_new.VID_REAL_ID := :NEW.VID_REAL_ID;
    v_new.ORG_KIND_ID := :NEW.ORG_KIND_ID;
    v_new.ORG_STRU_ID := :NEW.ORG_STRU_ID;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_PLAN_REALIZ.NEXTVAL INTO v_new.ID FROM DUAL;
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
    :NEW.SUPPLIER_ID := v_new.SUPPLIER_ID;
    :NEW.PROD_ID_NPR := v_new.PROD_ID_NPR;
    :NEW.TIP_REAL_ID := v_new.TIP_REAL_ID;
    :NEW.VID_REAL_ID := v_new.VID_REAL_ID;
    :NEW.ORG_KIND_ID := v_new.ORG_KIND_ID;
    :NEW.ORG_STRU_ID := v_new.ORG_STRU_ID;
  END IF;
END;
/


