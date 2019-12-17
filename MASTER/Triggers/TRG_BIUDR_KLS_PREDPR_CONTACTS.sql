--
-- TRG_BIUDR_KLS_PREDPR_CONTACTS  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_KLS_PREDPR_CONTACTS
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.KLS_PREDPR_CONTACTS
FOR EACH ROW
DECLARE
  v_old KLS_PREDPR_CONTACTS%ROWTYPE;
  v_new KLS_PREDPR_CONTACTS%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.PREDPR_ID := :OLD.PREDPR_ID;
    v_old.IS_BOSS := :OLD.IS_BOSS;
    v_old.LASTNAME := :OLD.LASTNAME;
    v_old.SHORTNAME := :OLD.SHORTNAME;
    v_old.FIRSTNAME := :OLD.FIRSTNAME;
    v_old.MIDDLENAME := :OLD.MIDDLENAME;
    v_old.LASTNAME1 := :OLD.LASTNAME1;
    v_old.FIRSTNAME1 := :OLD.FIRSTNAME1;
    v_old.MIDDLENAME1 := :OLD.MIDDLENAME1;
    v_old.LASTNAME2 := :OLD.LASTNAME2;
    v_old.FIRSTNAME2 := :OLD.FIRSTNAME2;
    v_old.MIDDLENAME2 := :OLD.MIDDLENAME2;
    v_old.PHONE := :OLD.PHONE;
    v_old.STAFF := :OLD.STAFF;
    v_old.STAFF1 := :OLD.STAFF1;
    v_old.STAFF2 := :OLD.STAFF2;
    v_old.SEX := :OLD.SEX;
    v_old.NA_OSNOV := :OLD.NA_OSNOV;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.PREDPR_ID := :NEW.PREDPR_ID;
    v_new.IS_BOSS := :NEW.IS_BOSS;
    v_new.LASTNAME := :NEW.LASTNAME;
    v_new.SHORTNAME := :NEW.SHORTNAME;
    v_new.FIRSTNAME := :NEW.FIRSTNAME;
    v_new.MIDDLENAME := :NEW.MIDDLENAME;
    v_new.LASTNAME1 := :NEW.LASTNAME1;
    v_new.FIRSTNAME1 := :NEW.FIRSTNAME1;
    v_new.MIDDLENAME1 := :NEW.MIDDLENAME1;
    v_new.LASTNAME2 := :NEW.LASTNAME2;
    v_new.FIRSTNAME2 := :NEW.FIRSTNAME2;
    v_new.MIDDLENAME2 := :NEW.MIDDLENAME2;
    v_new.PHONE := :NEW.PHONE;
    v_new.STAFF := :NEW.STAFF;
    v_new.STAFF1 := :NEW.STAFF1;
    v_new.STAFF2 := :NEW.STAFF2;
    v_new.SEX := :NEW.SEX;
    v_new.NA_OSNOV := :NEW.NA_OSNOV;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_KLS_PREDPR_CONTACTS.NEXTVAL INTO v_new.ID FROM DUAL;
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
    :NEW.PREDPR_ID := v_new.PREDPR_ID;
    :NEW.IS_BOSS := v_new.IS_BOSS;
    :NEW.LASTNAME := v_new.LASTNAME;
    :NEW.SHORTNAME := v_new.SHORTNAME;
    :NEW.FIRSTNAME := v_new.FIRSTNAME;
    :NEW.MIDDLENAME := v_new.MIDDLENAME;
    :NEW.LASTNAME1 := v_new.LASTNAME1;
    :NEW.FIRSTNAME1 := v_new.FIRSTNAME1;
    :NEW.MIDDLENAME1 := v_new.MIDDLENAME1;
    :NEW.LASTNAME2 := v_new.LASTNAME2;
    :NEW.FIRSTNAME2 := v_new.FIRSTNAME2;
    :NEW.MIDDLENAME2 := v_new.MIDDLENAME2;
    :NEW.PHONE := v_new.PHONE;
    :NEW.STAFF := v_new.STAFF;
    :NEW.STAFF1 := v_new.STAFF1;
    :NEW.STAFF2 := v_new.STAFF2;
    :NEW.SEX := v_new.SEX;
    :NEW.NA_OSNOV := v_new.NA_OSNOV;
  END IF;
END;
/


