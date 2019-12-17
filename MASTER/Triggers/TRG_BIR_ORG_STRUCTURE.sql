--
-- TRG_BIR_ORG_STRUCTURE  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIR_ORG_STRUCTURE
BEFORE INSERT
ON MASTER.ORG_STRUCTURE
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
if :new.id is null or :new.id=0 then
   Select seq_org_structure.NextVal into tmpVar from dual;
   :NEW.id := tmpVar;
end if;
END trg_bir_org_structure;
/


