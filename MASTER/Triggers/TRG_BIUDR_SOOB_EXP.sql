--
-- TRG_BIUDR_SOOB_EXP  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_SOOB_EXP
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.SOOB_EXP
FOR EACH ROW
DECLARE
  v_old SOOB_EXP%ROWTYPE;
  v_new SOOB_EXP%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.REP_DATE := :OLD.REP_DATE;
    v_old.POS_ID := :OLD.POS_ID;
    v_old.SORTBY := :OLD.SORTBY;
    v_old.DOG_ID := :OLD.DOG_ID;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.STAN_ID := :OLD.STAN_ID;
    v_old.EXPED_ID := :OLD.EXPED_ID;
    v_old.LOAD_TYPE_ID := :OLD.LOAD_TYPE_ID;
    v_old.FACT_YEAR := :OLD.FACT_YEAR;
    v_old.PLAN_POST := :OLD.PLAN_POST;
    v_old.PLAN_IZM := :OLD.PLAN_IZM;
    v_old.OBPR := :OLD.OBPR;
    v_old.PLAN_GD := :OLD.PLAN_GD;
    v_old.NORMA_MON := :OLD.NORMA_MON;
    v_old.FACT_MON := :OLD.FACT_MON;
    v_old.FACT_SUT := :OLD.FACT_SUT;
    v_old.IS_BAD := :OLD.IS_BAD;
    v_old.PRICH := :OLD.PRICH;
    v_old.ZAPR_MPS := :OLD.ZAPR_MPS;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.REP_DATE := :NEW.REP_DATE;
    v_new.POS_ID := :NEW.POS_ID;
    v_new.SORTBY := :NEW.SORTBY;
    v_new.DOG_ID := :NEW.DOG_ID;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.STAN_ID := :NEW.STAN_ID;
    v_new.EXPED_ID := :NEW.EXPED_ID;
    v_new.LOAD_TYPE_ID := :NEW.LOAD_TYPE_ID;
    v_new.FACT_YEAR := :NEW.FACT_YEAR;
    v_new.PLAN_POST := :NEW.PLAN_POST;
    v_new.PLAN_IZM := :NEW.PLAN_IZM;
    v_new.OBPR := :NEW.OBPR;
    v_new.PLAN_GD := :NEW.PLAN_GD;
    v_new.NORMA_MON := :NEW.NORMA_MON;
    v_new.FACT_MON := :NEW.FACT_MON;
    v_new.FACT_SUT := :NEW.FACT_SUT;
    v_new.IS_BAD := :NEW.IS_BAD;
    v_new.PRICH := :NEW.PRICH;
    v_new.ZAPR_MPS := :NEW.ZAPR_MPS;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_SOOB_EXP.nextval INTO v_new.ID FROM DUAL;
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
    :NEW.REP_DATE := v_new.REP_DATE;
    :NEW.POS_ID := v_new.POS_ID;
    :NEW.SORTBY := v_new.SORTBY;
    :NEW.DOG_ID := v_new.DOG_ID;
    :NEW.PROD_ID_NPR := v_new.PROD_ID_NPR;
    :NEW.STAN_ID := v_new.STAN_ID;
    :NEW.EXPED_ID := v_new.EXPED_ID;
    :NEW.LOAD_TYPE_ID := v_new.LOAD_TYPE_ID;
    :NEW.FACT_YEAR := v_new.FACT_YEAR;
    :NEW.PLAN_POST := v_new.PLAN_POST;
    :NEW.PLAN_IZM := v_new.PLAN_IZM;
    :NEW.OBPR := v_new.OBPR;
    :NEW.PLAN_GD := v_new.PLAN_GD;
    :NEW.NORMA_MON := v_new.NORMA_MON;
    :NEW.FACT_MON := v_new.FACT_MON;
    :NEW.FACT_SUT := v_new.FACT_SUT;
    :NEW.IS_BAD := v_new.IS_BAD;
    :NEW.PRICH := v_new.PRICH;
    :NEW.ZAPR_MPS := v_new.ZAPR_MPS;
  END IF;
END;
/


