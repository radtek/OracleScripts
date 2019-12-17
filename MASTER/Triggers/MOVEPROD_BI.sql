--
-- MOVEPROD_BI  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.MOVEPROD_BI
BEFORE INSERT
ON MASTER.MOVEPROD
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
if :NEW.moveprod_id is NULL or :NEW.moveprod_id=0 then
   Select seq_moveprod.NextVal into tmpVar from dual;
   :NEW.moveprod_id := tmpVar;
end if;
END;
/


