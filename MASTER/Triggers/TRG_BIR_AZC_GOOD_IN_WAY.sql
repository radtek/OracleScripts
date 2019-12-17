--
-- TRG_BIR_AZC_GOOD_IN_WAY  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIR_AZC_GOOD_IN_WAY
BEFORE INSERT
ON MASTER.AZC_GOOD_IN_WAY
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
if :new.id is null or :new.id=0 then
   Select seq_azc_good_in_way.NextVal into tmpVar from dual;
   :NEW.id := tmpVar;
end if;
END trg_bir_azc_good_in_way;
/


