--
-- TRG_BIR_AZC_REALIZ_LIKARD  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIR_AZC_REALIZ_LIKARD
BEFORE INSERT
ON MASTER.AZC_REALIZ_LIKARD
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
if :new.id is null or :new.id=0 then
   Select seq_azc_realiz_likard.NextVal into tmpVar from dual;
   :NEW.id := tmpVar;
end if;
END trg_bir_azc_realiz_likard;
/


