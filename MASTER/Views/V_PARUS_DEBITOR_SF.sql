--
-- V_PARUS_DEBITOR_SF  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PARUS_DEBITOR_SF
(NOM_SF, NOM_DOK, LUKDOG_ID, PLAT_ID, DOG_ID, 
 IS_PROD, DATE_KVIT, KOL_DN, DATE_TO_OPL, SUMMA_DOK)
AS 
SELECT   /*+ FIRST_ROWS*/
             bills_parus.npo_sf, bills_parus.nom_dok,
             DECODE (NVL (kls_dog.lukdog_id, 0),
                     0, bills_parus.dog_id,
                     kls_dog.lukdog_id
                    ),
             kls_dog.predpr_id, bills_parus.dog_id,
             DECODE (SIGN (bp.bill_pos_parus_id - 10), -1, 1, 0),
             MAX (bills_parus.date_kvit), MAX (bills_parus.kol_dn),
             MAX (bills_parus.date_kvit + bills_parus.kol_dn), SUM (bp.summa)
       FROM bills_parus, bill_pos_parus bp, kls_dog
      WHERE bills_parus.date_kvit >= TO_DATE ('01.12.2002', 'dd.mm.yyyy')
        AND bills_parus.dog_id = kls_dog.ID
        AND bp.nom_dok = bills_parus.nom_dok
   GROUP BY bills_parus.npo_sf,
            bills_parus.nom_dok,
            DECODE (NVL (kls_dog.lukdog_id, 0),
                    0, bills_parus.dog_id,
                    kls_dog.lukdog_id
                   ),
            kls_dog.predpr_id,
            bills_parus.dog_id,
            DECODE (SIGN (bp.bill_pos_parus_id - 10), -1, 1, 0)
   UNION ALL
   SELECT ' ', 0, kls_dog.lukdog_id, kls_predpr.ID, kls_dog.ID, 1,
          TO_DATE ('30.11.2002', 'dd.mm.yyyy'), kls_usl_opl.kol_dn,
          TO_DATE ('30.11.2002', 'dd.mm.yyyy') + kls_usl_opl.kol_dn,
          kls_dog.saldo_01122002
     FROM kls_dog, kls_predpr, kls_usl_opl
    WHERE kls_dog.saldo_01122002 <> 0
      AND kls_dog.usl_opl_id = kls_usl_opl.ID(+)
      AND kls_dog.predpr_id = kls_predpr.ID;


