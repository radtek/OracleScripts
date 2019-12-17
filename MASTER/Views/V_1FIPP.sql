--
-- V_1FIPP  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_1FIPP
(DOG_NUMBER, DOG_ID, DATE_BUXG, DATE_TO_PLAT, VES, 
 SUMMA_DOK, SUMMA_OPL)
AS 
SELECT o.dog_number
  , o.npodog_id AS dog_id
  , o.date_kvit
  , o.d_pay
  , o.ves
  , o.strah + o.sum_prod + o.tarif + o.voznagr AS summa_dok
  , 0 AS summa_opl
FROM (SELECT /*+ rule use_hash (d) */
        m.npodog_id
        , d.dog_number
        , k.date_kvit
        , k.date_kvit + m.kol_dn_npo AS d_pay
        , SUM(ROUND((
              ROUND(
              DECODE(k.flg_operdata, 1, NVL(m.tarif1tonn, 0) * k.ves_brutto
              , k.tarif), 2) + k.tarif_guard) * (100+FOR_BILLS.GetNDSValue(k.date_kvit))/100 , 2)) AS tarif
        , /* Ж/д тариф */ SUM(ROUND(
                              ROUND(
                              DECODE(k.vagowner_id
                              , 3, USL_DOG.usl_sum * k.ves_brutto
                              ,
                              DECODE(k.flg_vag_klient
                              , 1, USL_DOG.usl_sum * k.ves_brutto
                              ,
                              DECODE(k.tarif
                              , 0, USL_DOG.usl_sum * k.ves_brutto
                              , k.tarif19 - k.tarif))), 2) * (100+FOR_BILLS.GetNDSValue(k.date_kvit))/100, 2)) AS
        voznagr
        , /* Вознаграждение */ SUM(ROUND(k.ves * m.cena_otp_npo * (100+FOR_BILLS.GetNDSValue(k.date_kvit))/100, 2)) AS
        sum_prod
        , SUM(ROUND((
              ROUND(k.ves * m.cena_otp_npo * (100+FOR_BILLS.GetNDSValue(k.date_kvit))/100, 2)) * USL_DOG.proc_insure /
              100, 2)) AS strah
        , SUM(k.ves) AS ves
      FROM MASTER.KVIT k
        , MASTER.MONTH m
        , MASTER.KLS_PLANSTRU ps
        , MASTER.KLS_DOG d
        , MASTER.USL_DOG
      WHERE k.nom_zd = m.nom_zd
        AND m.planstru_id = ps.ID
        AND m.npodog_id = d.ID
        AND (m.dog_id = USL_DOG.dog_id
             AND m.usl_number = USL_DOG.usl_number)
        AND ps.region_id = 21
        AND k.date_kvit >= TO_DATE('01.09.2003', 'dd.mm.yyyy')
      GROUP BY m.npodog_id, d.dog_number, k.date_kvit
        , k.date_kvit + m.kol_dn_npo
      ORDER BY m.npodog_id
        , k.date_kvit) o
UNION
SELECT /*+ INDEX (opl OPL_DOG_ID) */
  KLS_DOG.dog_number
  , OPL.dog_id
  , OPL.data_por
  , OPL.data_por
  , 0 AS ves
  , 0 AS summa_dok
  , SUM(OPL.summa) AS summa_opl
FROM MASTER.OPL
  , MASTER.KLS_DOG
WHERE OPL.dog_id = KLS_DOG.ID
  AND OPL.dog_id IN (SELECT /*+ all_rows */
                       DISTINCT m.npodog_id
                     FROM MASTER.KVIT k
                       , MASTER.MONTH m
                       , MASTER.KLS_PLANSTRU ps
                       , MASTER.KLS_DOG d
                     WHERE k.nom_zd = m.nom_zd
                       AND m.planstru_id = ps.ID
                       AND m.npodog_id = d.ID
                       AND ps.region_id = 21
                       AND k.date_kvit >=
                            TO_DATE('01.09.2003', 'dd.mm.yyyy'))
GROUP BY KLS_DOG.dog_number, OPL.dog_id, OPL.data_por, OPL.data_por;


