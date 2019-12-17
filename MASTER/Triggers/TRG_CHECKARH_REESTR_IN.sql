--
-- TRG_CHECKARH_REESTR_IN  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_CHECKARH_REESTR_IN
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.REESTR_IN
FOR EACH ROW
DECLARE
  v_dat DATE;
  doc_dat DATE;
  TABLE_MUTATING    EXCEPTION;
  PRAGMA EXCEPTION_INIT( TABLE_MUTATING,-04091 );
BEGIN
  /* Триггер запрета изменения архивных данных */
  
  -- Определение архивной даты  
  BEGIN
    SELECT ARH_DATE.LAST_DATE INTO v_dat
	  FROM ARH_DATE WHERE ARH_DATE.TABLENAME='REESTR';
  EXCEPTION 
    WHEN OTHERS THEN
	  v_dat:=TO_DATE('31.12.1899','dd.mm.yyyy');
  END;	  	  

  -- Определение даты документа
  IF UPDATING() OR DELETING() THEN
    --doc_dat:=:OLD.SVED_DATE;
    BEGIN
      SELECT SVED_IN.SVED_DATE INTO doc_dat
	    FROM SVED_IN WHERE SVED_IN.ID=:OLD.SVED_IN_ID;
    EXCEPTION 
      WHEN TABLE_MUTATING THEN
	    doc_dat:=TO_DATE('01.01.2900','dd.mm.yyyy');
      WHEN OTHERS THEN
	    doc_dat:=TO_DATE('01.01.1900','dd.mm.yyyy');
    END;	
  ELSE
    --doc_dat:=:NEW.SVED_DATE;
    BEGIN
      SELECT SVED_IN.SVED_DATE INTO doc_dat
	    FROM SVED_IN WHERE SVED_IN.ID=:NEW.SVED_IN_ID;
    EXCEPTION 
      WHEN TABLE_MUTATING THEN
	    doc_dat:=TO_DATE('01.01.2900','dd.mm.yyyy');
      WHEN OTHERS THEN
	    doc_dat:=TO_DATE('01.01.1900','dd.mm.yyyy');
    END;
  END IF;	  	  
 
  -- Контроль
  IF DELETING() AND doc_dat<=v_dat THEN
     raise_application_error( FOR_SCRIPTS.SG$CHANGE_ARCHIVE, FOR_SCRIPTS.SG$CHANGE_ARCHIVE_D);
  END IF;
  IF UPDATING() AND doc_dat<=v_dat THEN
     raise_application_error( FOR_SCRIPTS.SG$CHANGE_ARCHIVE, FOR_SCRIPTS.SG$CHANGE_ARCHIVE_U);
  END IF;
  IF INSERTING() AND doc_dat<=v_dat THEN
     raise_application_error( FOR_SCRIPTS.SG$CHANGE_ARCHIVE, FOR_SCRIPTS.SG$CHANGE_ARCHIVE_I);
  END IF;

END;
/


