--
-- V_REESTR_RAIL_DOG_RGD_SF  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_REESTR_RAIL_DOG_RGD_SF
(KVIT_ID, DATE_KVIT, NOM_SCH, DATE_SCH, NUM_PER, 
 DATA_PER, SHORT_NAME, NOM_SF, DATE_VYP_SF, NUM_KVIT, 
 TAR_UNP, TAR_UNP_NDS, TAR_NDS_UNP, TAR_RGD, TAR_RGD_NDS, 
 TAR_NDS_RGD)
AS 
SELECT /*+ ORDERED */                        /* Охрана - Есть реестр от РЖД */
       k.ID, k.date_kvit, gd_schet.nom_sch, gd_schet.date_sch, reestr.num_per,
       reestr.data_per, p.short_name, b.nom_sf, b.date_vyp_sf, k.num_kvit,
       DECODE (SIGN (reestr.GUARD), -1, 0, k.tarif_guard) AS tar_unp,
       DECODE (SIGN (reestr.GUARD), -1, 0, k.tarif_guard_nds) AS tar_unp_nds,
       DECODE (SIGN (reestr.GUARD),
               -1, 0,
               k.tarif_guard + k.tarif_guard_nds
              ) AS tar_nds_unp,
       reestr.GUARD AS tar_rgd, reestr.guardnds - reestr.GUARD AS tar_rgd_nds,
       reestr.guardnds AS tar_nds_rgd
  FROM MASTER.kvit k,
       MASTER.bills b,
       MASTER.kls_dog d,
       MASTER.kls_predpr p,
       MASTER.reestr_rail reestr,
       (SELECT DISTINCT nom_sch, date_sch, nom_perech, dat_perech, r21, kst
                   FROM MASTER.reestr_rail_rgd_sf
                  WHERE r21 = 95 AND kst = 285706) gd_schet
 WHERE k.bill_id = b.nom_dok
   AND b.dog_id = d.ID
   AND d.predpr_id = p.ID
   AND reestr.data_per = gd_schet.dat_perech
   AND k.num_kvit = reestr.num_kvit
   AND reestr.num_per = gd_schet.nom_perech
   AND k.perech_guard_num = reestr.num_per
   AND k.perech_guard_date = reestr.data_per
   AND k.tarif_guard <> 0
   AND reestr.GUARD <> 0
--   and k.date_kvit between to_date('01.07.2005','dd.mm.yyyy') and to_date('31.07.2005','dd.mm.yyyy')
UNION ALL
SELECT /*+ ORDERED */                        /* Охрана - Нет реестра от РЖД */
       k.ID, k.date_kvit, NULL AS nom_sch, NULL AS date_sch,
       k.perech_guard_num AS num_per, k.perech_guard_date AS data_per,
       p.short_name, b.nom_sf, b.date_vyp_sf, k.num_kvit,
       k.tarif_guard AS tar_unp, k.tarif_guard_nds AS tar_unp_nds,
       k.tarif_guard + k.tarif_guard_nds AS tar_nds_unp, 0 AS tar_rgd,
       0 AS tar_rgd_nds, 0 AS tar_nds_rgd
  FROM MASTER.kvit k, MASTER.bills b, MASTER.kls_dog d, MASTER.kls_predpr p
 WHERE k.bill_id = b.nom_dok
   AND b.dog_id = d.ID
   AND d.predpr_id = p.ID
   AND NOT EXISTS (
          SELECT NULL
            FROM MASTER.reestr_rail reestr,
                 MASTER.reestr_rail_rgd_sf gd_schet
           WHERE reestr.data_per = gd_schet.dat_perech
             AND k.num_kvit = reestr.num_kvit
             AND reestr.num_per = gd_schet.nom_perech
             AND k.perech_guard_num = reestr.num_per
             AND k.perech_guard_date = reestr.data_per
             AND reestr.GUARD <> 0
             AND gd_schet.r21 = 95
             AND gd_schet.kst = 285706)
   AND k.tarif_guard <> 0
