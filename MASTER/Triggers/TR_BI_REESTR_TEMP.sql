--
-- TR_BI_REESTR_TEMP  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TR_BI_REESTR_TEMP
BEFORE INSERT
ON MASTER.REESTR_TEMP
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
if :NEW.REESTR_temp_iD is NULL or :NEW.REESTR_temp_iD=0 then
   Select SEQ_REESTR_RAIL.NextVal into tmpVar from dual;
   :NEW.REESTR_temp_iD := tmpVar;
end if;
END;
/


