--
-- V_TEMP_PAYMENTS_TO_BILLS  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_TEMP_PAYMENTS_TO_BILLS
(PAYMENTS_ID, NOM_DOK)
AS 
SELECT "PAYMENTS_ID","NOM_DOK"
FROM TEMP_PAYMENTS_TO_BILLS
WHERE OSUSER_NAME=FOR_INIT.GetCurrUser
  AND TERMINAL_NAME=FOR_INIT.GetCurrTerm;

