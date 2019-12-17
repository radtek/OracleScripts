--
-- V_PAYMENTS_UNCLOSED_BILLS_PAY  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PAYMENTS_UNCLOSED_BILLS_PAY
(DOG_ID, PAY_DATE, NOM_DOK, NOM_SF, DATE_VYP_SF, 
 PAYMENTS_ID, LUK_SUMMA_DOK, LUK_SUMMA_DOK_FULL, PROD_BILL_POS)
AS 
SELECT   b.dog_id, (b.date_kvit + b.kol_dn) AS pay_date, a.nom_dok, b.nom_sf,
         b.date_vyp_sf, c.payments_id, SUM (a.luk_summa_dok) AS luk_summa_dok,
         b.luk_summa_dok AS luk_summa_dok_full,
         NVL (kls_prod.bill_pos, 1) AS prod_bill_pos
    FROM (SELECT bills.nom_dok, bills.luk_summa_dok
            FROM bills
          UNION ALL
          SELECT payments_on_bills.nom_dok, -payments_on_bills.summa
            FROM payments_on_bills) a,
         bills b,
         v_payments_to_bills c,
         kls_prod
   WHERE a.nom_dok = b.nom_dok
     AND b.nom_dok = c.nom_dok
     AND kls_prod.id_npr = b.prod_id_npr
GROUP BY b.dog_id,
         (b.date_kvit + b.kol_dn),
         a.nom_dok,
         b.nom_sf,
         b.date_vyp_sf,
         b.luk_summa_dok,
         c.payments_id,
         kls_prod.bill_pos;


