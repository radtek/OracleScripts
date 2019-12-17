--
-- TRG_BIR_AZC_TYPE_OPER  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIR_AZC_TYPE_OPER
BEFORE INSERT
ON MASTER.AZC_TYPE_OPERATION
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
if :new.id is null or :new.id=0 then
   Select seq_azc_type_operation.NextVal into tmpVar from dual;
   :NEW.id := tmpVar;
end if;
END trg_bir_azc_type_oper;
/


