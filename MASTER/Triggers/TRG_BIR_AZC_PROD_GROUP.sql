--
-- TRG_BIR_AZC_PROD_GROUP  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIR_AZC_PROD_GROUP
BEFORE INSERT
ON MASTER.AZC_PROD_GROUP
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
if :new.id is null or :new.id=0 then
   Select seq_azc_prod_group.NextVal into tmpVar from dual;
   :NEW.id := tmpVar;
end if;
END trg_azc_prod_group;
/


