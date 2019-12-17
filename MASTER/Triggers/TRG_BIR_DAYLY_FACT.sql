--
-- TRG_BIR_DAYLY_FACT  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIR_DAYLY_FACT
BEFORE INSERT
ON MASTER.DAYLY_FACT
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
   if :NEW.kod is NULL or :NEW.kod=0 then
   Select seq_dayly_fact.NextVal into tmpVar from dual;
   :NEW.kod := tmpVar;
end if;
END trg_bir_dayly_fact;
/


