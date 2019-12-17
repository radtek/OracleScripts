--
-- TRG_AIUDR_PLAN_RESU  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_PLAN_RESU
AFTER INSERT OR DELETE OR UPDATE OF ID, OSTAT_UTMSK, SOBSTV_ID, HRAN_UTMSK, PLAN_ID, PROD_ID_NPR, PLAN_UTMSK, REFINER_ID, PLAN_PER_ID
ON MASTER.PLAN_RESU
FOR EACH ROW
DECLARE
  v_old PLAN_RESU%ROWTYPE;
  v_new PLAN_RESU%ROWTYPE;
  v_tmp NUMBER;
  v_num_izm NUMBER;
  v_per_id NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.PLAN_UTMSK := :OLD.PLAN_UTMSK;
    v_old.HRAN_UTMSK := :OLD.HRAN_UTMSK;
    v_old.OSTAT_UTMSK := :OLD.OSTAT_UTMSK;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.PLAN_ID := :OLD.PLAN_ID;
    v_old.PLAN_PER_ID := :OLD.PLAN_PER_ID;
    v_old.SOBSTV_ID := :OLD.SOBSTV_ID;
    v_old.REFINER_ID := :OLD.REFINER_ID;
  END IF;

  IF DELETING() THEN
	v_per_id := :OLD.PLAN_PER_ID;
  ELSE
	v_per_id := :NEW.PLAN_PER_ID;
  END IF;

  -- Определение номера текущего изменения плана
  BEGIN
    SELECT NUM_IZM_RESU
      INTO v_num_izm
      FROM PLAN_PERIODS
      WHERE ID=v_per_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(FOR_SCRIPTS.SG$NO_ROW, 'Плановый период не открыт');
	  v_num_izm := 0;
  END;

  -- После удаления
  IF DELETING() THEN
    NULL;
    -- Удаление из теневой таблицы
--    DELETE FROM PLAN_RESU_HIST WHERE ID=v_old.ID AND NUM_IZM=v_num_izm;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.PLAN_UTMSK := :NEW.PLAN_UTMSK;
    v_new.HRAN_UTMSK := :NEW.HRAN_UTMSK;
    v_new.OSTAT_UTMSK := :NEW.OSTAT_UTMSK;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.PLAN_ID := :NEW.PLAN_ID;
    v_new.PLAN_PER_ID := :NEW.PLAN_PER_ID;
    v_new.SOBSTV_ID := :NEW.SOBSTV_ID;
    v_new.REFINER_ID := :NEW.REFINER_ID;

    -- Обновление теневой таблицы
--    UPDATE PLAN_RESU_HIST SET
--      (ID,PLAN_UTMSK,HRAN_UTMSK,OSTAT_UTMSK,PROD_ID_NPR,PLAN_ID,PLAN_PER_ID,SOBSTV_ID,REFINER_ID)=
--      (SELECT v_new.ID,v_new.PLAN_UTMSK,v_new.HRAN_UTMSK,v_new.OSTAT_UTMSK,v_new.PROD_ID_NPR,v_new.PLAN_ID,v_new.PLAN_PER_ID,v_new.SOBSTV_ID,v_new.REFINER_ID FROM dual)
--      WHERE ID=v_old.ID AND NUM_IZM=v_num_izm;

--    IF SQL%NOTFOUND THEN
--      INSERT INTO PLAN_RESU_HIST
--        (ID,NUM_IZM,PLAN_UTMSK,HRAN_UTMSK,OSTAT_UTMSK,PROD_ID_NPR,PLAN_ID,PLAN_PER_ID,SOBSTV_ID,REFINER_ID)
--        VALUES
--        (v_new.ID,v_num_izm,v_new.PLAN_UTMSK,v_new.HRAN_UTMSK,v_new.OSTAT_UTMSK,v_new.PROD_ID_NPR,v_new.PLAN_ID,v_new.PLAN_PER_ID,v_new.SOBSTV_ID,v_new.REFINER_ID);
--    END IF;

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


