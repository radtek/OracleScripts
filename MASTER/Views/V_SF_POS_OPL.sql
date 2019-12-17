--
-- V_SF_POS_OPL  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_SF_POS_OPL
(ID, NOM_DOK, BILL_POS_ID, PAYMENTS_ID, SUMMA, 
 DATE_REALIZ, SUMMA_NDS, SUMMA_AKCIZ, VES, NUM_PLAT, 
 DATE_PLAT, NAZN_PLAT)
AS 
SELECT
  payments_on_bills."ID",payments_on_bills."NOM_DOK",payments_on_bills."BILL_POS_ID",payments_on_bills."PAYMENTS_ID",payments_on_bills."SUMMA",payments_on_bills."DATE_REALIZ",payments_on_bills."SUMMA_NDS",payments_on_bills."SUMMA_AKCIZ",payments_on_bills."VES",
  payments.NUM_PLAT,
  payments.DATE_PLAT,
  payments.NAZN_PLAT
FROM
  payments_on_bills,payments
WHERE
  payments_on_bills.PAYMENTS_ID=payments.ID;


