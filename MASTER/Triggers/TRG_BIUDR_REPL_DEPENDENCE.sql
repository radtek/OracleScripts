--
-- TRG_BIUDR_REPL_DEPENDENCE  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_REPL_DEPENDENCE
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.REPL_DEPENDENCE
FOR EACH ROW
DECLARE
  v_new REPL_DEPENDENCE%ROWTYPE;
  v_tmp NUMBER;
BEGIN
  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_REPL_DEPENDENCE.nextval INTO v_new.ID FROM DUAL;
      END IF;
      -- Проверка новых значений
      NULL;
    END IF;

    -- Сохранение новых значений
    :NEW.ID := v_new.ID;
  END IF;
END;
/


