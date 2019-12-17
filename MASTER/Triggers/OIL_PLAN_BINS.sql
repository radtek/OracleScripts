--
-- OIL_PLAN_BINS  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.OIL_PLAN_BINS
BEFORE INSERT OR UPDATE
ON MASTER.OIL_PLAN
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
if :NEW.kod is NULL or :NEW.kod=0 then
   Select seq_plan_refinery.NextVal into tmpVar from dual;
   :NEW.kod := tmpVar;
end if;
END;
/


