--
-- TRG_BIR_AZC_PLACE_SEND  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIR_AZC_PLACE_SEND
BEFORE INSERT
ON MASTER.AZC_PLACE_SEND
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
if :new.id is null or :new.id=0 then
   Select seq_azc_place_send.NextVal into tmpVar from dual;
   :NEW.id := tmpVar;
end if;
END trg_bir_azc_place_send;
/


