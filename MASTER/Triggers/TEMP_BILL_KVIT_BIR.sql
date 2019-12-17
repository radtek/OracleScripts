--
-- TEMP_BILL_KVIT_BIR  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TEMP_BILL_KVIT_BIR
BEFORE INSERT
ON MASTER.TEMP_BILL_KVIT
FOR EACH ROW
DECLARE
tmpVar NUMBER;
/******************************************************************************
   NAME:       TEMP_BILL_KVIT_BIR
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        07.07.2003             1. Created this trigger.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     TEMP_BILL_KVIT_BIR
      Sysdate:         07.07.2003
      Date and Time:   07.07.2003, 11:32:47, and 07.07.2003 11:32:47
      Username:         (set in TOAD Options, Proc Templates)
      Table Name:      TEMP_BILL_KVIT (set in the "New PL/SQL Object" dialog)
      Trigger Options:  (set in the "New PL/SQL Object" dialog)
******************************************************************************/
BEGIN
  IF INSERTING() THEN
    :NEW.TERMINAL_NAME:=For_Init.GetCurrTerm;
	:NEW.OSUSER_NAME:=For_Init.GetCurrUser;
  END IF;
END TEMP_BILL_KVIT_BIR;
/


