--
-- TRG_BIUDR_TAX_USER  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_TAX_USER
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.ISU_TAX_USER FOR EACH ROW
DECLARE
  v_tmp NUMBER;
BEGIN

  IF INSERTING() OR UPDATING() THEN
    -- ���������� ID
    IF :new.ID||' '=' ' OR :new.ID IS NULL THEN
      SELECT SEQ_TAX_ID.nextval INTO :new.ID FROM DUAL;
    END IF;
  END IF;
  
END;
/


