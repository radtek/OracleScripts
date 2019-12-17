--
-- OIL_TRACE_BINS  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.OIL_TRACE_BINS
BEFORE INSERT
ON MASTER.OIL_TRACE
FOR EACH ROW
declare
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
if :NEW.kod is NULL or :NEW.kod=0 then
   Select seq_plan_refinery.NextVal into tmpVar from dual;
   :NEW.kod := tmpVar;
end if;
END;
/


