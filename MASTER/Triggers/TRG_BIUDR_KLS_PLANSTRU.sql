--
-- TRG_BIUDR_KLS_PLANSTRU  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_KLS_PLANSTRU
BEFORE INSERT OR DELETE OR UPDATE OF ID, KOD_PGR, KOD_RZD, KOD_SPG, LEVEL_POS, BEGIN_DATE, NAZN_OTG_ID, INPUT_DATE, PARENT_ID, END_DATE, KOD_SGR, KOD_PRZ, NAME, KOD_GRP
ON MASTER.KLS_PLANSTRU
FOR EACH ROW
DECLARE
  v_old KLS_PLANSTRU%ROWTYPE;
  v_new KLS_PLANSTRU%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.BEGIN_DATE := :OLD.BEGIN_DATE;
    v_old.END_DATE := :OLD.END_DATE;
    v_old.NAME := :OLD.NAME;
    v_old.LEVEL_POS := :OLD.LEVEL_POS;
    v_old.INPUT_DATE := :OLD.INPUT_DATE;
    v_old.KOD_SGR := :OLD.KOD_SGR;
    v_old.KOD_SPG := :OLD.KOD_SPG;
    v_old.KOD_RZD := :OLD.KOD_RZD;
    v_old.KOD_PRZ := :OLD.KOD_PRZ;
    v_old.KOD_GRP := :OLD.KOD_GRP;
    v_old.KOD_PGR := :OLD.KOD_PGR;
    v_old.PARENT_ID := :OLD.PARENT_ID;
    v_old.NAZN_OTG_ID := :OLD.NAZN_OTG_ID;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.BEGIN_DATE := :NEW.BEGIN_DATE;
    v_new.END_DATE := :NEW.END_DATE;
    v_new.NAME := :NEW.NAME;
    v_new.LEVEL_POS := :NEW.LEVEL_POS;
    v_new.INPUT_DATE := :NEW.INPUT_DATE;
    v_new.KOD_SGR := :NEW.KOD_SGR;
    v_new.KOD_SPG := :NEW.KOD_SPG;
    v_new.KOD_RZD := :NEW.KOD_RZD;
    v_new.KOD_PRZ := :NEW.KOD_PRZ;
    v_new.KOD_GRP := :NEW.KOD_GRP;
    v_new.KOD_PGR := :NEW.KOD_PGR;
    v_new.PARENT_ID := :NEW.PARENT_ID;
    v_new.NAZN_OTG_ID := :NEW.NAZN_OTG_ID;

    -- Уникальный ID
    IF v_new.ID=0 OR v_new.ID IS NULL THEN
      SELECT SEQ_PLANSTRU.NEXTVAL INTO v_new.ID FROM DUAL;
    END IF;

    -- Проверка новых значений

    -- Поиск в теневой таблице
    BEGIN
      SELECT NULL
      INTO v_tmp
      FROM MASTER_SHADOW.KLS_PLANSTRU_SHADOW
      WHERE ID<>v_new.ID
        AND BEGIN_DATE=v_new.BEGIN_DATE
        AND END_DATE=v_new.END_DATE
        AND NAME=v_new.NAME
        AND LEVEL_POS=v_new.LEVEL_POS
        AND INPUT_DATE=v_new.INPUT_DATE
        AND KOD_SGR=v_new.KOD_SGR
        AND KOD_SPG=v_new.KOD_SPG
        AND KOD_RZD=v_new.KOD_RZD
        AND KOD_PRZ=v_new.KOD_PRZ
        AND KOD_GRP=v_new.KOD_GRP
        AND KOD_PGR=v_new.KOD_PGR
        AND PARENT_ID=v_new.PARENT_ID
        AND NAZN_OTG_ID=v_new.NAZN_OTG_ID;
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
    :NEW.BEGIN_DATE := v_new.BEGIN_DATE;
    :NEW.END_DATE := v_new.END_DATE;
    :NEW.NAME := v_new.NAME;
    :NEW.LEVEL_POS := v_new.LEVEL_POS;
    :NEW.INPUT_DATE := v_new.INPUT_DATE;
    :NEW.KOD_SGR := v_new.KOD_SGR;
    :NEW.KOD_SPG := v_new.KOD_SPG;
    :NEW.KOD_RZD := v_new.KOD_RZD;
    :NEW.KOD_PRZ := v_new.KOD_PRZ;
    :NEW.KOD_GRP := v_new.KOD_GRP;
    :NEW.KOD_PGR := v_new.KOD_PGR;
    :NEW.PARENT_ID := v_new.PARENT_ID;
    :NEW.NAZN_OTG_ID := v_new.NAZN_OTG_ID;
  END IF;
END;
/


