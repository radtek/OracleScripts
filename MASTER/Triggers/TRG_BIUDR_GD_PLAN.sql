--
-- TRG_BIUDR_GD_PLAN  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_GD_PLAN
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.GD_PLAN
FOR EACH ROW
DECLARE
  v_old GD_PLAN%ROWTYPE;
  v_new GD_PLAN%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.DATE_PLAN := :OLD.DATE_PLAN;
    v_old.FROM_DATE := :OLD.FROM_DATE;
    v_old.TO_DATE := :OLD.TO_DATE;
    v_old.PLAN_CIST := :OLD.PLAN_CIST;
    v_old.PLAN_VES := :OLD.PLAN_VES;
    v_old.DATE_KORR := :OLD.DATE_KORR;
    v_old.KORR_CIST := :OLD.KORR_CIST;
    v_old.KORR_VES := :OLD.KORR_VES;
    v_old.MARSHRUT_CIST := :OLD.MARSHRUT_CIST;
    v_old.MARSHRUT_VES := :OLD.MARSHRUT_VES;
    v_old.GROTP_ID := :OLD.GROTP_ID;
    v_old.NAPR_MOS_ID := :OLD.NAPR_MOS_ID;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.LOAD_TYPE_ID := :OLD.LOAD_TYPE_ID;
    v_old.VAGOWNER_ID := :OLD.VAGOWNER_ID;
    v_old.STANOTP_ID := :OLD.STANOTP_ID;
    v_old.TIP_PLAN := :OLD.TIP_PLAN;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.DATE_PLAN := :NEW.DATE_PLAN;
    v_new.FROM_DATE := :NEW.FROM_DATE;
    v_new.TO_DATE := :NEW.TO_DATE;
    v_new.PLAN_CIST := :NEW.PLAN_CIST;
    v_new.PLAN_VES := :NEW.PLAN_VES;
    v_new.DATE_KORR := :NEW.DATE_KORR;
    v_new.KORR_CIST := :NEW.KORR_CIST;
    v_new.KORR_VES := :NEW.KORR_VES;
    v_new.MARSHRUT_CIST := :NEW.MARSHRUT_CIST;
    v_new.MARSHRUT_VES := :NEW.MARSHRUT_VES;
    v_new.GROTP_ID := :NEW.GROTP_ID;
    v_new.NAPR_MOS_ID := :NEW.NAPR_MOS_ID;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.LOAD_TYPE_ID := :NEW.LOAD_TYPE_ID;
    v_new.VAGOWNER_ID := :NEW.VAGOWNER_ID;
    v_new.STANOTP_ID := :NEW.STANOTP_ID;
    v_new.TIP_PLAN := :NEW.TIP_PLAN;

--    IF v_old.APPL_TAG='MASTER' THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_GD_PLAN.NEXTVAL INTO v_new.ID FROM DUAL;
      END IF;
      -- Проверка новых значений
--      NULL;
--    END IF;

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
    :NEW.DATE_PLAN := v_new.DATE_PLAN;
    :NEW.FROM_DATE := v_new.FROM_DATE;
    :NEW.TO_DATE := v_new.TO_DATE;
    :NEW.PLAN_CIST := v_new.PLAN_CIST;
    :NEW.PLAN_VES := v_new.PLAN_VES;
    :NEW.DATE_KORR := v_new.DATE_KORR;
    :NEW.KORR_CIST := v_new.KORR_CIST;
    :NEW.KORR_VES := v_new.KORR_VES;
    :NEW.MARSHRUT_CIST := v_new.MARSHRUT_CIST;
    :NEW.MARSHRUT_VES := v_new.MARSHRUT_VES;
    :NEW.GROTP_ID := v_new.GROTP_ID;
    :NEW.NAPR_MOS_ID := v_new.NAPR_MOS_ID;
    :NEW.PROD_ID_NPR := v_new.PROD_ID_NPR;
    :NEW.LOAD_TYPE_ID := v_new.LOAD_TYPE_ID;
    :NEW.VAGOWNER_ID := v_new.VAGOWNER_ID;
    :NEW.STANOTP_ID := v_new.STANOTP_ID;
    :NEW.TIP_PLAN := v_new.TIP_PLAN;
  END IF;
END;
/


