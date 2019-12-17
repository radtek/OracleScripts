--
-- TRG_BIUDR_VED_OSMOTR_SMENA  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_VED_OSMOTR_SMENA
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.VED_OSMOTR_SMENA
FOR EACH ROW
BEGIN

  IF INSERTING() OR UPDATING() THEN
    -- ���������� ID
    IF :new.ID=0 OR :new.ID IS NULL THEN
      SELECT SEQ_KLS.nextval INTO :new.ID FROM DUAL;
    END IF;
  END IF;
END;
/


