--
-- TRG_BIUDR_PLAN_FACT_REALIZ  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_PLAN_FACT_REALIZ
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.PLAN_FACT_REALIZ
FOR EACH ROW
DECLARE
  v_old PLAN_FACT_REALIZ%ROWTYPE;
  v_new PLAN_FACT_REALIZ%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.TERMINAL_NAME := :OLD.TERMINAL_NAME;
    v_old.OSUSER_NAME := :OLD.OSUSER_NAME;
    v_old.TIP_ROW := :OLD.TIP_ROW;
    v_old.DATE_BEGIN := :OLD.DATE_BEGIN;
    v_old.DATE_END := :OLD.DATE_END;
    v_old.DATE_PLAN := :OLD.DATE_PLAN;
    v_old.FILIAL_ID := :OLD.FILIAL_ID;
    v_old.FILIAL_NAME := :OLD.FILIAL_NAME;
    v_old.REGION_ORDER := :OLD.REGION_ORDER;
    v_old.REGION_NAME := :OLD.REGION_NAME;
    v_old.NAPR_ORDER := :OLD.NAPR_ORDER;
    v_old.NAPR_NAME := :OLD.NAPR_NAME;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.GROUP_ORDER := :OLD.GROUP_ORDER;
    v_old.GROUP_NAME := :OLD.GROUP_NAME;
    v_old.BEGIN_OST := :OLD.BEGIN_OST;
    v_old.PLAN_POST_VES := :OLD.PLAN_POST_VES;
    v_old.FACT_POST_VES := :OLD.FACT_POST_VES;
    v_old.RESURS := :OLD.RESURS;
    v_old.PLAN_REAL_VES := :OLD.PLAN_REAL_VES;
    v_old.FACT_REAL_VES := :OLD.FACT_REAL_VES;
    v_old.END_OST := :OLD.END_OST;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
	:NEW.TERMINAL_NAME:=For_Init.GetCurrTerm;
	:NEW.OSUSER_NAME:=For_Init.GetCurrUser;

    v_new.TERMINAL_NAME := :NEW.TERMINAL_NAME;
    v_new.OSUSER_NAME := :NEW.OSUSER_NAME;
    v_new.TIP_ROW := :NEW.TIP_ROW;
    v_new.DATE_BEGIN := :NEW.DATE_BEGIN;
    v_new.DATE_END := :NEW.DATE_END;
    v_new.DATE_PLAN := :NEW.DATE_PLAN;
    v_new.FILIAL_ID := :NEW.FILIAL_ID;
    v_new.FILIAL_NAME := :NEW.FILIAL_NAME;
    v_new.REGION_ORDER := :NEW.REGION_ORDER;
    v_new.REGION_NAME := :NEW.REGION_NAME;
    v_new.NAPR_ORDER := :NEW.NAPR_ORDER;
    v_new.NAPR_NAME := :NEW.NAPR_NAME;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.GROUP_ORDER := :NEW.GROUP_ORDER;
    v_new.GROUP_NAME := :NEW.GROUP_NAME;
    v_new.BEGIN_OST := :NEW.BEGIN_OST;
    v_new.PLAN_POST_VES := :NEW.PLAN_POST_VES;
    v_new.FACT_POST_VES := :NEW.FACT_POST_VES;
    v_new.RESURS := :NEW.RESURS;
    v_new.PLAN_REAL_VES := :NEW.PLAN_REAL_VES;
    v_new.FACT_REAL_VES := :NEW.FACT_REAL_VES;
    v_new.END_OST := :NEW.END_OST;

    IF 1=1 THEN
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
    :NEW.TERMINAL_NAME := v_new.TERMINAL_NAME;
    :NEW.OSUSER_NAME := v_new.OSUSER_NAME;
    :NEW.TIP_ROW := v_new.TIP_ROW;
    :NEW.DATE_BEGIN := v_new.DATE_BEGIN;
    :NEW.DATE_END := v_new.DATE_END;
    :NEW.DATE_PLAN := v_new.DATE_PLAN;
    :NEW.FILIAL_ID := v_new.FILIAL_ID;
    :NEW.FILIAL_NAME := v_new.FILIAL_NAME;
    :NEW.REGION_ORDER := v_new.REGION_ORDER;
    :NEW.REGION_NAME := v_new.REGION_NAME;
    :NEW.NAPR_ORDER := v_new.NAPR_ORDER;
    :NEW.NAPR_NAME := v_new.NAPR_NAME;
    :NEW.PROD_ID_NPR := v_new.PROD_ID_NPR;
    :NEW.GROUP_ORDER := v_new.GROUP_ORDER;
    :NEW.GROUP_NAME := v_new.GROUP_NAME;
    :NEW.BEGIN_OST := v_new.BEGIN_OST;
    :NEW.PLAN_POST_VES := v_new.PLAN_POST_VES;
    :NEW.FACT_POST_VES := v_new.FACT_POST_VES;
    :NEW.RESURS := v_new.RESURS;
    :NEW.PLAN_REAL_VES := v_new.PLAN_REAL_VES;
    :NEW.FACT_REAL_VES := v_new.FACT_REAL_VES;
    :NEW.END_OST := v_new.END_OST;
  END IF;
END;
/


