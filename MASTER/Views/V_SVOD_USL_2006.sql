--
-- V_SVOD_USL_2006  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_SVOD_USL_2006
(PROD_ID_NPR, PROD_NAME, VES, ED_IZ, SUMMA_BN, 
 SUMMA_NDS, SUMMA)
AS 
SELECT 
  a.PROD_ID_NPR, 
  KLS_PROD.SF_NAME as PROD_NAME, 
  SUM(VES) as VES, 
  MAX(a.ED_IZ) as ED_IZ, 
  SUM(SUMMA_BN) as SUMMA_BN, 
  SUM(SUMMA_NDS) as SUMMA_NDS, 
  SUM(SUMMA) as SUMMA 
FROM 
( 
SELECT 
  /************** ВОЗНАГРАЖДЕНИЕ **********************/ 
  '10001' as PROD_ID_NPR, 
  SUM(b.VES) as VES, 
  ' ТН ' as ED_IZ, 
  SUM(a.summa_bn) as summa_bn, 
  SUM(a.summa_nds) as summa_nds, 
  SUM(a.summa) as summa 
FROM 
( 
SELECT /*+ rule */ 
  -- позиции "Вознаграждение" 
  bills.NOM_DOK, 
  SUM(summa_bn) as summa_bn, 
  SUM(summa_nds20) as summa_nds, 
  SUM(summa) as summa 
FROM BILLS, BILL_POS, V_MASTER_REPORTS B 
WHERE (UPPER(B.REPORT_FILE)='SVOD_USL_2006.XLS') 
  AND bills.DATE_KVIT>=B.BEGIN_DATE 
  AND bills.DATE_KVIT<=B.END_DATE 
  AND bills.NOM_DOK=bill_pos.nom_dok 
  AND bill_pos.PROD_ID_NPR in ('10011','10012') 
  AND bill_pos.is_luk+0=0 
GROUP BY 
  bills.NOM_DOK 
) a, 
( 
SELECT /*+ rule */ 
  -- позиции "Товар" 
  bills.NOM_DOK, 
  SUM(bill_pos.VES) as VES 
FROM BILLS, BILL_POS, V_MASTER_REPORTS B, MONTH, KLS_VID_OTGR 
WHERE (UPPER(B.REPORT_FILE)='SVOD_USL_2006.XLS') 
  AND bills.DATE_KVIT>=B.BEGIN_DATE 
  AND bills.DATE_KVIT<=B.END_DATE 
  AND bills.NOM_DOK=bill_pos.nom_dok 
  AND bill_pos.PROD_ID_NPR>='10100' 
  AND bill_pos.is_luk+0=1 
  AND BILLS.IS_AGENT IN (2,4,5) 
  AND BILLS.NOM_ZD = MONTH.NOM_ZD 
  AND MONTH.LOAD_ABBR=KLS_VID_OTGR.LOAD_ABBR 
  AND KLS_VID_OTGR.LOAD_TYPE_ID IN (1,4,6) 
GROUP BY 
  bills.NOM_DOK 
) b 
WHERE b.nom_dok=a.nom_dok(+) 
-- 
UNION ALL 
-- 
SELECT 
  /************** ТАРИФ **********************/ 
  '10006' as PROD_ID_NPR, 
  SUM(a.VES) as VES, 
  ' ТН ' as ED_IZ, 
  SUM(a.summa_bn) as summa_bn, 
  SUM(a.summa_nds) as summa_nds, 
  SUM(a.summa) as summa 
FROM 
( 
SELECT 
  NOM_DOK, 
  KVIT_ID, 
  MAX(VES) AS VES, 
  SUM(SUMMA_BN) as SUMMA_BN, 
  SUM(SUMMA_NDS) as SUMMA_NDS, 
  SUM(SUMMA) as SUMMA 
FROM 
( 
  -- Вознаграждение + продукт + страховка (по DATE_KVIT) 
  SELECT /*+ RULE */ 
    BILLS.NOM_DOK, 
    KVIT.ID as KVIT_ID, 
    KVIT.VES_BRUTTO AS VES, 
 0 as SUMMA_BN, 
 0 as SUMMA_NDS, 
 0 as SUMMA 
  FROM (select * from V_MASTER_REPORTS where UPPER(REPORT_FILE)='SVOD_USL_2006.XLS') r, 
    BILLS, KVIT, MONTH, KLS_VID_OTGR 
  WHERE BILLS.NOM_DOK = KVIT.BILL_ID 
    AND KVIT.DATE_KVIT BETWEEN r.BEGIN_DATE AND r.END_DATE 
    AND BILLS.IS_AGENT IN (2,4,5) 
    AND BILLS.NOM_ZD = MONTH.NOM_ZD 
    AND MONTH.LOAD_ABBR=KLS_VID_OTGR.LOAD_ABBR 
    AND KLS_VID_OTGR.LOAD_TYPE_ID IN (1,4,6) 
  UNION ALL 
  -- Тариф (по дате счета от РЖД) 
  SELECT /*+ RULE */ 
    BILLS.NOM_DOK, 
    KVIT.ID as KVIT_ID, 
    KVIT.VES_BRUTTO AS VES, 
    NVL(KVIT.TARIF,0)+NVL(KVIT.TARIF_GUARD,0) AS SUMMA_BN, 
    NVL(KVIT.TARIF_NDS,0)+NVL(KVIT.TARIF_GUARD_NDS,0) AS SUMMA_NDS, 
    NVL(KVIT.TARIF,0)+NVL(KVIT.TARIF_GUARD,0)+NVL(KVIT.TARIF_NDS,0)+NVL(KVIT.TARIF_GUARD_NDS,0) AS SUMMA 
  FROM 
    BILLS, KVIT, MONTH, KLS_VID_OTGR, 
    (SELECT distinct nom_perech,dat_perech 
       FROM (select * from V_MASTER_REPORTS where UPPER(REPORT_FILE)='SVOD_USL_2006.XLS') r,REESTR_RAIL_RGD_SF 
      WHERE DATE_SCH BETWEEN r.BEGIN_DATE AND r.END_DATE -- По дате счета РЖД 
        AND r21=95) rail_sf 
  WHERE BILLS.NOM_DOK = KVIT.BILL_ID 
    AND KVIT.PERECH_TEXPD_DATE=rail_sf.dat_perech 
    AND KVIT.PERECH_TEXPD_NUM=rail_sf.nom_perech 
    AND BILLS.IS_AGENT IN (2,4,5) 
    AND BILLS.NOM_ZD = MONTH.NOM_ZD 
    AND MONTH.LOAD_ABBR=KLS_VID_OTGR.LOAD_ABBR 
    AND KLS_VID_OTGR.LOAD_TYPE_ID IN (1,4,6) 
) 
GROUP BY 
  NOM_DOK, 
  KVIT_ID 
) a 
-- 
UNION ALL 
-- 
SELECT /*+ rule */ 
  /************** ПРОЧИЕ УСЛУГИ **********************/ 
  bills.PROD_ID_NPR, 
  SUM(bill_pos.VES) as VES, 
  KLS_PROD.ED_IZ, 
  SUM(bill_pos.SUMMA_BN) as SUMMA_BN, 
  SUM(bill_pos.SUMMA_NDS20) as SUMMA_NDS, 
  SUM(bill_pos.SUMMA) as SUMMA 
FROM bills, BILL_POS, KLS_PROD, V_MASTER_REPORTS B, KLS_DOG 
WHERE (UPPER(B.REPORT_FILE)='SVOD_USL_2006.XLS') 
  AND bills.DATE_KVIT>=B.BEGIN_DATE 
  AND bills.DATE_KVIT<=B.END_DATE 
  AND bills.NOM_DOK=bill_pos.nom_dok 
  AND bill_pos.PROD_ID_NPR=kls_prod.id_npr 
  AND bills.PROD_ID_NPR<'10100' AND bills.PROD_ID_NPR NOT LIKE '1009%' 
  AND bills.PROD_ID_NPR not in ('10003','10006','10080') 
  AND bill_pos.is_luk+0=1 
  AND bills.DOG_ID=KLS_DOG.ID 
  AND KLS_DOG.SHORT_NUMBER NOT IN ('0411498','0411565') 
GROUP BY 
  bills.PROD_ID_NPR, 
  KLS_PROD.ED_IZ 
) a, KLS_PROD 
WHERE a.PROD_ID_NPR=KLS_PROD.ID_NPR 
GROUP BY a.PROD_ID_NPR,KLS_PROD.SF_NAME 
ORDER BY PROD_ID_NPR;


