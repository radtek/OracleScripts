--
-- TRG_BIUDR_KLS_PR_KONS_GRP_DESC  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_KLS_PR_KONS_GRP_DESC
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.KLS_PROD_KONS_GROUPS_DESC
FOR EACH ROW
DECLARE
  v_old KLS_PROD_KONS_GROUPS_DESC%ROWTYPE;
  v_new KLS_PROD_KONS_GROUPS_DESC%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.PROD_KONS_ID := :OLD.PROD_KONS_ID;
    v_old.PROD_GROUPS_ID := :OLD.PROD_GROUPS_ID;
    v_old.IS_AUTO_LINK := :OLD.IS_AUTO_LINK;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.PROD_KONS_ID := :NEW.PROD_KONS_ID;
    v_new.PROD_GROUPS_ID := :NEW.PROD_GROUPS_ID;
    v_new.IS_AUTO_LINK := :NEW.IS_AUTO_LINK;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_KLS_PROD_KONS_GROUPS_DESC.nextval INTO v_new.ID FROM DUAL;
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
    :NEW.PROD_KONS_ID := v_new.PROD_KONS_ID;
    :NEW.PROD_GROUPS_ID := v_new.PROD_GROUPS_ID;
    :NEW.IS_AUTO_LINK := v_new.IS_AUTO_LINK;
  END IF;
END;
/


