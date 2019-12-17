--
-- V_KSSS_USL  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_KSSS_USL
(PERIOD, NAME_NPR, ID_NPR, NPR, SHORT_NAME, 
 ZAK, SUMMA)
AS 
SELECT /*+ ORDERED USE_NL (d) */
       TO_CHAR (b.date_kvit, 'yyyymm') AS period, pr.name_npr, pr.id_npr,
       pr.ksss_prod_id AS npr, p.short_name, p.ksss_predpr_id AS zak,
       bp.summa
  FROM bills b, bill_pos bp, kls_prod pr, kls_dog d, kls_predpr p
 WHERE b.nom_dok = bp.nom_dok
   AND bp.prod_id_npr = pr.id_npr
   AND b.dog_id = d.ID
   AND d.predpr_id = p.ID
   AND bp.prod_id_npr < '10300'
   AND b.date_kvit > '01-sep-2004'
   AND bp.summa <> 0;