--   and k.date_kvit between to_date('01.07.2005','dd.mm.yyyy') and to_date('31.07.2005','dd.mm.yyyy')
UNION ALL
SELECT /*+ ORDERED */                         /* Тариф - Есть реестр от РЖД */
       k.ID, k.date_kvit, gd_schet.nom_sch, gd_schet.date_sch, reestr.num_per,
       reestr.data_per, p.short_name, b.nom_sf, b.date_vyp_sf, k.num_kvit,
       DECODE (SIGN (reestr.tarif), -1, 0, k.tarif) AS tar_unp,
       DECODE (SIGN (reestr.tarif), -1, 0, k.tarif_nds) AS tar_unp_nds,
       DECODE (SIGN (reestr.tarif),
               -1, 0,
               k.tarif + k.tarif_nds
              ) AS tar_nds_unp,
       reestr.tarif AS tar_rgd, reestr.tarnds - reestr.tarif AS tar_rgd_nds,
       reestr.tarnds AS tar_nds_rgd
  FROM MASTER.kvit k,
       MASTER.bills b,
       MASTER.kls_dog d,
       MASTER.kls_predpr p,
       MASTER.reestr_rail reestr,
       (SELECT DISTINCT nom_sch, date_sch, nom_perech, dat_perech, r21, kst
                   FROM MASTER.reestr_rail_rgd_sf
                  WHERE r21 = 95 AND kst = 285706) gd_schet
 WHERE k.bill_id = b.nom_dok
   AND b.dog_id = d.ID
   AND d.predpr_id = p.ID
   AND reestr.data_per = gd_schet.dat_perech
   AND k.num_kvit = reestr.num_kvit
   AND reestr.num_per = gd_schet.nom_perech
   AND k.perech_texpd_num = reestr.num_per
   AND k.perech_texpd_date = reestr.data_per
   AND k.tarif <> 0
   AND reestr.tarif <> 0
   AND gd_schet.r21 = 95
   AND gd_schet.kst = 285706
--   and k.date_kvit between to_date('01.07.2005','dd.mm.yyyy') and to_date('31.07.2005','dd.mm.yyyy')
UNION ALL
SELECT /*+ RULE */                            /* Тариф - Нет реестра от РЖД */
       k.ID, k.date_kvit, NULL AS nom_sch, NULL AS date_sch,
       k.perech_texpd_num AS num_per, k.perech_texpd_date AS data_per,
       p.short_name, b.nom_sf, b.date_vyp_sf, k.num_kvit, k.tarif AS tar_unp,
       k.tarif_nds AS tar_unp_nds, k.tarif + k.tarif_nds AS tar_nds_unp,
       0 AS tar_rgd, 0 AS tar_rgd_nds, 0 AS tar_nds_rgd
  FROM MASTER.kvit k, MASTER.bills b, MASTER.kls_dog d, MASTER.kls_predpr p
 WHERE k.bill_id = b.nom_dok
   AND b.dog_id = d.ID
   AND d.predpr_id = p.ID
   AND NOT EXISTS (
          SELECT NULL
            FROM MASTER.reestr_rail reestr,
                 MASTER.reestr_rail_rgd_sf gd_schet
           WHERE reestr.data_per = gd_schet.dat_perech
             AND k.num_kvit = reestr.num_kvit
             AND reestr.num_per = gd_schet.nom_perech
             AND k.perech_texpd_num = reestr.num_per
             AND k.perech_texpd_date = reestr.data_per
             AND reestr.tarif <> 0
             AND gd_schet.r21 = 95
             AND gd_schet.kst = 285706)
   AND k.tarif <> 0
-- and k.date_kvit between to_date('01.07.2005','dd.mm.yyyy') and to_date('31.07.2005','dd.mm.yyyy')
;


