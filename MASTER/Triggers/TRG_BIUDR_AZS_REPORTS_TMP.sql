--
-- TRG_BIUDR_AZS_REPORTS_TMP  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_AZS_REPORTS_TMP
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.AZS_REPORTS_TMP
FOR EACH ROW
DECLARE
  v_old AZS_REPORTS_TMP%ROWTYPE;
  v_new AZS_REPORTS_TMP%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.TERMINAL_NAME := :OLD.TERMINAL_NAME;
    v_old.OSUSER_NAME := :OLD.OSUSER_NAME;
    v_old.TYPE_OPER_ID := :OLD.TYPE_OPER_ID;
    v_old.ORG_STRU_ID := :OLD.ORG_STRU_ID;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.OPER_DAY := :OLD.OPER_DAY;
    v_old.PRICE := :OLD.PRICE;
    v_old.VOLUME := :OLD.VOLUME;
    v_old.MASSA := :OLD.MASSA;
    v_old.SUMMA := :OLD.SUMMA;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
	v_NEW.TERMINAL_NAME:=For_Init.GetCurrTerm;
	v_NEW.OSUSER_NAME:=For_Init.GetCurrUser;
    v_new.TYPE_OPER_ID := :NEW.TYPE_OPER_ID;
    v_new.ORG_STRU_ID := :NEW.ORG_STRU_ID;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.OPER_DAY := :NEW.OPER_DAY;
    v_new.PRICE := :NEW.PRICE;
    v_new.VOLUME := :NEW.VOLUME;
    v_new.MASSA := :NEW.MASSA;
    v_new.SUMMA := :NEW.SUMMA;

    IF 1=1 THEN
      -- Уникальный ID
--      IF v_new.ID=0 OR v_new.ID IS NULL THEN
--        SELECT SEQ_AZS_REPORTS_TMP.nextval INTO v_new.ID FROM DUAL;
--      END IF;
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
    :NEW.TYPE_OPER_ID := v_new.TYPE_OPER_ID;
    :NEW.ORG_STRU_ID := v_new.ORG_STRU_ID;
    :NEW.PROD_ID_NPR := v_new.PROD_ID_NPR;
    :NEW.OPER_DAY := v_new.OPER_DAY;
    :NEW.PRICE := v_new.PRICE;
    :NEW.VOLUME := v_new.VOLUME;
    :NEW.MASSA := v_new.MASSA;
    :NEW.SUMMA := v_new.SUMMA;
  END IF;
END;
/


