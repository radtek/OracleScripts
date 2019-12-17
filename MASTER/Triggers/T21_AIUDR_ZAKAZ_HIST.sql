--
-- T21_AIUDR_ZAKAZ_HIST  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.T21_AIUDR_ZAKAZ_HIST
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.ZAKAZ_HIST FOR EACH ROW
DECLARE
  vId NUMBER;
  TABLE_MUTATING    exception;
  NO_STATEMENT_PARSED	exception;
  pragma exception_init( TABLE_MUTATING,-04091 );
  pragma exception_init( NO_STATEMENT_PARSED,-01003 );
  v_old ZAKAZ_HIST%ROWTYPE;
  v_new ZAKAZ_HIST%ROWTYPE;
  vSTATUS_ZAKAZ_ID NUMBER;
  vZAKAZ_ID NUMBER;
  vSTAN_ID NUMBER;
BEGIN

  IF INSERTING() THEN
    vID:=:NEW.ID;
    vSTATUS_ZAKAZ_ID:=:NEW.STATUS_ZAKAZ_ID;
    vZAKAZ_ID:=:NEW.ZAKAZ_ID;
    v_old.NOM_ZD:='';
    v_new.NOM_ZD:=:NEW.NOM_ZD;
	v_old.FACT_VES:=0;
	v_new.FACT_VES:=:NEW.FACT_VES;
	v_old.FACT_KOL:=0;
	v_new.FACT_KOL:=:NEW.FACT_KOL;
	v_old.VES:=0;
	v_new.VES:=:NEW.VES;
	v_old.KOL:=0;
	v_new.KOL:=:NEW.KOL;
	v_old.SPEED_VES:=0;
	v_new.SPEED_VES:=:NEW.SPEED_VES;
	v_old.SPEED_KOL:=0;
	v_new.SPEED_KOL:=:NEW.SPEED_KOL;
	v_old.LOAD_VES:=0;
	v_new.LOAD_VES:=:NEW.LOAD_VES;
	v_old.LOAD_KOL:=0;
	v_new.LOAD_KOL:=:NEW.LOAD_KOL;
	v_old.KOD_ISU:='';
	v_new.KOD_ISU:=:NEW.KOD_ISU;
    IF v_new.KOD_ISU||' '=' ' THEN
      -- считаем код из таблицы ZAKAZ_HIST_ISU
      BEGIN
		SELECT KOD_ISU INTO v_new.KOD_ISU
		  FROM ZAKAZ_HIST_ISU WHERE ZAKAZ_HIST_ID=vID;
	  EXCEPTION
	    WHEN OTHERS THEN
	      v_new.KOD_ISU:='';
	  END;
    END IF; 
  END IF;

  IF UPDATING() THEN
    vID:=:NEW.ID;
    vSTATUS_ZAKAZ_ID:=:NEW.STATUS_ZAKAZ_ID;
    vZAKAZ_ID:=:NEW.ZAKAZ_ID;
    v_old.NOM_ZD:=:OLD.NOM_ZD;
    v_new.NOM_ZD:=:NEW.NOM_ZD;
	v_old.FACT_VES:=:OLD.FACT_VES;
	v_new.FACT_VES:=:NEW.FACT_VES;
	v_old.FACT_KOL:=:OLD.FACT_KOL;
	v_new.FACT_KOL:=:NEW.FACT_KOL;
	v_old.VES:=:OLD.VES;
	v_new.VES:=:NEW.VES;
	v_old.KOL:=:OLD.KOL;
	v_new.KOL:=:NEW.KOL;
	v_old.SPEED_VES:=:OLD.SPEED_VES;
	v_new.SPEED_VES:=:NEW.SPEED_VES;
	v_old.SPEED_KOL:=:OLD.SPEED_KOL;
	v_new.SPEED_KOL:=:NEW.SPEED_KOL;
	v_old.LOAD_VES:=:OLD.LOAD_VES;
	v_new.LOAD_VES:=:NEW.LOAD_VES;
	v_old.LOAD_KOL:=:OLD.LOAD_KOL;
	v_new.LOAD_KOL:=:NEW.LOAD_KOL;
  	v_old.KOD_ISU:=:OLD.KOD_ISU;
	v_new.KOD_ISU:=:NEW.KOD_ISU;
  END IF;

  IF DELETING() THEN
    vID:=:OLD.ID;
    vSTATUS_ZAKAZ_ID:=:OLD.STATUS_ZAKAZ_ID;
    vZAKAZ_ID:=:OLD.ZAKAZ_ID;
    v_old.NOM_ZD:=:OLD.NOM_ZD;
    v_new.NOM_ZD:='';
	v_old.FACT_VES:=:OLD.FACT_VES;
	v_new.FACT_VES:=0;
	v_old.FACT_KOL:=:OLD.FACT_KOL;
	v_new.FACT_KOL:=0;
	v_old.VES:=:OLD.VES;
	v_new.VES:=0;
	v_old.KOL:=:OLD.KOL;
	v_new.KOL:=0;
	v_old.SPEED_VES:=:OLD.SPEED_VES;
	v_new.SPEED_VES:=0;
	v_old.SPEED_KOL:=:OLD.SPEED_KOL;
	v_new.SPEED_KOL:=0;
	v_old.LOAD_VES:=:OLD.LOAD_VES;
	v_new.LOAD_VES:=0;
	v_old.LOAD_KOL:=:OLD.LOAD_KOL;
	v_new.LOAD_KOL:=0;
  	v_old.KOD_ISU:=:OLD.KOD_ISU;
	v_new.KOD_ISU:=:OLD.KOD_ISU; -- так надо, чтобы код не удалился
  END IF;

  /* обработка мутаций при попытке обращения к таблице ZAKAZ */
  BEGIN
    -- "К отгрузке"
    IF vSTATUS_ZAKAZ_ID=20 THEN
      IF v_NEW.NOM_ZD||' '<>v_old.NOM_ZD||' ' THEN
	    -- Изменился № разнарядки - заменить в списке разнарядок заявки
  	    UPDATE ZAKAZ SET NOM_ZD_LIST=FOR_ZAKAZ.CHANGE_NOM_ZD(NOM_ZD_LIST,v_old.NOM_ZD,v_NEW.NOM_ZD)
		    WHERE ID=vZAKAZ_ID;
      END IF;
	  IF v_NEW.LOAD_KOL<>v_old.LOAD_KOL OR v_NEW.LOAD_VES<>v_old.LOAD_VES THEN
	    -- Изменился объем к отгрузке
  	    UPDATE ZAKAZ SET LOAD_KOL=LOAD_KOL+v_NEW.LOAD_KOL-v_old.LOAD_KOL,
		                 LOAD_VES=LOAD_VES+v_NEW.LOAD_VES-v_old.LOAD_VES
		    WHERE ID=vZAKAZ_ID;
	  END IF;
	  IF v_NEW.FACT_KOL<>v_old.FACT_KOL OR v_NEW.FACT_VES<>v_old.FACT_VES THEN
	    -- Изменился отгруженный объем
  	    UPDATE ZAKAZ SET FACT_KOL=FACT_KOL+v_NEW.FACT_KOL-v_old.FACT_KOL,
		                 FACT_VES=FACT_VES+v_NEW.FACT_VES-v_old.FACT_VES
		    WHERE ID=vZAKAZ_ID;
	  END IF;
	END IF;

    -- "Переадресация"
    IF vSTATUS_ZAKAZ_ID=40 OR vSTATUS_ZAKAZ_ID=41  OR vSTATUS_ZAKAZ_ID=42 THEN
	  IF UPDATING() OR INSERTING() THEN
  	    IF v_NEW.KOL<>v_old.KOL OR v_NEW.VES<>v_old.VES THEN
	      -- Изменился объем по заявке
  	      UPDATE ZAKAZ SET KOL=KOL+v_NEW.KOL-v_old.KOL,
		                 VES=VES+v_NEW.VES-v_old.VES
		    WHERE ID=vZAKAZ_ID;
	    END IF;
	    IF v_NEW.SPEED_KOL<>v_old.SPEED_KOL OR v_NEW.SPEED_VES<>v_old.SPEED_VES THEN
	      -- Изменился объем по заявке
  	      UPDATE ZAKAZ SET SPEED_KOL=SPEED_KOL+v_NEW.SPEED_KOL-v_old.SPEED_KOL,
		                 SPEED_VES=SPEED_VES+v_NEW.SPEED_VES-v_old.SPEED_VES
		    WHERE ID=vZAKAZ_ID;
	    END IF;
  	    IF v_NEW.VES=0 THEN
  	      -- Меняем станцию на новую только в том случае, когда
		  -- происходит переадресация всего заказа
  	      UPDATE ZAKAZ SET STAN_ID=:NEW.STAN_ID WHERE ID=vZAKAZ_ID;
		END IF;
	  ELSE
	    -- При удалении - Возвращаем предыдущую
		BEGIN
		  -- Проверяем на соответствие
		  SELECT STAN_ID INTO vSTAN_ID
		    FROM ZAKAZ WHERE ID=vZAKAZ_ID;
		EXCEPTION
		  WHEN OTHERS THEN
		    vSTAN_ID:=NULL;
		END;
		IF NVL(vSTAN_ID,0)<>0 THEN -- В заказе указана станция
		  IF NVL(vSTAN_ID,0)=NVL(:OLD.STAN_ID,0) THEN	-- Удаляется переадресация на текущую станцию
		    -- Возвращаем станцию до переадресации
  	        UPDATE ZAKAZ SET STAN_ID=:OLD.OLD_STAN_ID WHERE ID=vZAKAZ_ID;
		  END IF;
		END IF;
	  END IF;
	END IF;

    -- "Отказ"
    IF vSTATUS_ZAKAZ_ID=50 THEN
	  IF v_NEW.KOL<>v_old.KOL OR v_NEW.VES<>v_old.VES THEN
	    -- Изменился объем по заявке
  	    UPDATE ZAKAZ SET KOL=KOL+v_NEW.KOL-v_old.KOL,
		                 VES=VES+v_NEW.VES-v_old.VES
		    WHERE ID=vZAKAZ_ID;
	  END IF;
	  IF v_NEW.SPEED_KOL<>v_old.SPEED_KOL OR v_NEW.SPEED_VES<>v_old.SPEED_VES THEN
	    -- Изменился объем по заявке
  	    UPDATE ZAKAZ SET SPEED_KOL=SPEED_KOL+v_NEW.SPEED_KOL-v_old.SPEED_KOL,
		                 SPEED_VES=SPEED_VES+v_NEW.SPEED_VES-v_old.SPEED_VES
		    WHERE ID=vZAKAZ_ID;
	  END IF;
	END IF;

  exception
    when TABLE_MUTATING or NO_STATEMENT_PARSED then null;
  end;
 

  IF INSERTING() OR UPDATING() THEN
    /* обработка мутаций при попытке обращения к таблице MONTH */
    BEGIN
      --UPDATE MONTH SET zakaz_kod_isu=v_new.KOD_ISU where month.zakaz_hist_id=vID;
      null;
    exception
      when TABLE_MUTATING or NO_STATEMENT_PARSED then null;
    end;

    UPDATE ZAKAZ_HIST_ISU SET KOD_ISU=v_new.KOD_ISU WHERE ZAKAZ_HIST_ID=vID;
    IF SQL%NOTFOUND THEN
      INSERT INTO ZAKAZ_HIST_ISU (ZAKAZ_HIST_ID,KOD_ISU) VALUES (vID,v_new.KOD_ISU);
    END IF;
  END IF;
  
END;
/


