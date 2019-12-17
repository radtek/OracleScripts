--
-- TRG_BIUDR_TOW_PUT_KONS  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_TOW_PUT_KONS
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.TOW_PUT_KONS
FOR EACH ROW
DECLARE
  v_old TOW_PUT_KONS%ROWTYPE;
  v_new TOW_PUT_KONS%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID_OPER := :OLD.ID_OPER;
    v_old.DATE_OPER := :OLD.DATE_OPER;
    v_old.KOL_1 := :OLD.KOL_1;
    v_old.KG_1 := :OLD.KG_1;
    v_old.CENA_POK_BN_1 := :OLD.CENA_POK_BN_1;
    v_old.CENA_POK_1 := :OLD.CENA_POK_1;
    v_old.SUMMA_POK_BN_1 := :OLD.SUMMA_POK_BN_1;
    v_old.SUMMA_POK_NDS_1 := :OLD.SUMMA_POK_NDS_1;
    v_old.SUMMA_POK_AKCIZ_1 := :OLD.SUMMA_POK_AKCIZ_1;
    v_old.SUMMA_POK_1 := :OLD.SUMMA_POK_1;
    v_old.KOL_2 := :OLD.KOL_2;
    v_old.KG_2 := :OLD.KG_2;
    v_old.CENA_POK_BN_2 := :OLD.CENA_POK_BN_2;
    v_old.CENA_POK_2 := :OLD.CENA_POK_2;
    v_old.SUMMA_POK_BN_2 := :OLD.SUMMA_POK_BN_2;
    v_old.SUMMA_POK_NDS_2 := :OLD.SUMMA_POK_NDS_2;
    v_old.SUMMA_POK_AKCIZ_2 := :OLD.SUMMA_POK_AKCIZ_2;
    v_old.SUMMA_POK_2 := :OLD.SUMMA_POK_2;
    v_old.ORG_STRU_ID := :OLD.ORG_STRU_ID;
    v_old.PREDPR_KONS_ID := :OLD.PREDPR_KONS_ID;
    v_old.PROD_KONS_ID := :OLD.PROD_KONS_ID;
    v_old.LOAD_TYPE_ID := :OLD.LOAD_TYPE_ID;
    v_old.ORG_POLUCH_ID := :OLD.ORG_POLUCH_ID;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID_OPER := :NEW.ID_OPER;
    v_new.DATE_OPER := :NEW.DATE_OPER;
    v_new.KOL_1 := :NEW.KOL_1;
    v_new.KG_1 := :NEW.KG_1;
    v_new.SUMMA_POK_BN_1 := :NEW.SUMMA_POK_BN_1;
    v_new.SUMMA_POK_NDS_1 := :NEW.SUMMA_POK_NDS_1;
    v_new.SUMMA_POK_AKCIZ_1 := :NEW.SUMMA_POK_AKCIZ_1;
    v_new.SUMMA_POK_1 := :NEW.SUMMA_POK_1;
    v_new.KOL_2 := :NEW.KOL_2;
    v_new.KG_2 := :NEW.KG_2;
    v_new.CENA_POK_BN_2 := :NEW.CENA_POK_BN_2;
    v_new.CENA_POK_2 := :NEW.CENA_POK_2;
    v_new.SUMMA_POK_BN_2 := :NEW.SUMMA_POK_BN_2;
    v_new.SUMMA_POK_NDS_2 := :NEW.SUMMA_POK_NDS_2;
    v_new.SUMMA_POK_AKCIZ_2 := :NEW.SUMMA_POK_AKCIZ_2;
    v_new.SUMMA_POK_2 := :NEW.SUMMA_POK_2;
    v_new.ORG_STRU_ID := :NEW.ORG_STRU_ID;
    v_new.PREDPR_KONS_ID := :NEW.PREDPR_KONS_ID;
    v_new.PROD_KONS_ID := :NEW.PROD_KONS_ID;
    v_new.LOAD_TYPE_ID := :NEW.LOAD_TYPE_ID;
    v_new.ORG_POLUCH_ID := :NEW.ORG_POLUCH_ID;

    IF v_new.KG_1<>0 THEN
      v_new.CENA_POK_BN_1 := v_new.SUMMA_POK_BN_1/v_new.KG_1;
      v_new.CENA_POK_1 := v_new.SUMMA_POK_1/v_new.KG_1;
	ELSE  
      v_new.CENA_POK_BN_1 := 0;
      v_new.CENA_POK_1 := 0;
	END IF;
	 
    IF v_new.KG_2<>0 THEN
      v_new.CENA_POK_BN_2 := v_new.SUMMA_POK_BN_2/v_new.KG_2;
      v_new.CENA_POK_2 := v_new.SUMMA_POK_2/v_new.KG_2;
	ELSE  
      v_new.CENA_POK_BN_2 := 0;
      v_new.CENA_POK_2 := 0;
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
    :NEW.ID_OPER := v_new.ID_OPER;
    :NEW.DATE_OPER := v_new.DATE_OPER;
    :NEW.KOL_1 := v_new.KOL_1;
    :NEW.KG_1 := v_new.KG_1;
    :NEW.CENA_POK_BN_1 := v_new.CENA_POK_BN_1;
    :NEW.CENA_POK_1 := v_new.CENA_POK_1;
    :NEW.SUMMA_POK_BN_1 := v_new.SUMMA_POK_BN_1;
    :NEW.SUMMA_POK_NDS_1 := v_new.SUMMA_POK_NDS_1;
    :NEW.SUMMA_POK_AKCIZ_1 := v_new.SUMMA_POK_AKCIZ_1;
    :NEW.SUMMA_POK_1 := v_new.SUMMA_POK_1;
    :NEW.KOL_2 := v_new.KOL_2;
    :NEW.KG_2 := v_new.KG_2;
    :NEW.CENA_POK_BN_2 := v_new.CENA_POK_BN_2;
    :NEW.CENA_POK_2 := v_new.CENA_POK_2;
    :NEW.SUMMA_POK_BN_2 := v_new.SUMMA_POK_BN_2;
    :NEW.SUMMA_POK_NDS_2 := v_new.SUMMA_POK_NDS_2;
    :NEW.SUMMA_POK_AKCIZ_2 := v_new.SUMMA_POK_AKCIZ_2;
    :NEW.SUMMA_POK_2 := v_new.SUMMA_POK_2;
    :NEW.ORG_STRU_ID := v_new.ORG_STRU_ID;
    :NEW.PREDPR_KONS_ID := v_new.PREDPR_KONS_ID;
    :NEW.PROD_KONS_ID := v_new.PROD_KONS_ID;
    :NEW.LOAD_TYPE_ID := v_new.LOAD_TYPE_ID;
    :NEW.ORG_POLUCH_ID := v_new.ORG_POLUCH_ID;
  END IF;
END;
/


