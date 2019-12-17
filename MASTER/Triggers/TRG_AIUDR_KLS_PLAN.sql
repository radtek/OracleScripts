--
-- TRG_AIUDR_KLS_PLAN  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_KLS_PLAN
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.KLS_PLAN
FOR EACH ROW
DECLARE
  v_old KLS_PLAN%ROWTYPE;
  v_new KLS_PLAN%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.PLAN_NAME := :OLD.PLAN_NAME;
    v_old.PLAN_KIND_ID := :OLD.PLAN_KIND_ID;
    v_old.BROTHER_ID := :OLD.BROTHER_ID;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
    -- Удаление из теневой таблицы
    DELETE FROM MASTER_SHADOW.KLS_PLAN_SHADOW
     WHERE ID=v_old.ID;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.PLAN_NAME := :NEW.PLAN_NAME;
    v_new.PLAN_KIND_ID := :NEW.PLAN_KIND_ID;
    v_new.BROTHER_ID := :NEW.BROTHER_ID;

    -- Обновление теневой таблицы
    UPDATE MASTER_SHADOW.KLS_PLAN_SHADOW SET
      (ID,PLAN_NAME,PLAN_KIND_ID,BROTHER_ID)=
      (SELECT v_new.ID,v_new.PLAN_NAME,v_new.PLAN_KIND_ID,v_new.BROTHER_ID FROM dual)
      WHERE ID=v_old.ID;

    IF SQL%NOTFOUND THEN
      INSERT INTO MASTER_SHADOW.KLS_PLAN_SHADOW
        (ID,PLAN_NAME,PLAN_KIND_ID,BROTHER_ID)
        VALUES
        (v_new.ID,v_new.PLAN_NAME,v_new.PLAN_KIND_ID,v_new.BROTHER_ID);
    END IF;

    -- После обновления
    IF UPDATING() THEN
      NULL;
    END IF;

    -- После добавления
    IF INSERTING() THEN
      NULL;
    END IF;

  END IF;
END;
/


