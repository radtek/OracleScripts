--
-- TRG_BIUDR_MASTER_POGR  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_MASTER_POGR
BEFORE INSERT
ON MASTER.KLS_MASTER_POGR
FOR EACH ROW
DECLARE
tmpVar NUMBER;
/******************************************************************************
   NAME:       TRG_BIUDR_MASTER_POGR
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        06.02.2006             1. Created this trigger.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     TRG_BIUDR_MASTER_POGR
      Sysdate:         06.02.2006
      Date and Time:   06.02.2006, 12:00:13, and 06.02.2006 12:00:13
      Username:         (set in TOAD Options, Proc Templates)
      Table Name:      KLS_MASTER_POGR (set in the "New PL/SQL Object" dialog)
      Trigger Options:  (set in the "New PL/SQL Object" dialog)
******************************************************************************/
BEGIN
   tmpVar := 0;
IF :NEW.ID IS NULL THEN
   SELECT SEQ_ID.NEXTVAL INTO tmpVar FROM dual;
   :NEW.ID := tmpVar;
END IF;
   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END TRG_BIUDR_MASTER_POGR;
/


