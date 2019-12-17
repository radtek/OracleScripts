--
-- SF_NUMBERS_BU  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.SF_NUMBERS_BU
BEFORE UPDATE
ON MASTER.SF_NUMBERS
FOR EACH ROW
DECLARE
Last_Date DATE;
BEGIN

  IF (:NEW.From_Date<>:OLD.From_Date) OR
     (:NEW.To_Date<>:OLD.To_Date) THEN
    RAISE_APPLICATION_ERROR(-20000, 'Изменение дат запрещено!');
  END IF;
  IF (:NEW.Start_Num<>:OLD.Start_Num) THEN
    RAISE_APPLICATION_ERROR(-20000, 'Изменение стартовых номеров запрещено!');
  END IF;
  IF (:NEW.Start_Num+:NEW.Range<=:NEW.Curr_num) THEN
    RAISE_APPLICATION_ERROR(-20000, 'Закончился резерв номеров СФ!, Sorry');
  END IF;
  IF (:NEW.Range<>:OLD.Range) THEN
--    SELECT MAX(From_Date) INTO Last_Date FROM SF_NUmbers;
--	IF Last_Date>:NEW.From_Date THEN
--      RAISE_APPLICATION_ERROR(-20000, 'Изменение диапазона запрещено!');
--	END IF;
    IF :OLD.Start_num+:NEW.Range-:OLD.Curr_Num<0 THEN
      RAISE_APPLICATION_ERROR(-20000, 'Изменение диапазона запрещено! Значение диапазона менее, чем значение выставленных СФ.');
	END IF;
  END IF;

END SF_NUMBERS_BU;
/


