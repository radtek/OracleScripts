--
-- TRG_BIUR_DOVER  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUR_DOVER
BEFORE INSERT OR UPDATE
ON MASTER.KLS_DOVER
FOR EACH ROW
DECLARE
tmpRow KLS_DOVER%rowtype;
BEGIN
  IF inserting THEN
    FOR tmpRow IN (SELECT * FROM KLS_DOVER
                 WHERE DATE_DOVER = :new.DATE_DOVER
                 AND NUM_DOVER = :new.NUM_DOVER
                 AND PREDPR_ID = :new.PREDPR_ID) LOOP
      raise_application_error(-20101, 'Данная доверенность уже введена!');
    END LOOP;
---  ELSE
---    FOR tmpRow IN (SELECT * FROM KLS_DOVER
---                 WHERE DATE_DOVER = :new.DATE_DOVER
---                 AND NUM_DOVER = :new.NUM_DOVER
---                 AND PREDPR_ID = :new.PREDPR_ID
---				 AND ID<>:old.ID) LOOP
---      raise_application_error(-20101, 'Данная доверенность уже введена!');
---    END LOOP;
  END IF;
END TRG_BIUR_DOVER;
/


ALTER TRIGGER MASTER.TRG_BIUR_DOVER DISABLE;


