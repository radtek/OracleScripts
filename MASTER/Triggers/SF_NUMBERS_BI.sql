--
-- SF_NUMBERS_BI  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.SF_NUMBERS_BI
BEFORE INSERT
ON MASTER.SF_NUMBERS
FOR EACH ROW
DECLARE
BEGIN
  SELECT MAX(to_date) INTO :NEW.From_Date FROM SF_Numbers;
  SELECT Start_Num+Range,Range
    INTO :NEW.Start_Num,:NEW.Range
	FROM SF_Numbers WHERE to_date=:NEW.From_Date;
  :NEW.From_Date:=:NEW.From_Date+1;
  IF TO_CHAR(:NEW.From_Date,'DD')>='25' THEN
    :NEW.To_date:=LAST_DAY(:NEW.From_Date);
  ELSE
    :NEW.To_date:=:NEW.From_Date+4;
  END IF;
  :NEW.Curr_Num:=:NEW.Start_Num;
END SF_NUMBERS_BI;
/


