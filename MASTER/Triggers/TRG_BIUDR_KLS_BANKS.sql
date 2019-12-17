--
-- TRG_BIUDR_KLS_BANKS  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_KLS_BANKS
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.KLS_BANKS
FOR EACH ROW
DECLARE
  v_old KLS_BANKS%ROWTYPE;
  v_new KLS_BANKS%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.KORS := :OLD.KORS;
    v_old.BIK := :OLD.BIK;
    v_old.BANK_NAME := :OLD.BANK_NAME;
    v_old.POSTINDEX := :OLD.POSTINDEX;
    v_old.ADDRESS := :OLD.ADDRESS;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.KORS := :NEW.KORS;
    v_new.BIK := :NEW.BIK;
    v_new.BANK_NAME := :NEW.BANK_NAME;
    v_new.POSTINDEX := :NEW.POSTINDEX;
    v_new.ADDRESS := :NEW.ADDRESS;

    IF INSERTING() THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_KLS_BANKS.NEXTVAL INTO v_new.ID FROM DUAL;
      END IF;
      -- Проверка новых значений
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

	UPDATE KLS_BANK SET (BANK_NAME, ADDRESS, BIK, POSTINDEX)=
  	  (SELECT v_new.BANK_NAME, v_new.ADDRESS, v_new.BIK, v_new.POSTINDEX FROM dual)
	  WHERE KLS_BANK.KORS=v_new.KORS;

	IF SQL%NOTFOUND THEN
	  INSERT INTO KLS_BANK (KORS, BANK_NAME, ADDRESS, BIK, POSTINDEX)
  	    VALUES (v_new.KORS, v_new.BANK_NAME, v_new.ADDRESS, v_new.BIK, v_new.POSTINDEX);
	END IF;

    -- Сохранение новых значений
    :NEW.ID := v_new.ID;
    :NEW.KORS := v_new.KORS;
    :NEW.BIK := v_new.BIK;
    :NEW.BANK_NAME := v_new.BANK_NAME;
    :NEW.POSTINDEX := v_new.POSTINDEX;
    :NEW.ADDRESS := v_new.ADDRESS;
  END IF;
END;
/


