--
-- TRG_PLAN_REFINERY_BINSERT  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_PLAN_REFINERY_BINSERT
BEFORE INSERT
ON MASTER.PLAN_REFINERY
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
if :NEW.kod is NULL or :NEW.kod=0 then
   Select seq_plan_refinery.NextVal into tmpVar from dual;
   :NEW.kod := tmpVar;
end if;
END trg_plan_refinery_binsert;
/


