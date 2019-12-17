--
-- OIL_QUALITY_BIU  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.OIL_QUALITY_BIU
BEFORE INSERT
ON MASTER.OIL_QUALITY
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
if :NEW.OIL_QUALITY_ID is NULL or :NEW.OIL_QUALITY_ID=0 then
   Select seq_plan_refinery.NextVal into tmpVar from dual;
   :NEW.OIL_QUALITY_ID := tmpVar;
end if;
END;
/


