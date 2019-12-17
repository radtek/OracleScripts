--
-- V_DISPSEND_SF  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_DISPSEND_SF
(KOD_PLAT, NOM_DOG, NOM_SF, DATA_DOK, PROD_ID_NPR, 
 NAIM_PR, DATA_KVIT, VES, CENA_NFP, D_41, 
 D_191, ALL_TARIF, ALL_TARIF_NDS, D_441, D_194, 
 DOP_TARIF, NDC_DOPTAR, D_442, NDC_TR20, SUM_NALIV, 
 NDC_NAL20, SUM_NACEN, SUMMA_DOK, NOM_DOK, PLAT_NAIM, 
 POLUCH_NAIM, POLUCH_ADDR, STAN_NAIM, STAN_KOD, NP, 
 POLUCH_KSSS, PROD_KSSS)
AS 
SELECT /*+ RULE */
  kls_dog.PREDPR_ID,
  kls_dog.DOG_NUMBER,
  bills.NOM_SF,
  bills.DATE_VYP_SF,
  bills.PROD_ID_NPR,
  kls_prod.NAME_NPR,
  bills.DATE_KVIT,
  SUM(DECODE(SIGN(bill_pos.BILL_POS_ID-10),-1,bill_pos.VES,0)) AS ves,
  SUM(DECODE(bill_pos.BILL_POS_ID,1,bill_pos.CENA_BN,0)) AS cena_bn,
  SUM(DECODE(SIGN(bill_pos.BILL_POS_ID-10),-1,bill_pos.SUMMA-bill_pos.SUMMA_NDS20,0)) AS summa_prod_bn,
  SUM(DECODE(SIGN(bill_pos.BILL_POS_ID-10),-1,bill_pos.SUMMA_NDS20,0)) AS summa_prod_nds,
  SUM(DECODE(bill_pos.BILL_POS_ID,10,bill_pos.SUMMA_BN,13,bill_pos.SUMMA_BN,0)) AS summa_tarif,
  SUM(DECODE(bill_pos.BILL_POS_ID,10,bill_pos.SUMMA_NDS20,13,bill_pos.SUMMA_NDS20,0)) AS summa_tarif_nds,
  SUM(DECODE(bill_pos.BILL_POS_ID,10,bill_pos.SUMMA_BN,0)) AS summa_tarif_clr,
  SUM(DECODE(bill_pos.BILL_POS_ID,10,bill_pos.SUMMA_NDS20,0)) AS summa_tarif_clr_nds,
  SUM(DECODE(bill_pos.BILL_POS_ID,13,bill_pos.SUMMA_BN,0)) AS summa_ohrana,
  SUM(DECODE(bill_pos.BILL_POS_ID,13,bill_pos.SUMMA_NDS20,0)) AS summa_ohrana_nds,
  SUM(DECODE(bill_pos.BILL_POS_ID,12,bill_pos.SUMMA_BN,0)) AS summa_agen1,
  SUM(DECODE(bill_pos.BILL_POS_ID,12,bill_pos.SUMMA_NDS20,0)) AS summa_agen1_nds,
  SUM(DECODE(bill_pos.BILL_POS_ID,11,bill_pos.SUMMA_BN,0)) AS summa_agen2,
  SUM(DECODE(bill_pos.BILL_POS_ID,11,bill_pos.SUMMA_NDS20,0)) AS summa_agen2_nds,
  SUM(DECODE(bill_pos.BILL_POS_ID,20,bill_pos.SUMMA,0)) AS summa_strah,
  bills.SUMMA_DOK,
  bills.NOM_DOK,
  plat.PREDPR_NAME,
  poluch.PREDPR_NAME,
  GET_ADDR(KLS_REGION.ID,POLUCH.POSTINDEX_P,POLUCH.CITY_P,POLUCH.ADDRESS_P,KLS_REGION.REGION_NAME) as POLUCH_ADDR,
  kls_stan.STAN_NAME,
  kls_stan.STAN_KOD,
  KV.SVED_NUM,
  poluch.KSSS_PREDPR_ID as poluch_KSSS,
  kls_prod.KSSS_PROD_ID as prod_KSSS
FROM bills, kls_predpr plat, kls_predpr poluch, kls_stan, kls_dog, month, kls_prod, bill_pos, KLS_REGION,
  (SELECT KVIT.BILL_ID,
          MAX(KVIT.SVED_NUM) AS SVED_NUM
   FROM KVIT
 GROUP BY KVIT.BILL_ID) KV
WHERE bills.nom_dok = KV.BILL_ID (+)
  AND bill_pos.NOM_DOK = bills.NOM_DOK
  AND bills.DOG_ID = KLS_DOG.ID
  AND KLS_DOG.PREDPR_ID = plat.ID
  AND bills.NOM_ZD = month.NOM_ZD (+)
  AND month.POLUCH_ID = poluch.ID (+)
  and poluch.REGION_ID = KLS_REGION.ID (+)
  AND month.STAN_ID = kls_stan.ID (+)
  AND bills.PROD_ID_NPR = kls_prod.ID_NPR (+)
  AND bills.DATE_VYP_SF>=TO_DATE('01.01.2006','dd.mm.yyyy')
GROUP BY kls_dog.PREDPR_ID,
  plat.PREDPR_NAME,
  kls_dog.DOG_NUMBER,
  poluch.PREDPR_NAME,
  GET_ADDR(KLS_REGION.ID,POLUCH.POSTINDEX_P,POLUCH.CITY_P,POLUCH.ADDRESS_P,KLS_REGION.REGION_NAME),
  kls_stan.STAN_NAME,
  kls_stan.STAN_KOD,
  bills.DATE_VYP_SF,
  bills.NOM_DOK,
  bills.NOM_SF,
  bills.PROD_ID_NPR,
  kls_prod.NAME_NPR,
  bills.DATE_KVIT,
  bills.SUMMA_DOK,
  KV.SVED_NUM,
  poluch.KSSS_PREDPR_ID,
  kls_prod.KSSS_PROD_ID;


