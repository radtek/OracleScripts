--
-- V_TEMP_BILL_POS  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_TEMP_BILL_POS
(TERMINAL_NAME, OSUSER_NAME, NOM_DOK, BILL_POS_ID, VES, 
 CENA_BN, CENA, SUMMA_BN, SUMMA_AKCIZ, SUMMA_NDS20, 
 SUMMA, PROD_ID_NPR)
AS 
SELECT
TEMP_BILL_POS."TERMINAL_NAME",TEMP_BILL_POS."OSUSER_NAME",TEMP_BILL_POS."NOM_DOK",TEMP_BILL_POS."BILL_POS_ID",TEMP_BILL_POS."VES",TEMP_BILL_POS."CENA_BN",TEMP_BILL_POS."CENA",TEMP_BILL_POS."SUMMA_BN",TEMP_BILL_POS."SUMMA_AKCIZ",TEMP_BILL_POS."SUMMA_NDS20",TEMP_BILL_POS."SUMMA",TEMP_BILL_POS."PROD_ID_NPR" FROM TEMP_BILL_POS
WHERE TERMINAL_NAME = For_Init.GetCurrTerm
  AND OSUSER_NAME = For_init.GetCurrUser;

