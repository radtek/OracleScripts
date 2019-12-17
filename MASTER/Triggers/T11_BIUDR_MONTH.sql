--
-- T11_BIUDR_MONTH  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.T11_BIUDR_MONTH
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER."MONTH"
FOR EACH ROW
DECLARE
  vId NUMBER;
  TABLE_MUTATING    EXCEPTION;
  NO_STATEMENT_PARSED	EXCEPTION;
  PRAGMA EXCEPTION_INIT( TABLE_MUTATING,-04091 );
  PRAGMA EXCEPTION_INIT( NO_STATEMENT_PARSED,-01003 );
  v_old MONTH%ROWTYPE;
  v_new MONTH%ROWTYPE;
  v_zakaz ZAKAZ%ROWTYPE;
  v_zakaz_hist ZAKAZ_HIST%ROWTYPE;
  vNOM_ZD VARCHAR2(12);
  vNEW_NOM_ZD VARCHAR2(12);
BEGIN

  IF INSERTING() THEN
    vNOM_ZD:=:NEW.NOM_ZD;
	v_old.ZAKAZ_ID:=NULL;
	v_new.ZAKAZ_ID:=:NEW.ZAKAZ_ID;
	v_old.ZAKAZ_HIST_ID:=NULL;
	v_new.ZAKAZ_HIST_ID:=:NEW.ZAKAZ_HIST_ID;
	v_old.TONN_DECLARED:=0;
	v_new.TONN_DECLARED:=NVL(:NEW.TONN_DECLARED,0);
	v_old.CIST_DECLARED:=0;
	v_new.CIST_DECLARED:=NVL(:NEW.CIST_DECLARED,0);
	v_old.TONN_LOADED:=0;
	v_new.TONN_LOADED:=NVL(:NEW.TONN_LOADED,0);
	v_old.CIST_LOADED:=0;
	v_new.CIST_LOADED:=NVL(:NEW.CIST_LOADED,0);
    v_new.zakaz_kod_isu:=:new.zakaz_kod_isu;
  END IF;
  IF UPDATING() THEN
    vNOM_ZD:=:NEW.NOM_ZD;
	v_old.ZAKAZ_ID:=:OLD.ZAKAZ_ID;
	v_new.ZAKAZ_ID:=:NEW.ZAKAZ_ID;
	v_old.ZAKAZ_HIST_ID:=:OLD.ZAKAZ_HIST_ID;
	v_new.ZAKAZ_HIST_ID:=:NEW.ZAKAZ_HIST_ID;
	v_old.TONN_DECLARED:=NVL(:OLD.TONN_DECLARED,0);
	v_new.TONN_DECLARED:=NVL(:NEW.TONN_DECLARED,0);
	v_old.CIST_DECLARED:=NVL(:OLD.CIST_DECLARED,0);
	v_new.CIST_DECLARED:=NVL(:NEW.CIST_DECLARED,0);
	v_old.TONN_LOADED:=NVL(:OLD.TONN_LOADED,0);
	v_new.TONN_LOADED:=NVL(:NEW.TONN_LOADED,0);
	v_old.CIST_LOADED:=NVL(:OLD.CIST_LOADED,0);
	v_new.CIST_LOADED:=NVL(:NEW.CIST_LOADED,0);
    v_new.zakaz_kod_isu:=:new.zakaz_kod_isu;
  END IF;
  IF DELETING() THEN
    vNOM_ZD:=:OLD.NOM_ZD;
	v_old.ZAKAZ_ID:=:OLD.ZAKAZ_ID;
	v_new.ZAKAZ_ID:=NULL;
	v_old.ZAKAZ_HIST_ID:=:OLD.ZAKAZ_HIST_ID;
	v_new.ZAKAZ_HIST_ID:=NULL;
	v_old.TONN_DECLARED:=NVL(:OLD.TONN_DECLARED,0);
	v_new.TONN_DECLARED:=0;
	v_old.CIST_DECLARED:=NVL(:OLD.CIST_DECLARED,0);
	v_new.CIST_DECLARED:=0;
	v_old.TONN_LOADED:=NVL(:OLD.TONN_LOADED,0);
	v_new.TONN_LOADED:=0;
	v_old.CIST_LOADED:=NVL(:OLD.CIST_LOADED,0);
	v_new.CIST_LOADED:=0;
    v_new.zakaz_kod_isu:='';
  END IF;

  IF NVL(v_new.ZAKAZ_HIST_ID,0)<=0 THEN
    v_new.ZAKAZ_HIST_ID:=NULL;
  END IF;
  IF NVL(v_new.ZAKAZ_ID,0)<=0 THEN
    v_new.ZAKAZ_ID:=NULL;
    v_new.ZAKAZ_HIST_ID:=NULL;
  END IF;

  /* обработка мутаций при попытке обращения к таблице ZAKAZ_HIST */
  BEGIN
    IF NVL(v_old.ZAKAZ_ID,0)<>NVL(v_new.ZAKAZ_ID,0) OR
	   NVL(v_old.ZAKAZ_HIST_ID,0)<>NVL(v_new.ZAKAZ_HIST_ID,0) OR
	   (NVL(v_new.ZAKAZ_HIST_ID,0)=0 AND NVL(v_new.ZAKAZ_ID,0)<>0) THEN
	  -- Заказ изменился или в заказе не проставлена разнарядка

	  IF NVL(v_old.ZAKAZ_ID,0)<>NVL(v_new.ZAKAZ_ID,0) OR
	     (NVL(v_old.ZAKAZ_HIST_ID,0)<>NVL(v_new.ZAKAZ_HIST_ID,0) AND NVL(v_new.ZAKAZ_HIST_ID,0)<>0) THEN
		-- Заказ сменился - снимаем со старого разнарядку
		For_Zakaz.SetNOM_ZD(0,v_old.ZAKAZ_ID, v_old.ZAKAZ_HIST_ID, vNOM_ZD, '',0,0,0,0);
	  END IF;

	  IF NVL(v_new.ZAKAZ_ID,0)<>0 OR
	     NVL(v_new.ZAKAZ_HIST_ID,0)<>0 THEN
	  	-- Есть новый заказ

  	    IF NVL(v_new.ZAKAZ_ID,0)<>0 THEN
		  -- проверяем заказ
		  BEGIN
		    SELECT * INTO v_zakaz FROM ZAKAZ WHERE ID=v_new.ZAKAZ_ID;
		  EXCEPTION
		    WHEN NO_DATA_FOUND THEN
			  v_new.ZAKAZ_ID:=NULL;
		  END;
		END IF;

  	    IF NVL(v_new.ZAKAZ_ID,0)<>0 THEN
  	      IF NVL(v_new.ZAKAZ_HIST_ID,0)<>0 THEN
		    -- проверяем позицию заказа
		    BEGIN
		      SELECT * INTO v_zakaz_hist FROM ZAKAZ_HIST WHERE ID=v_new.ZAKAZ_HIST_ID AND ZAKAZ_ID=v_new.ZAKAZ_ID;
		    EXCEPTION
		      WHEN NO_DATA_FOUND THEN
			    v_new.ZAKAZ_HIST_ID:=NULL;
		    END;
		  END IF;

  	      IF NVL(v_new.ZAKAZ_HIST_ID,0)<>0 THEN
		    -- есть позиция заказа - вешаем на него разнарядку
		    For_Zakaz.SetNOM_ZD(0,v_new.ZAKAZ_ID, v_new.ZAKAZ_HIST_ID, vNOM_ZD, vNOM_ZD, v_new.TONN_DECLARED, v_new.CIST_DECLARED, v_new.TONN_LOADED, v_new.CIST_LOADED);
		  ELSE
		    -- ищем аналог
	        BEGIN
	          SELECT ID, NOM_ZD INTO v_new.ZAKAZ_HIST_ID, vNEW_NOM_ZD
		        FROM ZAKAZ_HIST
		       WHERE ZAKAZ_ID=v_new.ZAKAZ_ID
		         AND STATUS_ZAKAZ_ID=20
                 --AND IS_AUTO_MONTH=1 -- 26/12/2007 PSV 
		         AND IS_AUTO=0
		         AND (NOM_ZD IS NULL or NOM_ZD=vNOM_ZD)
		         AND PROD_ID_NPR=:NEW.PROD_ID_NPR
		         AND STAN_ID=:NEW.STAN_ID
		         AND POLUCH_ID=:NEW.POLUCH_ID
		         AND LOAD_VES=v_new.TONN_DECLARED
 		         AND ROWNUM=1;
	        EXCEPTION
	          WHEN NO_DATA_FOUND THEN
		        v_new.ZAKAZ_HIST_ID:=NULL;
	        END;
            
	        IF vNEW_NOM_ZD||' '=' ' THEN
		      -- в найденном заказе разнарядка не указана - снимаем разнарядку со старого заказа 
		      For_Zakaz.SetNOM_ZD(0,v_old.ZAKAZ_ID, v_old.ZAKAZ_HIST_ID, vNOM_ZD, '',0,0,0,0);
	        END IF;

  	        IF NVL(v_new.ZAKAZ_HIST_ID,0)<>0 THEN
		      -- аналог найден - вешаем на него разнарядку
		      For_Zakaz.SetNOM_ZD(0,v_new.ZAKAZ_ID, v_new.ZAKAZ_HIST_ID, vNOM_ZD, vNOM_ZD, v_new.TONN_DECLARED, v_new.CIST_DECLARED, v_new.TONN_LOADED, v_new.CIST_LOADED);
		    ELSE
			  -- даже аналог не найден - создаем позицию
              v_new.ZAKAZ_HIST_ID:=For_Zakaz.ToLoadZakaz(0, v_new.ZAKAZ_ID, 0, NULL, v_zakaz.INPUT_DATE, :NEW.INPUT_DATE, :NEW.PROD_ID_NPR,
                     :NEW.STAN_ID, :NEW.POLUCH_ID, :NEW.POTREB_ID, :NEW.CENA, vNOM_ZD, v_new.TONN_DECLARED, v_new.CIST_DECLARED,
					 0,0, v_new.TONN_LOADED, v_new.CIST_LOADED, :NEW.GU12_A_ID,'*');
			  UPDATE ZAKAZ_HIST SET IS_AUTO_MONTH=1 WHERE ID=v_new.ZAKAZ_HIST_ID;
			END IF;
		  END IF;
          -- восстановим заявку из ИСУ
          UPDATE ZAKAZ_HIST SET KOD_ISU=v_new.zakaz_kod_isu WHERE ID=v_new.ZAKAZ_HIST_ID and v_new.zakaz_kod_isu||' '<>' ' and kod_isu||' '=' ';  
		END IF;
	  END IF;
	ELSE
      IF NVL(v_new.ZAKAZ_HIST_ID,0)<>0 /*AND
	     (v_old.TONN_LOADED<>v_new.TONN_LOADED OR v_old.CIST_LOADED<>v_new.CIST_LOADED OR
		  v_old.TONN_DECLARED<>v_new.TONN_DECLARED OR v_old.CIST_DECLARED<>v_new.CIST_DECLARED) */ THEN
	    -- Изменился факт отгрузки по разнарядке
		For_Zakaz.SetNOM_ZD(0,v_new.ZAKAZ_ID, v_new.ZAKAZ_HIST_ID, vNOM_ZD, vNOM_ZD, v_new.TONN_DECLARED, v_new.CIST_DECLARED, v_new.TONN_LOADED, v_new.CIST_LOADED);
	  END IF;
    END IF;
  EXCEPTION
    WHEN TABLE_MUTATING OR NO_STATEMENT_PARSED THEN NULL;
  END;

  IF INSERTING() OR UPDATING() THEN
    :NEW.ZAKAZ_ID:=v_new.ZAKAZ_ID;
    :NEW.ZAKAZ_HIST_ID:=v_new.ZAKAZ_HIST_ID;
    :NEW.TONN_DECLARED:=v_new.TONN_DECLARED;
    :NEW.CIST_DECLARED:=v_new.CIST_DECLARED;
    :NEW.TONN_LOADED:=v_new.TONN_LOADED;
    :NEW.CIST_LOADED:=v_new.CIST_LOADED;
  END IF;

END;
/


