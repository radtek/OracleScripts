--
-- TRG_BIUDR_PLAN_FACT  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_PLAN_FACT
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.PLAN_FACT
FOR EACH ROW
DECLARE
  v_old PLAN_FACT%ROWTYPE;
  v_new PLAN_FACT%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.TERMINAL_NAME := :OLD.TERMINAL_NAME;
    v_old.OSUSER_NAME := :OLD.OSUSER_NAME;
    v_old.TIP_ROW := :OLD.TIP_ROW;
    v_old.GROUP_NAME := :OLD.GROUP_NAME;
    v_old.GROUP_ORDER := :OLD.GROUP_ORDER;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.PROD_ORDER := :OLD.PROD_ORDER;
    v_old.PLANSTRU_ID := :OLD.PLANSTRU_ID;
    v_old.PLANSTRU_ORDER := :OLD.PLANSTRU_ORDER;
    v_old.DATE_PLAN := :OLD.DATE_PLAN;
    v_old.PLAN_MON_C := :OLD.PLAN_MON_C;
    v_old.PLAN_MON_V := :OLD.PLAN_MON_V;
    v_old.PLAN_MON_SOBS_C := :OLD.PLAN_MON_SOBS_C;
    v_old.PLAN_MON_SOBS_V := :OLD.PLAN_MON_SOBS_V;
    v_old.PLAN_NAR_C := :OLD.PLAN_NAR_C;
    v_old.PLAN_NAR_V := :OLD.PLAN_NAR_V;
    v_old.PLAN_NAR_SOBS_C := :OLD.PLAN_NAR_SOBS_C;
    v_old.PLAN_NAR_SOBS_V := :OLD.PLAN_NAR_SOBS_V;
    v_old.DATE_ZAYV := :OLD.DATE_ZAYV;
    v_old.ZAYV := :OLD.ZAYV;
    v_old.DATE_BEG_OST := :OLD.DATE_BEG_OST;
    v_old.TIME_BEG_OST := :OLD.TIME_BEG_OST;
    v_old.BEG_OST := :OLD.BEG_OST;
    v_old.DATE_FACT := :OLD.DATE_FACT;
    v_old.TIME_FACT := :OLD.TIME_FACT;
    v_old.FACT_C := :OLD.FACT_C;
    v_old.FACT_V := :OLD.FACT_V;
    v_old.FACT_SOBS_C := :OLD.FACT_SOBS_C;
    v_old.FACT_SOBS_V := :OLD.FACT_SOBS_V;
    v_old.DATE_EMPTY_VOL := :OLD.DATE_EMPTY_VOL;
    v_old.TIME_EMPTY_VOL := :OLD.TIME_EMPTY_VOL;
    v_old.EMPTY_VOL := :OLD.EMPTY_VOL;
    v_old.DATE_OST := :OLD.DATE_OST;
    v_old.TIME_OST := :OLD.TIME_OST;
    v_old.OST := :OLD.OST;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
	:NEW.TERMINAL_NAME:=For_Init.GetCurrTerm;
	:NEW.OSUSER_NAME:=For_Init.GetCurrUser;

    v_new.ID := :NEW.ID;
    v_new.TERMINAL_NAME := :NEW.TERMINAL_NAME;
    v_new.OSUSER_NAME := :NEW.OSUSER_NAME;
    v_new.TIP_ROW := :NEW.TIP_ROW;
    v_new.GROUP_NAME := :NEW.GROUP_NAME;
    v_new.GROUP_ORDER := :NEW.GROUP_ORDER;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.PROD_ORDER := :NEW.PROD_ORDER;
    v_new.PLANSTRU_ID := :NEW.PLANSTRU_ID;
    v_new.PLANSTRU_ORDER := :NEW.PLANSTRU_ORDER;
    v_new.DATE_PLAN := :NEW.DATE_PLAN;
    v_new.PLAN_MON_C := :NEW.PLAN_MON_C;
    v_new.PLAN_MON_V := :NEW.PLAN_MON_V;
    v_new.PLAN_MON_SOBS_C := :NEW.PLAN_MON_SOBS_C;
    v_new.PLAN_MON_SOBS_V := :NEW.PLAN_MON_SOBS_V;
    v_new.PLAN_NAR_C := :NEW.PLAN_NAR_C;
    v_new.PLAN_NAR_V := :NEW.PLAN_NAR_V;
    v_new.PLAN_NAR_SOBS_C := :NEW.PLAN_NAR_SOBS_C;
    v_new.PLAN_NAR_SOBS_V := :NEW.PLAN_NAR_SOBS_V;
    v_new.DATE_ZAYV := :NEW.DATE_ZAYV;
    v_new.ZAYV := :NEW.ZAYV;
    v_new.DATE_BEG_OST := :NEW.DATE_BEG_OST;
    v_new.TIME_BEG_OST := :NEW.TIME_BEG_OST;
    v_new.BEG_OST := :NEW.BEG_OST;
    v_new.DATE_FACT := :NEW.DATE_FACT;
    v_new.TIME_FACT := :NEW.TIME_FACT;
    v_new.FACT_C := :NEW.FACT_C;
    v_new.FACT_V := :NEW.FACT_V;
    v_new.FACT_SOBS_C := :NEW.FACT_SOBS_C;
    v_new.FACT_SOBS_V := :NEW.FACT_SOBS_V;
    v_new.DATE_EMPTY_VOL := :NEW.DATE_EMPTY_VOL;
    v_new.TIME_EMPTY_VOL := :NEW.TIME_EMPTY_VOL;
    v_new.EMPTY_VOL := :NEW.EMPTY_VOL;
    v_new.DATE_OST := :NEW.DATE_OST;
    v_new.TIME_OST := :NEW.TIME_OST;
    v_new.OST := :NEW.OST;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_PLAN_FACT.NEXTVAL INTO v_new.ID FROM DUAL;
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
	  v_NEW.TERMINAL_NAME:=For_Init.GetCurrTerm;
	  v_NEW.OSUSER_NAME:=For_Init.GetCurrUser;
      NULL;
    END IF;

    -- Сохранение новых значений
    :NEW.ID := v_new.ID;
    :NEW.TERMINAL_NAME := v_new.TERMINAL_NAME;
    :NEW.OSUSER_NAME := v_new.OSUSER_NAME;
    :NEW.TIP_ROW := v_new.TIP_ROW;
    :NEW.GROUP_NAME := v_new.GROUP_NAME;
    :NEW.GROUP_ORDER := v_new.GROUP_ORDER;
    :NEW.PROD_ID_NPR := v_new.PROD_ID_NPR;
    :NEW.PROD_ORDER := v_new.PROD_ORDER;
    :NEW.PLANSTRU_ID := v_new.PLANSTRU_ID;
    :NEW.PLANSTRU_ORDER := v_new.PLANSTRU_ORDER;
    :NEW.DATE_PLAN := v_new.DATE_PLAN;
    :NEW.PLAN_MON_C := v_new.PLAN_MON_C;
    :NEW.PLAN_MON_V := v_new.PLAN_MON_V;
    :NEW.PLAN_MON_SOBS_C := v_new.PLAN_MON_SOBS_C;
    :NEW.PLAN_MON_SOBS_V := v_new.PLAN_MON_SOBS_V;
    :NEW.PLAN_NAR_C := v_new.PLAN_NAR_C;
    :NEW.PLAN_NAR_V := v_new.PLAN_NAR_V;
    :NEW.PLAN_NAR_SOBS_C := v_new.PLAN_NAR_SOBS_C;
    :NEW.PLAN_NAR_SOBS_V := v_new.PLAN_NAR_SOBS_V;
    :NEW.DATE_ZAYV := v_new.DATE_ZAYV;
    :NEW.ZAYV := v_new.ZAYV;
    :NEW.DATE_BEG_OST := v_new.DATE_BEG_OST;
    :NEW.TIME_BEG_OST := v_new.TIME_BEG_OST;
    :NEW.BEG_OST := v_new.BEG_OST;
    :NEW.DATE_FACT := v_new.DATE_FACT;
    :NEW.TIME_FACT := v_new.TIME_FACT;
    :NEW.FACT_C := v_new.FACT_C;
    :NEW.FACT_V := v_new.FACT_V;
    :NEW.FACT_SOBS_C := v_new.FACT_SOBS_C;
    :NEW.FACT_SOBS_V := v_new.FACT_SOBS_V;
    :NEW.DATE_EMPTY_VOL := v_new.DATE_EMPTY_VOL;
    :NEW.TIME_EMPTY_VOL := v_new.TIME_EMPTY_VOL;
    :NEW.EMPTY_VOL := v_new.EMPTY_VOL;
    :NEW.DATE_OST := v_new.DATE_OST;
    :NEW.TIME_OST := v_new.TIME_OST;
    :NEW.OST := v_new.OST;
  END IF;
END;
/


