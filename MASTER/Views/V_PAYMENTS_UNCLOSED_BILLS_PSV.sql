--
-- V_PAYMENTS_UNCLOSED_BILLS_PSV  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PAYMENTS_UNCLOSED_BILLS_PSV
(DOG_ID, PAY_DATE, NOM_DOK, PAYMENTS_ID, LUK_SUMMA_DOK, 
 LUK_SUMMA_DOK_FULL, PROD_BILL_POS)
AS 
SELECT /* ORDERED INDEX(b BILL_DOG_ID) USE_NL(b,kls_prod,a) */ /*+ RULE */
  b.dog_id,
  b.DATE_PLAT AS pay_date,
  b.nom_dok,
  0 AS PAYMENTS_ID,
  sum(a.luk_summa_dok) AS luk_summa_dok,
  b.luk_SUMMA_DOK AS luk_summa_dok_full,
  NVL(kls_prod.bill_pos,1) AS prod_bill_pos
FROM bills b,kls_prod,
(
SELECT /* INDEX(bb BILLS_PK) */
  bb.NOM_DOK,
  bb.luk_SUMMA_DOK
  FROM bills bb
UNION ALL
SELECT /* INDEX(cc PAYMENTS_ON_BILLS_NOM_DOK_I) */
  cc.NOM_DOK,
  -cc.SUMMA
  FROM payments_on_bills cc
) a
WHERE
  b.nom_dok=a.nom_dok and
  b.prod_id_npr=kls_prod.id_npr and
  not exists (select * from V_PAYMENTS_CORR_BILLS_PAIRS_P c where c.nom_dok=b.nom_dok)
GROUP BY
  b.dog_id,
  b.DATE_PLAT,
  b.nom_dok,
  b.luk_SUMMA_DOK,
  kls_prod.bill_pos;


