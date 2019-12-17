--
-- TRG_BIUDR_KLS_PREDPR_AKCIZ  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_KLS_PREDPR_AKCIZ
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.KLS_PREDPR_AKCIZ
FOR EACH ROW
DECLARE
  v_old KLS_PREDPR_AKCIZ%ROWTYPE;
  v_new KLS_PREDPR_AKCIZ%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.PLAT_ID := :OLD.PLAT_ID;
    v_old.DATE_BEG := :OLD.DATE_BEG;
    v_old.DATE_END := :OLD.DATE_END;
	v_old.IS_OPT := :OLD.IS_OPT;
	v_old.IS_ROZN := :OLD.IS_ROZN;
	v_old.NAPR_POST_ID := :OLD.NAPR_POST_ID;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.PLAT_ID := :NEW.PLAT_ID;
    v_new.DATE_BEG := :NEW.DATE_BEG;
    v_new.DATE_END := :NEW.DATE_END;
	v_new.IS_OPT := :NEW.IS_OPT;
	v_new.IS_ROZN := :NEW.IS_ROZN;
	v_new.NAPR_POST_ID := :NEW.NAPR_POST_ID;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_KLS_PREDPR_AKCIZ.NEXTVAL INTO v_new.ID FROM DUAL;
      END IF;
      -- Проверка новых значений
      NULL;
    END IF;

    IF v_new.IS_OPT=0 AND v_new.IS_ROZN=0 THEN
	  v_new.NAPR_POST_ID:=2;
    END IF;
    IF v_new.IS_OPT=1 AND v_new.IS_ROZN=0 THEN
	  v_new.NAPR_POST_ID:=6;
    END IF;
    IF v_new.IS_OPT=0 AND v_new.IS_ROZN=1 THEN
	  v_new.NAPR_POST_ID:=8;
    END IF;
    IF v_new.IS_OPT=1 AND v_new.IS_ROZN=1 THEN
	  v_new.NAPR_POST_ID:=1;
    END IF;

    -- Сохранение новых значений
    :NEW.ID := v_new.ID;
    :NEW.PLAT_ID := v_new.PLAT_ID;
    :NEW.DATE_BEG := v_new.DATE_BEG;
    :NEW.DATE_END := v_new.DATE_END;
	:NEW.IS_OPT := v_new.IS_OPT;
	:NEW.IS_ROZN := v_new.IS_ROZN;
	:NEW.NAPR_POST_ID := v_new.NAPR_POST_ID;
  END IF;
END;
/


