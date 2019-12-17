--
-- V_R3_CHECK_BILLS  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_R3_CHECK_BILLS
(IS_AGENT, NOM_DOK, OLD_NOM_DOK, NPO_NOM_SF, NPO_OLD_NOM_SF, 
 NPO_DATE_VYP_SF, NPO_DATE_KVIT, NPO_DOG_NUMBER, NPO_KOL_DN, NPO_NAME_NPR, 
 NPO_VES, NPO_CENA, NPO_PROD_BN, NPO_PROD_NDS, NPO_PROD, 
 NPO_TARIF_BN, NPO_TARIF_NDS, NPO_TARIF, NPO_VOZN_BN, NPO_VOZN_NDS, 
 NPO_VOZN, NPO_STRAH, NPO_SUMMA_DOK, R3_VBELN, R3_NOM_SF, 
 R3_DATE_VYP_SF, R3_NAME_NPR, R3_VES, R3_PROD_BN, R3_PROD_NDS, 
 R3_PROD, R3_TARIF_BN, R3_TARIF_NDS, R3_TARIF, R3_VOZN_BN, 
 R3_VOZN_NDS, R3_VOZN, R3_STRAH, R3_SUMMA_DOK)
AS 
SELECT
  NVL(KLS_VIDDOG.IS_AGENT,3) AS IS_AGENT,
  V_BILLS.NOM_DOK,
  V_BILLS.OLD_NOM_DOK,
  V_BILLS.ORIG_NOM_SF AS NPO_NOM_SF,
  V_BILLS.OLD_NOM_SF AS NPO_OLD_NOM_SF,
  V_BILLS.DATE_VYP_SF AS NPO_DATE_VYP_SF,
  V_BILLS.DATE_KVIT AS NPO_DATE_KVIT,
  KLS_DOG.DOG_NUMBER AS NPO_DOG_NUMBER,
  V_BILLS.KOL_DN AS NPO_KOL_DN,
  KLS_PROD.NAME_NPR AS NPO_NAME_NPR,
  V_BILL_POS_FLAT.VES AS NPO_VES,
  V_BILL_POS_FLAT.CENA_BN AS NPO_CENA,
  V_BILL_POS_FLAT.SUMMA_PROD_BN AS NPO_PROD_BN,
  V_BILL_POS_FLAT.SUMMA_PROD_NDS AS NPO_PROD_NDS,
  V_BILL_POS_FLAT.SUMMA_PROD AS NPO_PROD,
  V_BILL_POS_FLAT.TARIF_BN AS NPO_TARIF_BN,
  V_BILL_POS_FLAT.TARIF_NDS AS NPO_TARIF_NDS,
  V_BILL_POS_FLAT.TARIF AS NPO_TARIF,
  V_BILL_POS_FLAT.VOZN11_BN+V_BILL_POS_FLAT.VOZN12_BN AS NPO_VOZN_BN,
  V_BILL_POS_FLAT.VOZN11_NDS+V_BILL_POS_FLAT.VOZN12_NDS AS NPO_VOZN_NDS,
  V_BILL_POS_FLAT.VOZN11+V_BILL_POS_FLAT.VOZN12 AS NPO_VOZN,
  V_BILL_POS_FLAT.STRAH AS NPO_STRAH,
  V_BILLS.SUMMA_DOK AS NPO_SUMMA_DOK,
  R3_BILLS.VBELN AS R3_VBELN,
  R3_BILLS.NOM_R3 AS R3_NOM_SF,
  R3_BILLS.DATE_VYP_SF AS R3_DATE_VYP_SF,
  R3_MATERIALS.MAKTX AS R3_NAME_NPR,
  R3_BILLS.VES AS R3_VES,
  R3_BILLS.SUMMA_PROD-R3_BILLS.SUMMA_PROD_NDS AS R3_PROD_BN,
  R3_BILLS.SUMMA_PROD_NDS AS R3_PROD_NDS,
  R3_BILLS.SUMMA_PROD AS R3_PROD,
  R3_BILLS.SUMMA_TARIF-R3_BILLS.SUMMA_TARIF_NDS AS R3_TARIF_BN,
  R3_BILLS.SUMMA_TARIF_NDS AS R3_TARIF_NDS,
  R3_BILLS.SUMMA_TARIF AS R3_TARIF,
  R3_BILLS.SUMMA_VOZN-R3_BILLS.SUMMA_VOZN_NDS AS R3_VOZN_BN,
  R3_BILLS.SUMMA_VOZN_NDS AS R3_VOZN_NDS,
  R3_BILLS.SUMMA_VOZN AS R3_VOZN,
  R3_BILLS.SUMMA_STRAH AS R3_STRAH,
  R3_BILLS.SUMMA_DOK AS R3_SUMMA_DOK
FROM V_BILLS,V_BILL_POS_FLAT,R3_BILLS,KLS_DOG,KLS_PROD,R3_MATERIALS, KLS_DOG MAIN_DOG,KLS_VIDDOG
WHERE V_BILLS.NOM_DOK=V_BILL_POS_FLAT.NOM_DOK
AND V_BILLS.DOG_ID=KLS_DOG.ID
AND V_BILLS.PROD_ID_NPR=KLS_PROD.ID_NPR
AND V_BILLS.NOM_DOK=R3_BILLS.NOM_DOK(+)
AND R3_BILLS.VBAP_MATNR=R3_MATERIALS.VBAP_MATNR(+)
AND V_BILLS.DATE_KVIT>=TO_DATE('01.01.2003','dd.mm.yyyy')
AND KLS_DOG.MAINDOG_ID=MAIN_DOG.ID(+)
AND MAIN_DOG.VIDDOG_ID=KLS_VIDDOG.ID(+);


