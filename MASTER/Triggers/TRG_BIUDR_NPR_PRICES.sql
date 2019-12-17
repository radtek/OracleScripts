--
-- TRG_BIUDR_NPR_PRICES  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_NPR_PRICES
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.NPR_PRICES
FOR EACH ROW
DECLARE
  v_old NPR_PRICES%ROWTYPE;
  v_new NPR_PRICES%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.CAT_CEN_ID := :OLD.CAT_CEN_ID;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.CENA := :OLD.CENA;
    v_old.NDS20 := :OLD.NDS20;
    v_old.NGSM25 := :OLD.NGSM25;
    v_old.AKCIZ := :OLD.AKCIZ;
    v_old.CENA_OTP := :OLD.CENA_OTP;
    v_old.BEGIN_DATE := :OLD.BEGIN_DATE;
    v_old.END_DATE := :OLD.END_DATE;
    v_old.INPUT_DATE := :OLD.INPUT_DATE;
    v_old.OWNERSHIP_ID := :OLD.OWNERSHIP_ID;
    v_old.SUPPLIER_ID := :OLD.SUPPLIER_ID;
    v_old.PROTOKOL_DATE := :OLD.PROTOKOL_DATE;
    v_old.PROTOKOL_NUM := :OLD.PROTOKOL_NUM;
    v_old.IS_ORIGINAL := :OLD.IS_ORIGINAL;
    v_old.PROTOKOL_BEGIN_DATE := :OLD.PROTOKOL_BEGIN_DATE;
    v_old.NDS20_NPO := :OLD.NDS20_NPO;
    v_old.CENA_NPO := :OLD.CENA_NPO;
    v_old.CENA_OTP_NPO := :OLD.CENA_OTP_NPO;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.CAT_CEN_ID := :NEW.CAT_CEN_ID;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.CENA := :NEW.CENA;
    v_new.NDS20 := :NEW.NDS20;
    v_new.NGSM25 := :NEW.NGSM25;
    v_new.AKCIZ := :NEW.AKCIZ;
    v_new.CENA_OTP := :NEW.CENA_OTP;
    v_new.BEGIN_DATE := :NEW.BEGIN_DATE;
    v_new.END_DATE := :NEW.END_DATE;
    v_new.INPUT_DATE := :NEW.INPUT_DATE;
    v_new.OWNERSHIP_ID := :NEW.OWNERSHIP_ID;
    v_new.SUPPLIER_ID := :NEW.SUPPLIER_ID;
    v_new.PROTOKOL_DATE := :NEW.PROTOKOL_DATE;
    v_new.PROTOKOL_NUM := :NEW.PROTOKOL_NUM;
    v_new.IS_ORIGINAL := :NEW.IS_ORIGINAL;
    v_new.PROTOKOL_BEGIN_DATE := :NEW.PROTOKOL_BEGIN_DATE;
    v_new.NDS20_NPO := :NEW.NDS20_NPO;
    v_new.CENA_NPO := :NEW.CENA_NPO;
    v_new.CENA_OTP_NPO := :NEW.CENA_OTP_NPO;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_NPR_PRICES.NEXTVAL INTO v_new.ID FROM DUAL;
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
    :NEW.CAT_CEN_ID := v_new.CAT_CEN_ID;
    :NEW.PROD_ID_NPR := v_new.PROD_ID_NPR;
    :NEW.CENA := v_new.CENA;
    :NEW.NDS20 := v_new.NDS20;
    :NEW.NGSM25 := v_new.NGSM25;
    :NEW.AKCIZ := v_new.AKCIZ;
    :NEW.CENA_OTP := v_new.CENA_OTP;
    :NEW.BEGIN_DATE := v_new.BEGIN_DATE;
    :NEW.END_DATE := v_new.END_DATE;
    :NEW.INPUT_DATE := v_new.INPUT_DATE;
    :NEW.OWNERSHIP_ID := v_new.OWNERSHIP_ID;
    :NEW.SUPPLIER_ID := v_new.SUPPLIER_ID;
    :NEW.PROTOKOL_DATE := v_new.PROTOKOL_DATE;
    :NEW.PROTOKOL_NUM := v_new.PROTOKOL_NUM;
    :NEW.IS_ORIGINAL := v_new.IS_ORIGINAL;
    :NEW.PROTOKOL_BEGIN_DATE := v_new.PROTOKOL_BEGIN_DATE;
    :NEW.NDS20_NPO := v_new.NDS20_NPO;
    :NEW.CENA_NPO := v_new.CENA_NPO;
    :NEW.CENA_OTP_NPO := v_new.CENA_OTP_NPO;
  END IF;
END;
/


