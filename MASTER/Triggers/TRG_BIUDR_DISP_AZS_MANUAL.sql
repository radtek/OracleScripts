--
-- TRG_BIUDR_DISP_AZS_MANUAL  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_DISP_AZS_MANUAL
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.DISP_AZS_MANUAL
FOR EACH ROW
DECLARE
  v_old DISP_AZS_MANUAL%ROWTYPE;
  v_new DISP_AZS_MANUAL%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.OSUSER := :OLD.OSUSER;
    v_old.TERMINAL := :OLD.TERMINAL;
    v_old.ORG_STRU_ID := :OLD.ORG_STRU_ID;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.OUT_O_VOL := :OLD.OUT_O_VOL;
    v_old.OUT_O_MAS := :OLD.OUT_O_MAS;
    v_old.END_VOLUME := :OLD.END_VOLUME;
    v_old.END_MASSA := :OLD.END_MASSA;
    v_old.OUT_O_1_VOL := :OLD.OUT_O_1_VOL;
    v_old.OUT_O_1_MAS := :OLD.OUT_O_1_MAS;
    v_old.OUT_O_2_VOL := :OLD.OUT_O_2_VOL;
    v_old.OUT_O_2_MAS := :OLD.OUT_O_2_MAS;
    v_old.OUT_O_3_VOL := :OLD.OUT_O_3_VOL;
    v_old.OUT_O_3_MAS := :OLD.OUT_O_3_MAS;
    v_old.OUT_O_4_VOL := :OLD.OUT_O_4_VOL;
    v_old.OUT_O_4_MAS := :OLD.OUT_O_4_MAS;
    v_old.OUT_O_5_VOL := :OLD.OUT_O_5_VOL;
    v_old.OUT_O_5_MAS := :OLD.OUT_O_5_MAS;
    v_old.OUT_O_6_VOL := :OLD.OUT_O_6_VOL;
    v_old.OUT_O_6_MAS := :OLD.OUT_O_6_MAS;
    v_old.OUT_O_7_VOL := :OLD.OUT_O_7_VOL;
    v_old.OUT_O_7_MAS := :OLD.OUT_O_7_MAS;
    v_old.LAST_DAY := :OLD.LAST_DAY;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
	v_NEW.TERMINAL:=For_Init.GetCurrTerm;
	v_NEW.OSUSER:=For_Init.GetCurrUser;
    v_new.ORG_STRU_ID := :NEW.ORG_STRU_ID;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.OUT_O_VOL := :NEW.OUT_O_VOL;
    v_new.OUT_O_MAS := :NEW.OUT_O_MAS;
    v_new.END_VOLUME := :NEW.END_VOLUME;
    v_new.END_MASSA := :NEW.END_MASSA;
    v_new.OUT_O_1_VOL := :NEW.OUT_O_1_VOL;
    v_new.OUT_O_1_MAS := :NEW.OUT_O_1_MAS;
    v_new.OUT_O_2_VOL := :NEW.OUT_O_2_VOL;
    v_new.OUT_O_2_MAS := :NEW.OUT_O_2_MAS;
    v_new.OUT_O_3_VOL := :NEW.OUT_O_3_VOL;
    v_new.OUT_O_3_MAS := :NEW.OUT_O_3_MAS;
    v_new.OUT_O_4_VOL := :NEW.OUT_O_4_VOL;
    v_new.OUT_O_4_MAS := :NEW.OUT_O_4_MAS;
    v_new.OUT_O_5_VOL := :NEW.OUT_O_5_VOL;
    v_new.OUT_O_5_MAS := :NEW.OUT_O_5_MAS;
    v_new.OUT_O_6_VOL := :NEW.OUT_O_6_VOL;
    v_new.OUT_O_6_MAS := :NEW.OUT_O_6_MAS;
    v_new.OUT_O_7_VOL := :NEW.OUT_O_7_VOL;
    v_new.OUT_O_7_MAS := :NEW.OUT_O_7_MAS;
    v_new.LAST_DAY := :NEW.LAST_DAY;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_DISP_AZS_MANUAL.nextval INTO v_new.ID FROM DUAL;
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
    :NEW.OSUSER := v_new.OSUSER;
    :NEW.TERMINAL := v_new.TERMINAL;
    :NEW.ORG_STRU_ID := v_new.ORG_STRU_ID;
    :NEW.PROD_ID_NPR := v_new.PROD_ID_NPR;
    :NEW.OUT_O_VOL := v_new.OUT_O_VOL;
    :NEW.OUT_O_MAS := v_new.OUT_O_MAS;
    :NEW.END_VOLUME := v_new.END_VOLUME;
    :NEW.END_MASSA := v_new.END_MASSA;
    :NEW.OUT_O_1_VOL := v_new.OUT_O_1_VOL;
    :NEW.OUT_O_1_MAS := v_new.OUT_O_1_MAS;
    :NEW.OUT_O_2_VOL := v_new.OUT_O_2_VOL;
    :NEW.OUT_O_2_MAS := v_new.OUT_O_2_MAS;
    :NEW.OUT_O_3_VOL := v_new.OUT_O_3_VOL;
    :NEW.OUT_O_3_MAS := v_new.OUT_O_3_MAS;
    :NEW.OUT_O_4_VOL := v_new.OUT_O_4_VOL;
    :NEW.OUT_O_4_MAS := v_new.OUT_O_4_MAS;
    :NEW.OUT_O_5_VOL := v_new.OUT_O_5_VOL;
    :NEW.OUT_O_5_MAS := v_new.OUT_O_5_MAS;
    :NEW.OUT_O_6_VOL := v_new.OUT_O_6_VOL;
    :NEW.OUT_O_6_MAS := v_new.OUT_O_6_MAS;
    :NEW.OUT_O_7_VOL := v_new.OUT_O_7_VOL;
    :NEW.OUT_O_7_MAS := v_new.OUT_O_7_MAS;
    :NEW.LAST_DAY := v_new.LAST_DAY;
  END IF;
END;
/


