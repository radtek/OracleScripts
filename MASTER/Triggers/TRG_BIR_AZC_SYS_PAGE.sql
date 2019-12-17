--
-- TRG_BIR_AZC_SYS_PAGE  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIR_AZC_SYS_PAGE
BEFORE INSERT
ON MASTER.AZC_SYS_PAGE
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
if :new.id is null or :new.id=0 then
   Select seq_azc_sys_page.NextVal into tmpVar from dual;
   :NEW.id := tmpVar;
end if;
END trg_bir_azc_sys_page;
/


