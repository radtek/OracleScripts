--
-- TRG_BIUDR_KLS_PLAN  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_KLS_PLAN
BEFORE INSERT OR DELETE OR UPDATE
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

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.PLAN_NAME := :NEW.PLAN_NAME;
    v_new.PLAN_KIND_ID := :NEW.PLAN_KIND_ID;
    v_new.BROTHER_ID := :NEW.BROTHER_ID;

    -- Уникальный ID
    IF v_new.ID=0 OR v_new.ID IS NULL THEN
      SELECT SEQ_PLAN.NEXTVAL INTO v_new.ID FROM DUAL;
    END IF;

    -- Проверка новых значений

    -- Поиск в теневой таблице
    BEGIN
      SELECT NULL
      INTO v_tmp
      FROM MASTER_SHADOW.KLS_PLAN_SHADOW
      WHERE ID<>v_new.ID
        AND PLAN_NAME=v_new.PLAN_NAME
        AND PLAN_KIND_ID=v_new.PLAN_KIND_ID;
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
    :NEW.PLAN_NAME := v_new.PLAN_NAME;
    :NEW.PLAN_KIND_ID := v_new.PLAN_KIND_ID;
    :NEW.BROTHER_ID := v_new.BROTHER_ID;
  END IF;
END;
/


