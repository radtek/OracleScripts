--
-- T11_BIUDR_ZAKAZ  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.T11_BIUDR_ZAKAZ
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.ZAKAZ
FOR EACH ROW
DECLARE
  vID NUMBER;
  vPlatId NUMBER;
BEGIN

  IF UPDATING() THEN
    -- Проверяем
	IF :OLD.ID<>:NEW.ID THEN
	  raise_application_error( FOR_SCRIPTS.SG$PK_CHANGE,  FOR_SCRIPTS.SG$PK_CHANGE_TXT);
	END IF;
  END IF;

  IF INSERTING() OR UPDATING() THEN
/*	IF :NEW.SPEED_VES<0 OR :NEW.SPEED_KOL<0 THEN
	  raise_application_error( FOR_SCRIPTS.SG$ERROR,  'Объем срочных перевозок не может быть меньше 0!');
	END IF;*/
	-- Временно
	IF :NEW.VES<0 THEN
	  :NEW.VES:=0;
	END IF;
	IF :NEW.KOL<0 THEN
	  :NEW.KOL:=0;
	END IF;
	--
	IF :NEW.VES<0 OR :NEW.KOL<0 THEN
	  raise_application_error( FOR_SCRIPTS.SG$ERROR,  'Объем по заявке не может быть меньше 0!');
	END IF;
/*	IF :NEW.SPEED_VES>:NEW.VES OR :NEW.SPEED_KOL>:NEW.KOL THEN
	  raise_application_error( FOR_SCRIPTS.SG$ERROR,  'Объем срочных перевозок превышает объем по заявке!');
	END IF;*/
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Корректировка плательщика
	BEGIN
	  SELECT PREDPR_ID INTO vPlatId
	    FROM KLS_DOG WHERE ID=:NEW.DOG_ID;
	  :NEW.PLAT_ID:=vPlatId;
	EXCEPTION
 	  WHEN OTHERS THEN
	    :NEW.DOG_ID:=NULL;
	END;

	IF :NEW.BEGIN_DATE IS NULL THEN
	  :NEW.BEGIN_DATE:=:NEW.DATE_PLAN;
	END IF;
  END IF;

END;
/


