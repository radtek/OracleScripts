--
-- TRG_BIUDR_OBOROT_KONS  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_OBOROT_KONS
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.OBOROT_KONS
FOR EACH ROW
DECLARE
  v_old OBOROT_KONS%ROWTYPE;
  v_new OBOROT_KONS%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID_OPER := :OLD.ID_OPER;
    v_old.DATE_OPER := :OLD.DATE_OPER;
    v_old.KOL := :OLD.KOL;
    v_old.KG := :OLD.KG;
    v_old.LIT := :OLD.LIT;
    v_old.CENA_POKUP_BN := :OLD.CENA_POKUP_BN;
    v_old.CENA_POKUP := :OLD.CENA_POKUP;
    v_old.SUMMA_POKUP_BN := :OLD.SUMMA_POKUP_BN;
    v_old.SUMMA_POKUP_NDS := :OLD.SUMMA_POKUP_NDS;
    v_old.SUMMA_POKUP_AKCIZ := :OLD.SUMMA_POKUP_AKCIZ;
    v_old.SUMMA_POKUP := :OLD.SUMMA_POKUP;
    v_old.CENA_REALIZ_BN := :OLD.CENA_REALIZ_BN;
    v_old.CENA_REALIZ := :OLD.CENA_REALIZ;
    v_old.SUMMA_REALIZ_BN := :OLD.SUMMA_REALIZ_BN;
    v_old.SUMMA_REALIZ_NDS := :OLD.SUMMA_REALIZ_NDS;
    v_old.SUMMA_REALIZ_AKCIZ := :OLD.SUMMA_REALIZ_AKCIZ;
    v_old.SUMMA_REALIZ := :OLD.SUMMA_REALIZ;
    v_old.CENA_UCHET := :OLD.CENA_UCHET;
    v_old.SUMMA_UCHET := :OLD.SUMMA_UCHET;
    v_old.UPDATE_USER := :OLD.UPDATE_USER;
    v_old.UPDATE_DATE := :OLD.UPDATE_DATE;
    v_old.AKCIZ_SVED := :OLD.AKCIZ_SVED;
    v_old.ORG_STRU_ID := :OLD.ORG_STRU_ID;
    v_old.PREDPR_KONS_ID := :OLD.PREDPR_KONS_ID;
    v_old.PROD_KONS_ID := :OLD.PROD_KONS_ID;
    v_old.PREDPR_CLASS_ID := :OLD.PREDPR_CLASS_ID;
    v_old.TIP_OP_ID := :OLD.TIP_OP_ID;
    v_old.ST_PRIH_ID := :OLD.ST_PRIH_ID;
    v_old.ST_RASH_ID := :OLD.ST_RASH_ID;
    v_old.TIP_REAL_ID := :OLD.TIP_REAL_ID;
    v_old.VID_REAL_ID := :OLD.VID_REAL_ID;
    v_old.VID_POST_ID := :OLD.VID_POST_ID;
    v_old.OTGR_POST_ID := :OLD.OTGR_POST_ID;
    v_old.LOAD_TYPE_ID := :OLD.LOAD_TYPE_ID;
    v_old.REGION_ID := :OLD.REGION_ID;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID_OPER := :NEW.ID_OPER;
    v_new.DATE_OPER := :NEW.DATE_OPER;
    v_new.KOL := :NEW.KOL;
    v_new.KG := :NEW.KG;
    v_new.LIT := :NEW.LIT;

    v_new.SUMMA_POKUP_BN := :NEW.SUMMA_POKUP_BN;
    v_new.SUMMA_POKUP_NDS := :NEW.SUMMA_POKUP_NDS;
    v_new.SUMMA_POKUP_AKCIZ := :NEW.SUMMA_POKUP_AKCIZ;
    v_new.SUMMA_POKUP := :NEW.SUMMA_POKUP;
    v_new.SUMMA_REALIZ_BN := :NEW.SUMMA_REALIZ_BN;
    v_new.SUMMA_REALIZ_NDS := :NEW.SUMMA_REALIZ_NDS;
    v_new.SUMMA_REALIZ_AKCIZ := :NEW.SUMMA_REALIZ_AKCIZ;
    v_new.SUMMA_REALIZ := :NEW.SUMMA_REALIZ;
    v_new.SUMMA_UCHET := :NEW.SUMMA_UCHET;

    IF v_new.KG<>0 THEN
      v_new.CENA_POKUP_BN := v_new.SUMMA_POKUP_BN/v_new.KG;
      v_new.CENA_POKUP := v_new.SUMMA_POKUP/v_new.KG;
      v_new.CENA_REALIZ_BN := v_new.SUMMA_REALIZ_BN/v_new.KG;
      v_new.CENA_REALIZ := v_new.SUMMA_REALIZ/v_new.KG;
      v_new.CENA_UCHET := v_new.SUMMA_UCHET/v_new.KG;
	ELSE  
      v_new.CENA_POKUP_BN := 0;
      v_new.CENA_POKUP := 0;
      v_new.CENA_REALIZ_BN := 0;
      v_new.CENA_REALIZ := 0;
      v_new.CENA_UCHET := 0;
    END IF;
	
    v_new.UPDATE_USER := :NEW.UPDATE_USER;
    v_new.UPDATE_DATE := :NEW.UPDATE_DATE;
    v_new.AKCIZ_SVED := :NEW.AKCIZ_SVED;
    v_new.ORG_STRU_ID := :NEW.ORG_STRU_ID;
    v_new.PREDPR_KONS_ID := :NEW.PREDPR_KONS_ID;
    v_new.PROD_KONS_ID := :NEW.PROD_KONS_ID;
    v_new.PREDPR_CLASS_ID := :NEW.PREDPR_CLASS_ID;
    v_new.TIP_OP_ID := :NEW.TIP_OP_ID;
    v_new.ST_PRIH_ID := :NEW.ST_PRIH_ID;
    v_new.ST_RASH_ID := :NEW.ST_RASH_ID;
    v_new.TIP_REAL_ID := :NEW.TIP_REAL_ID;
    v_new.VID_REAL_ID := :NEW.VID_REAL_ID;
    v_new.VID_POST_ID := :NEW.VID_POST_ID;
    v_new.OTGR_POST_ID := :NEW.OTGR_POST_ID;
    v_new.LOAD_TYPE_ID := :NEW.LOAD_TYPE_ID;
    v_new.REGION_ID := :NEW.REGION_ID;


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
    :NEW.KOL := v_new.KOL;
    :NEW.KG := v_new.KG;
    :NEW.LIT := v_new.LIT;
    :NEW.CENA_POKUP_BN := v_new.CENA_POKUP_BN;
    :NEW.CENA_POKUP := v_new.CENA_POKUP;
    :NEW.SUMMA_POKUP_BN := v_new.SUMMA_POKUP_BN;
    :NEW.SUMMA_POKUP_NDS := v_new.SUMMA_POKUP_NDS;
    :NEW.SUMMA_POKUP_AKCIZ := v_new.SUMMA_POKUP_AKCIZ;
    :NEW.SUMMA_POKUP := v_new.SUMMA_POKUP;
    :NEW.CENA_REALIZ_BN := v_new.CENA_REALIZ_BN;
    :NEW.CENA_REALIZ := v_new.CENA_REALIZ;
    :NEW.SUMMA_REALIZ_BN := v_new.SUMMA_REALIZ_BN;
    :NEW.SUMMA_REALIZ_NDS := v_new.SUMMA_REALIZ_NDS;
    :NEW.SUMMA_REALIZ_AKCIZ := v_new.SUMMA_REALIZ_AKCIZ;
    :NEW.SUMMA_REALIZ := v_new.SUMMA_REALIZ;
    :NEW.CENA_UCHET := v_new.CENA_UCHET;
    :NEW.SUMMA_UCHET := v_new.SUMMA_UCHET;
    :NEW.UPDATE_USER := v_new.UPDATE_USER;
    :NEW.UPDATE_DATE := v_new.UPDATE_DATE;
    :NEW.AKCIZ_SVED := v_new.AKCIZ_SVED;
    :NEW.ORG_STRU_ID := v_new.ORG_STRU_ID;
    :NEW.PREDPR_KONS_ID := v_new.PREDPR_KONS_ID;
    :NEW.PROD_KONS_ID := v_new.PROD_KONS_ID;
    :NEW.PREDPR_CLASS_ID := v_new.PREDPR_CLASS_ID;
    :NEW.TIP_OP_ID := v_new.TIP_OP_ID;
    :NEW.ST_PRIH_ID := v_new.ST_PRIH_ID;
    :NEW.ST_RASH_ID := v_new.ST_RASH_ID;
    :NEW.TIP_REAL_ID := v_new.TIP_REAL_ID;
    :NEW.VID_REAL_ID := v_new.VID_REAL_ID;
    :NEW.VID_POST_ID := v_new.VID_POST_ID;
    :NEW.OTGR_POST_ID := v_new.OTGR_POST_ID;
    :NEW.LOAD_TYPE_ID := v_new.LOAD_TYPE_ID;
    :NEW.REGION_ID := v_new.REGION_ID;
  END IF;
END;
/


