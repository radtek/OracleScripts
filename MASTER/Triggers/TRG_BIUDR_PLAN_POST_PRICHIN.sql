--
-- TRG_BIUDR_PLAN_POST_PRICHIN  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_PLAN_POST_PRICHIN
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.PLAN_POST_PRICHIN
FOR EACH ROW
DECLARE
  v_old PLAN_POST_PRICHIN%ROWTYPE;
  v_new PLAN_POST_PRICHIN%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.BEG_DATE := :OLD.BEG_DATE;
    v_old.END_DATE := :OLD.END_DATE;
    v_old.TO_MOS := :OLD.TO_MOS;
    v_old.ORDNUNG := :OLD.ORDNUNG;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.PLANSTRU_ID := :OLD.PLANSTRU_ID;
    v_old.OWNER_ID := :OLD.OWNER_ID;
    v_old.PLAN := :OLD.PLAN;
    v_old.IZM_PLAN := :OLD.IZM_PLAN;
    v_old.OBPR := :OLD.OBPR;
    v_old.NORMA := :OLD.NORMA;
    v_old.NORMA_OBPR := :OLD.NORMA_OBPR;
    v_old.FACT := :OLD.FACT;
    v_old.RAZN_TONN := :OLD.RAZN_TONN;
    v_old.RAZN_DAT := :OLD.RAZN_DAT;
    v_old.ZAYV_TONN := :OLD.ZAYV_TONN;
    v_old.ZAYV_DAT := :OLD.ZAYV_DAT;
    v_old.PRICHIN_ID := :OLD.PRICHIN_ID;
    v_old.NOTE := :OLD.NOTE;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.BEG_DATE := :NEW.BEG_DATE;
    v_new.END_DATE := :NEW.END_DATE;
    v_new.TO_MOS := :NEW.TO_MOS;
    v_new.ORDNUNG := :NEW.ORDNUNG;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.PLANSTRU_ID := :NEW.PLANSTRU_ID;
    v_new.OWNER_ID := :NEW.OWNER_ID;
    v_new.PLAN := :NEW.PLAN;
    v_new.IZM_PLAN := :NEW.IZM_PLAN;
    v_new.OBPR := :NEW.OBPR;
    v_new.NORMA := :NEW.NORMA;
    v_new.NORMA_OBPR := :NEW.NORMA_OBPR;
    v_new.FACT := :NEW.FACT;
    v_new.RAZN_TONN := :NEW.RAZN_TONN;
    v_new.RAZN_DAT := :NEW.RAZN_DAT;
    v_new.ZAYV_TONN := :NEW.ZAYV_TONN;
    v_new.ZAYV_DAT := :NEW.ZAYV_DAT;
    v_new.PRICHIN_ID := :NEW.PRICHIN_ID;
    v_new.NOTE := :NEW.NOTE;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_PLAN_POST_PRICHIN.nextval INTO v_new.ID FROM DUAL;
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
    :NEW.BEG_DATE := v_new.BEG_DATE;
    :NEW.END_DATE := v_new.END_DATE;
    :NEW.TO_MOS := v_new.TO_MOS;
    :NEW.ORDNUNG := v_new.ORDNUNG;
    :NEW.PROD_ID_NPR := v_new.PROD_ID_NPR;
    :NEW.PLANSTRU_ID := v_new.PLANSTRU_ID;
    :NEW.OWNER_ID := v_new.OWNER_ID;
    :NEW.PLAN := v_new.PLAN;
    :NEW.IZM_PLAN := v_new.IZM_PLAN;
    :NEW.OBPR := v_new.OBPR;
    :NEW.NORMA := v_new.NORMA;
    :NEW.NORMA_OBPR := v_new.NORMA_OBPR;
    :NEW.FACT := v_new.FACT;
    :NEW.RAZN_TONN := v_new.RAZN_TONN;
    :NEW.RAZN_DAT := v_new.RAZN_DAT;
    :NEW.ZAYV_TONN := v_new.ZAYV_TONN;
    :NEW.ZAYV_DAT := v_new.ZAYV_DAT;
    :NEW.PRICHIN_ID := v_new.PRICHIN_ID;
    :NEW.NOTE := v_new.NOTE;
  END IF;
END;
/


