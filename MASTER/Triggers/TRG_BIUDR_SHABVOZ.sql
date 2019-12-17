--
-- TRG_BIUDR_SHABVOZ  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_SHABVOZ
BEFORE INSERT
ON MASTER.KLS_SHABVOZ
FOR EACH ROW
DECLARE
tmpVar NUMBER;
/******************************************************************************
   NAME:       
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        06.02.2006             1. Created this trigger.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     
      Sysdate:         06.02.2006
      Date and Time:   06.02.2006, 10:58:12, and 06.02.2006 10:58:12
      Username:         (set in TOAD Options, Proc Templates)
      Table Name:      KLS_SHABVOZ (set in the "New PL/SQL Object" dialog)
      Trigger Options:  (set in the "New PL/SQL Object" dialog)
******************************************************************************/
BEGIN
   tmpVar := 0;
IF :NEW.ID IS NULL THEN
   SELECT SEQ_SHAB_VOZ.NEXTVAL INTO tmpVar FROM dual;
   :NEW.ID := tmpVar;
END IF;
   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END ;
/


