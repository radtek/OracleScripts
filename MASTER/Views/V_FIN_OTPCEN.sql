--
-- V_FIN_OTPCEN  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FIN_OTPCEN
(ID_NPR, NAME_NPR, CAT_CEN_ID, CAT_CEN_NAME, ID, 
 CENA_BN, CENA, AKCIZ, NDS20, NGSM25, 
 CENA_OTP, BEGIN_DATE, END_DATE, PROD_ID_NPR, OWNERSHIP_ID, 
 OWNERSHIP_NAME, SUPPLIER, SUPPLIER_ID, PROTOKOL_NUM, PROTOKOL_DATE, 
 IS_ORIGINAL, PROTOKOL_BEGIN_DATE, CENA_NPO, CENA_OTP_NPO, NDS20_NPO, 
 NO_AKCIZ, PLAT_ID)
AS 
SELECT /*+ ORDERED USE_NL(NPR_PRICES, KLS_CAT_CEN, KLS_PROD, KLS_OWNERSHIP, KLS_PREDPR SUPPLIER, PREDPR_ROLE) */
  KLS_PROD.ID_NPR,
  KLS_PROD.NAME_NPR,
  KLS_CAT_CEN.ID AS CAT_CEN_ID,
  KLS_CAT_CEN.CAT_CEN_NAME,
  NPR_PRICES.ID,
  NPR_PRICES.CENA_BN,
  NPR_PRICES.CENA,
  NPR_PRICES.AKCIZ,
  NPR_PRICES.NDS20,
  NPR_PRICES.NGSM25,
  NPR_PRICES.CENA_OTP,
  NPR_PRICES.BEGIN_DATE,
  NPR_PRICES.END_DATE,
  NPR_PRICES.PROD_ID_NPR,
  NPR_PRICES.OWNERSHIP_ID,
  KLS_OWNERSHIP.OWNERSHIP_NAME,
  SUPPLIER.PREDPR_NAME AS supplier,
  SUPPLIER_ID,protokol_num,protokol_date,is_original,protokol_begin_date,cena_npo,cena_otp_npo,nds20_npo,no_akciz,kls_cat_cen.PREDPR_ID as PLAT_ID
FROM NPR_PRICES, KLS_CAT_CEN, KLS_PROD, KLS_OWNERSHIP, KLS_PREDPR SUPPLIER, PREDPR_ROLE,
(SELECT DISTINCT DECODE(app_users.unp,1,TO_DATE('01.01.2020','dd.mm.yyyy'),TO_DATE('31.12.2004','dd.mm.yyyy')) AS EndDate FROM app_users WHERE app_users.NETNAME=For_Init.GetCurrUser) a
WHERE ((NPR_PRICES.CAT_CEN_ID = KLS_CAT_CEN.ID) AND
       (NPR_PRICES.PROD_ID_NPR = KLS_PROD.ID_NPR) AND
       (NPR_PRICES.OWNERSHIP_ID=KLS_OWNERSHIP.ID) AND
	   (NPR_PRICES.SUPPLIER_ID=SUPPLIER.ID) AND
	   (PREDPR_ROLE.PREDPR_ID=SUPPLIER.ID) AND
	   (PREDPR_ROLE.KLS_ROLE_ID=1)) AND
	   (NPR_PRICES.BEGIN_DATE<=a.EndDate or KLS_CAT_CEN.PREDPR_ID=2641);


