--
-- TRG_AIUDR_KLS_PLAN_KIND  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_KLS_PLAN_KIND
AFTER INSERT OR DELETE OR UPDATE OF ID, NAME
ON MASTER.KLS_PLAN_KIND
FOR EACH ROW
DECLARE
  v_old KLS_PLAN_KIND%ROWTYPE;
  v_new KLS_PLAN_KIND%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.NAME := :OLD.NAME;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
    -- Удаление из теневой таблицы
    DELETE FROM MASTER_SHADOW.KLS_PLAN_KIND_SHADOW
     WHERE ID=v_old.ID;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.NAME := :NEW.NAME;

    -- Обновление теневой таблицы
    UPDATE MASTER_SHADOW.KLS_PLAN_KIND_SHADOW SET
      (ID,NAME)=
      (SELECT v_new.ID,v_new.NAME FROM dual)
      WHERE ID=v_old.ID;

    IF SQL%NOTFOUND THEN
      INSERT INTO MASTER_SHADOW.KLS_PLAN_KIND_SHADOW
        (ID,NAME)
        VALUES
        (v_new.ID,v_new.NAME);
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


