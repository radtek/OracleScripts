--
-- TRG_BIR_AZC_FROM_PARUS  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIR_AZC_FROM_PARUS
BEFORE INSERT
ON MASTER.AZC_FROM_PARUS
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
  tmpVar := 0;
  IF :NEW.id IS NULL OR :NEW.id=0 THEN
    SELECT seq_azc_from_parus.NEXTVAL INTO tmpVar FROM dual;
    :NEW.id := tmpVar;
  END IF;
  :NEW.TERMINAL_NAME:=For_Init.GetCurrTerm;
  :NEW.OSUSER_NAME:=For_Init.GetCurrUser;
END trg_bir_azc_from_parus;
/


