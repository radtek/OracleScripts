--
-- V_REE_MONTH_MOSCOW  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_REE_MONTH_MOSCOW
(ORDER_NPR, KIND_NPR, PLAT_NAME, PLATSNP_NAME, FILIAL_NAME, 
 FILIAL_TRANSIT, KINDPROD_NAME, DOG_NUMBER, ABBR_NPR, INPUT_DATE, 
 NOM_ZD, TONN_DECLARED, TONN_LOADED, CIST_LOADED, POLU_NAME, 
 NAIM_REGION, STAN_NAME, GDOR_NAME, FLG_ALLOW_8_AXES, LOAD_ABBR, 
 NORMOTGR, CENA_OTP, PRIM, OST, PLANMOSCOWDOG, 
 PLANMOSCOWDOGWITHFOR, PLANOURDOG, PLANOURDOGWITHFOR, PLANMOSCOWPROD, PLANMOSCOWPRODOPT, 
 PLANOURPROD, PLANOURPRODOPT, FACTDOG, FACTDOGWITHFOR, FACTPROD, 
 ETRAN_NUM, ETRAN_DATE, ETRAN_SOGL, GU12_A_ID, STAN_ID, 
 PROD_ID_NPR, KOD_ISU, TONN_REE, PRIORITY, GU12_GRAFIK, 
 GU12_LOAD_ABBR)
AS 
SELECT
  A."ORDER_NPR",A."KIND_NPR",A."PLAT_NAME",A."PLATSNP_NAME",A."FILIAL_NAME",A."FILIAL_TRANSIT",A."KINDPROD_NAME",A."DOG_NUMBER",A."ABBR_NPR",A."INPUT_DATE",A."NOM_ZD",A."TONN_DECLARED",A."TONN_LOADED",A."CIST_LOADED",A."POLU_NAME",A."NAIM_REGION",A."STAN_NAME",A."GDOR_NAME",A."FLG_ALLOW_8_AXES",A."LOAD_ABBR",A."NORMOTGR",A."CENA_OTP",A."PRIM",A."OST",A."PLANMOSCOWDOG",A."PLANMOSCOWDOGWITHFOR",A."PLANOURDOG",A."PLANOURDOGWITHFOR",A."PLANMOSCOWPROD",A."PLANMOSCOWPRODOPT",A."PLANOURPROD",A."PLANOURPRODOPT",A."FACTDOG",A."FACTDOGWITHFOR",A."FACTPROD",A."ETRAN_NUM",A."ETRAN_DATE",A."ETRAN_SOGL",A."GU12_A_ID",A."STAN_ID",A."PROD_ID_NPR",A."KOD_ISU",
  C.TONN_MOS as TONN_REE,
  C.PRIORITY
  , for_reestr.GrafikToStr(a.NOM_ZD,e.GRAFIK_TO) as GU12_GRAFIK
  , for_reestr.GetLoadAbbr(a.NOM_ZD) as GU12_LOAD_ABBR
FROM V_REE_MONTH A, MONTH_REESTR B, MONTH_REESTR_POS C, V_TEMP_REESTR_PARAMS E
-- � ������ ������������
WHERE B.DATE_REE=E.DATE_REE
  AND B.DOP_REE=0 -- ������ ��������
  AND B.ID=C.MONTH_REESTR_ID
  AND C.NOM_ZD=A.NOM_ZD;


