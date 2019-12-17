--
-- TRG_AUR_MONTH_VISIR_LOC  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AUR_MONTH_VISIR_LOC
AFTER UPDATE
ON MASTER.MONTH_VISIR_LOC
FOR EACH ROW
DECLARE
act VARCHAR2(1);
newPrich VARCHAR2(250);
oldPrich VARCHAR2(250);
BEGIN
  IF UPDATING() THEN
    newPrich := LTrim(RTrim(:NEW.PRICHIN)) || ' ';
	oldPrich := LTrim(RTrim(:OLD.PRICHIN)) || ' ';
    IF newPrich<>oldPrich THEN
      IF oldPrich=' ' AND newPrich<>' ' THEN
	    act:='I';
	  ELSE
        IF oldPrich<>' ' AND newPrich=' ' THEN
		  act:='D';
		ELSE
		  act:='U';
		END IF;
      END IF;
	  for_visir.local_to_global_row(act,:NEW.APP_USERS_ID,:NEW.DATE_REE,:NEW.DOP_REE,:NEW.NOM_ZD,newPrich);
	END IF;
  END IF;
EXCEPTION
  WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20199,'Ошибка при обновлении причины!');
END TRG_AUR_MONTH_VISIR_LOC;
/


