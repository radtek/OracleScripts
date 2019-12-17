--
-- V_UNP_GRAFIK_PRED_SF  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_UNP_GRAFIK_PRED_SF
(DOG_ID, DATE_PRED, SUMMA_PRED)
AS 
SELECT   /*+ ORDERED INDEX (b BILLS_DATE_KVIT) USE_NL (b, bp, kls_dog) INDEX (bp BILL_POS_NOM_DOK_2_I)
*/
         b.dog_id, b.date_kvit AS date_pred,
-- Дата предъявления (дата квитанции)
                                            SUM (bp.summa) AS summa_pred
    FROM master_reports r_master_reports,
         bills b,
         bill_pos bp,
         kls_dog,
         kls_prod
   WHERE b.date_kvit BETWEEN r_master_reports.begin_date
                         AND LAST_DAY (r_master_reports.end_date)
     AND b.nom_dok = bp.nom_dok
     AND bp.prod_id_npr = kls_prod.id_npr
     AND kls_prod.id_group_npr >=
            DECODE (r_master_reports.grp_id_npr,
                    '*', '00000',
                    r_master_reports.grp_id_npr
                   )
     AND kls_prod.id_group_npr <=
            DECODE (r_master_reports.grp_id_npr,
                    '10100', '99999',
                    '*', '99999',
                    r_master_reports.grp_id_npr
                   )
     AND bp.is_luk = 1
     AND b.dog_id = kls_dog.ID
     AND kls_dog.predpr_id =
            DECODE (r_master_reports.plat_id,
                    0, kls_dog.predpr_id,
                    r_master_reports.plat_id
                   )
     AND kls_dog.dog_number LIKE r_master_reports.dog_number
     AND NLS_UPPER (TRIM (r_master_reports.report_file)) =
                                                         'UNP_GRAFIK_PLAT.XLS'
     AND r_master_reports.terminal_name = MASTER.for_init.getcurrterm
     AND r_master_reports.osuser_name = MASTER.for_init.getcurruser
GROUP BY b.dog_id, b.date_kvit;


