--
-- V_PAYMENTS_UNCLOSED_BILL_POS  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PAYMENTS_UNCLOSED_BILL_POS
(NOM_DOK, BILL_POS_ID, SUMMA_AKCIZ, SUMMA_NDS20, SUMMA, 
 VES)
AS 
SELECT
  a.nom_dok,
  a.bill_pos_id,
  sum(a.summa_akciz) as summa_akciz,
  sum(a.summa_nds20) as summa_nds20,
  sum(a.summa) AS summa,
  sum(a.ves) AS ves
FROM 
(
SELECT 
  bill_pos.NOM_DOK,
  bill_pos.bill_pos_id,
  bill_pos.SUMMA_NDS20,
  bill_pos.SUMMA_AKCIZ,
  bill_pos.SUMMA,
  bill_pos.VES
  FROM bill_pos WHERE is_luk=1
UNION ALL
SELECT
  payments_on_bills.NOM_DOK,
  payments_on_bills.bill_pos_id,
  -payments_on_bills.SUMMA_NDS,
  -payments_on_bills.SUMMA_AKCIZ,
  -payments_on_bills.SUMMA,
  -NVL(payments_on_bills.VES,0)
  FROM payments_on_bills
) a
GROUP BY
  a.nom_dok,
  a.bill_pos_id;


