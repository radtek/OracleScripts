--
-- REESTR_RAIL_BIU  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.REESTR_RAIL_BIU
BEFORE INSERT OR UPDATE
ON MASTER.REESTR_RAIL
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
if :NEW.reestr_rail_id is NULL or :NEW.reestr_rail_id=0 then
   Select SEQ_REESTR_RAIL.NextVal into tmpVar from dual;
   :NEW.reestr_rail_id := tmpVar;
end if;
END;
/


