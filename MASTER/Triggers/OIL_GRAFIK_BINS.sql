--
-- OIL_GRAFIK_BINS  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.OIL_GRAFIK_BINS
BEFORE INSERT
ON MASTER.OIL_GRAFIK
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


