--
-- V_PAYMENTS_UNCLOSED_BILLS  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PAYMENTS_UNCLOSED_BILLS
(DOG_ID, PAY_DATE, NOM_DOK, NOM_SF, DATE_VYP_SF, 
 PAYMENTS_ID, LUK_SUMMA_DOK, LUK_SUMMA_DOK_FULL, PROD_BILL_POS)
AS 
SELECT                                     /* ORDERED USE_NL(a,b,kls_prod)  */
         b.dog_id, b.date_plat AS pay_date, b.nom_dok, b.nom_sf,
         b.date_vyp_sf, 0 AS payments_id,
         SUM (a.luk_summa_dok) AS luk_summa_dok,
         b.luk_summa_dok AS luk_summa_dok_full,
         NVL (kls_prod.bill_pos, 1) AS prod_bill_pos
    FROM (SELECT                                   /* INDEX(bills BILLS_PK) */
                 bills.nom_dok, bills.luk_summa_dok
            FROM bills
          UNION ALL
          SELECT                    /* INDEX(p PAYMENTS_ON_BILLS_NOM_DOK_I) */
                 p.nom_dok, -p.summa
            FROM payments_on_bills p) a,
         bills b,
         kls_prod
   WHERE b.nom_dok = a.nom_dok
     AND b.prod_id_npr = kls_prod.id_npr
     AND NOT EXISTS (SELECT *
                       FROM v_payments_corr_bills_pairs c
                      WHERE c.nom_dok = b.nom_dok)
---------------- условие которое делает обязтельной оплату привязанных счетов фактур однозначной --------------------------------
-- AND not exists (select * from V_PAYMENTS_UNCLOSED_BILLS_PAY d where d.nom_dok=b.nom_dok)
---------------- условие которое делает обязтельной оплату привязанных счетов фактур однозначной --------------------------------
GROUP BY b.dog_id,
         b.date_plat,
         b.nom_dok,
         b.nom_sf,
         b.date_vyp_sf,
         b.luk_summa_dok,
         kls_prod.bill_pos;


