--
-- TRG_BIUDR_KLS_PLAN_KIND  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_KLS_PLAN_KIND
BEFORE INSERT OR DELETE OR UPDATE OF ID, NAME
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

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.NAME := :NEW.NAME;

    -- Уникальный ID
    IF v_new.ID=0 OR v_new.ID IS NULL THEN
      SELECT SEQ_PLAN_KIND.NEXTVAL INTO v_new.ID FROM DUAL;
    END IF;

    -- Проверка новых значений

    -- Поиск в теневой таблице
    BEGIN
      SELECT NULL
      INTO v_tmp
      FROM MASTER_SHADOW.KLS_PLAN_KIND_SHADOW
      WHERE ID<>v_new.ID
        AND NAME=v_new.NAME;
      RAISE_APPLICATION_ERROR(For_Scripts.SG$ROW_EXIST, 'Данная запись уже есть в таблице');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
      WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(For_Scripts.SG$ROW_EXIST, 'Данная запись уже есть в таблице');
    END;

    -- До обновления
    IF UPDATING() THEN
      NULL;
      IF v_old.ID<>v_new.ID THEN
        RAISE_APPLICATION_ERROR(For_Scripts.SG$PK_CHANGE, 'Нельзя менять PRIMARY KEY');
      END IF;
    END IF;

    -- До добавления
    IF INSERTING() THEN
      NULL;
    END IF;

    -- Сохранение новых значений
    :NEW.ID := v_new.ID;
    :NEW.NAME := v_new.NAME;
  END IF;
END;
/


