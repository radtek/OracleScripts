--
-- TRG_BIR_KLS_DECADA  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIR_KLS_DECADA
BEFORE INSERT
ON MASTER.KLS_DECADA
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
   if :NEW.kod is null or :NEW.kod=0 then
   Select seq_kls_dekada.NextVal into tmpVar from dual;
   :NEW.kod := tmpVar;
end if;
END trg_bir_kls_decada;
/


