--
-- TRG_BIR_AZC_SYS_COMM  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIR_AZC_SYS_COMM
BEFORE INSERT
ON MASTER.AZC_SYS_COMM
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
if :new.id is null or :new.id=0 then
   Select seq_azc_sys_comm.NextVal into tmpVar from dual;
   :NEW.id := tmpVar;
end if;
END trg_bir_azc_sys_comm;
/


