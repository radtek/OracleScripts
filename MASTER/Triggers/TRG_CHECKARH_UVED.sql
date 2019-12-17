--
-- TRG_CHECKARH_UVED  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_CHECKARH_UVED
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.UVED
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
    doc_dat:=:OLD.UVED_DATE;
    /*BEGIN
      SELECT SVED.SVED_DATE INTO doc_dat
	    FROM SVED WHERE SVED.ID=:OLD.SVED_ID;
    EXCEPTION 
      WHEN TABLE_MUTATING THEN
	    doc_dat:=TO_DATE('01.01.2900','dd.mm.yyyy');
      WHEN OTHERS THEN
	    doc_dat:=TO_DATE('01.01.1900','dd.mm.yyyy');
    END;	*/
  ELSE
    doc_dat:=:NEW.UVED_DATE;
    /*BEGIN
      SELECT SVED.SVED_DATE INTO doc_dat
	    FROM SVED WHERE SVED.ID=:NEW.SVED_ID;
    EXCEPTION 
      WHEN TABLE_MUTATING THEN
	    doc_dat:=TO_DATE('01.01.2900','dd.mm.yyyy');
      WHEN OTHERS THEN
	    doc_dat:=TO_DATE('01.01.1900','dd.mm.yyyy');
    END;*/
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


