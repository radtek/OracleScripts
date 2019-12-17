--
-- TRG_BIUDR_SPECIF  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_SPECIF
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.SPECIF
FOR EACH ROW
DECLARE
  v_old SPECIF%ROWTYPE;
  v_new SPECIF%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.DOG_ID := :OLD.DOG_ID;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.LOAD_ABBR := :OLD.LOAD_ABBR;
    v_old.STANOTP_ID := :OLD.STANOTP_ID;
    v_old.STAN_ID := :OLD.STAN_ID;
    v_old.VETKA_ID := :OLD.VETKA_ID;
    v_old.POLUCH_ID := :OLD.POLUCH_ID;
    v_old.POTREB_ID := :OLD.POTREB_ID;
    v_old.PRIM := :OLD.PRIM;
    v_old.GR4 := :OLD.GR4;
    v_old.M1 := :OLD.M1;
    v_old.M2 := :OLD.M2;
    v_old.M3 := :OLD.M3;
    v_old.M4 := :OLD.M4;
    v_old.M5 := :OLD.M5;
    v_old.M6 := :OLD.M6;
    v_old.M7 := :OLD.M7;
    v_old.M8 := :OLD.M8;
    v_old.M9 := :OLD.M9;
    v_old.M10 := :OLD.M10;
    v_old.M11 := :OLD.M11;
    v_old.M12 := :OLD.M12;
    v_old.KV1 := :OLD.KV1;
    v_old.KV2 := :OLD.KV2;
    v_old.KV3 := :OLD.KV3;
    v_old.KV4 := :OLD.KV4;
    v_old.VES_ALL := :OLD.VES_ALL;
    v_old.APPL_TAG := :OLD.APPL_TAG;
    v_old.BEGIN_DATE := :OLD.BEGIN_DATE;
    v_old.END_DATE := :OLD.END_DATE;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.DOG_ID := :NEW.DOG_ID;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.LOAD_ABBR := :NEW.LOAD_ABBR;
    v_new.STANOTP_ID := :NEW.STANOTP_ID;
    v_new.STAN_ID := :NEW.STAN_ID;
    v_new.VETKA_ID := :NEW.VETKA_ID;
    v_new.POLUCH_ID := :NEW.POLUCH_ID;
    v_new.POTREB_ID := :NEW.POTREB_ID;
    v_new.PRIM := :NEW.PRIM;
    v_new.GR4 := :NEW.GR4;
    v_new.M1 := :NEW.M1;
    v_new.M2 := :NEW.M2;
    v_new.M3 := :NEW.M3;
    v_new.M4 := :NEW.M4;
    v_new.M5 := :NEW.M5;
    v_new.M6 := :NEW.M6;
    v_new.M7 := :NEW.M7;
    v_new.M8 := :NEW.M8;
    v_new.M9 := :NEW.M9;
    v_new.M10 := :NEW.M10;
    v_new.M11 := :NEW.M11;
    v_new.M12 := :NEW.M12;
    v_new.KV1 := :NEW.KV1;
    v_new.KV2 := :NEW.KV2;
    v_new.KV3 := :NEW.KV3;
    v_new.KV4 := :NEW.KV4;
    v_new.VES_ALL := :NEW.VES_ALL;
    v_new.APPL_TAG := :NEW.APPL_TAG;
    v_new.BEGIN_DATE := :NEW.BEGIN_DATE;
    v_new.END_DATE := :NEW.END_DATE;

    IF v_new.ID=0 OR v_new.ID IS NULL THEN
      SELECT SEQ_SPECIF.NEXTVAL INTO v_new.ID FROM DUAL;
    END IF;

    IF v_old.APPL_TAG='MASTER' THEN
      -- Проверка новых значений
	  v_new.KV1:=NVL(v_new.M1,0)+NVL(v_new.M2,0)+NVL(v_new.M3,0);
	  v_new.KV2:=NVL(v_new.M4,0)+NVL(v_new.M5,0)+NVL(v_new.M6,0);
	  v_new.KV3:=NVL(v_new.M7,0)+NVL(v_new.M8,0)+NVL(v_new.M9,0);
	  v_new.KV4:=NVL(v_new.M10,0)+NVL(v_new.M11,0)+NVL(v_new.M12,0);
	  v_new.VES_ALL:=NVL(v_new.KV1,0)+NVL(v_new.KV2,0)+NVL(v_new.KV3,0)+NVL(v_new.KV4,0);
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
    :NEW.DOG_ID := v_new.DOG_ID;
    :NEW.PROD_ID_NPR := v_new.PROD_ID_NPR;
    :NEW.LOAD_ABBR := v_new.LOAD_ABBR;
    :NEW.STANOTP_ID := v_new.STANOTP_ID;
    :NEW.STAN_ID := v_new.STAN_ID;
    :NEW.VETKA_ID := v_new.VETKA_ID;
    :NEW.POLUCH_ID := v_new.POLUCH_ID;
    :NEW.POTREB_ID := v_new.POTREB_ID;
    :NEW.PRIM := v_new.PRIM;
    :NEW.GR4 := v_new.GR4;
    :NEW.M1 := v_new.M1;
    :NEW.M2 := v_new.M2;
    :NEW.M3 := v_new.M3;
    :NEW.M4 := v_new.M4;
    :NEW.M5 := v_new.M5;
    :NEW.M6 := v_new.M6;
    :NEW.M7 := v_new.M7;
    :NEW.M8 := v_new.M8;
    :NEW.M9 := v_new.M9;
    :NEW.M10 := v_new.M10;
    :NEW.M11 := v_new.M11;
    :NEW.M12 := v_new.M12;
    :NEW.KV1 := v_new.KV1;
    :NEW.KV2 := v_new.KV2;
    :NEW.KV3 := v_new.KV3;
    :NEW.KV4 := v_new.KV4;
    :NEW.VES_ALL := v_new.VES_ALL;
    :NEW.APPL_TAG := v_new.APPL_TAG;
    :NEW.BEGIN_DATE := v_new.BEGIN_DATE;
    :NEW.END_DATE := v_new.END_DATE;
  END IF;
END;
/


