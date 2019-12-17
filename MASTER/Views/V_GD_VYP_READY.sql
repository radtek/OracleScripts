--
-- V_GD_VYP_READY  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GD_VYP_READY
(NAIM_GR, NAIM_PR, NORMOTGR, KOD_GR, TIP_OTGR, 
 KOD_NPR, EXPORT, TIP_OTGR_1, KOD_NPR_1, EXPORT_1, 
 PLAN_CIST, PLAN_VES, PLAN_CSOB, PLAN_VSOB, N_PL_C, 
 N_PL_V, N_PL_CS, N_PL_VS, D_PL_C, D_PL_V, 
 D_PL_CS, D_PL_VS, NORM_TOT, NORM_MPS, NORM_SOB, 
 KOD_GDPL, TIP_OTGR_2, KOD_NPR_2, EXPORT_2, KOD_GROTP, 
 GROTP, FACT_MON_C, FACT_MON_T, FACT_SUT_C, F_SOBC_SUT, 
 F_SOBC_MON, F_SOBV_MON, FACT_SUT_T)
AS 
SELECT /*+ RULE */
  kls_prod_gu12.NAME_GDPL AS naim_gr,
  kls_prod.ABBR_NPR as naim_pr,
  kls_prod.NORMOTGR,
  kls_prod_gu12.ID AS kod_gr, 
  a."TIP_OTGR",a."KOD_NPR",a."EXPORT",
  nvl(V_GD_VYP_GDPLAN.TIP_OTGR_1,0) AS TIP_OTGR_1, 
  nvl(V_GD_VYP_GDPLAN.KOD_NPR_1,0) AS KOD_NPR_1, 
  nvl(V_GD_VYP_GDPLAN.EXPORT_1,0) AS EXPORT_1, 
  nvl(V_GD_VYP_GDPLAN.PLAN_CIST,0) AS plan_cist, 
  nvl(V_GD_VYP_GDPLAN.PLAN_VES,0)AS PLAN_VES, 
  nvl(V_GD_VYP_GDPLAN.PLAN_CSOB,0) As PLAN_CSOB, 
  nvl(V_GD_VYP_GDPLAN.PLAN_VSOB,0) as PLAN_VSOB, 
  nvl(V_GD_VYP_GDPLAN.N_PL_C,0) as N_PL_C, 
  nvl(V_GD_VYP_GDPLAN.N_PL_V,0) As N_PL_V, 
  nvl(V_GD_VYP_GDPLAN.N_PL_CS,0) AS N_PL_CS, 
  nvl(V_GD_VYP_GDPLAN.N_PL_VS,0) AS N_PL_VS, 
  nvl(V_GD_VYP_GDPLAN.D_PL_C,0) AS D_PL_C, 
  nvl(V_GD_VYP_GDPLAN.D_PL_V,0) AS D_PL_V, 
  nvl(V_GD_VYP_GDPLAN.D_PL_CS,0) AS D_PL_CS, 
  nvl(V_GD_VYP_GDPLAN.D_PL_VS,0) AS D_PL_VS, 
  nvl(V_GD_VYP_GDPLAN.NORM_TOT,0) AS NORM_TOT, 
  nvl(V_GD_VYP_GDPLAN.NORM_MPS,0) as NORM_MPS, 
  nvl(V_GD_VYP_GDPLAN.NORM_SOB,0) AS NORM_SOB, 
  nvl(V_GD_VYP_GDPLAN.KOD_GDPL,0) As KOD_GDPL, 
  nvl(V_GD_VYP.TIP_OTGR_2,0) AS TIP_OTGR_2, 
  nvl(V_GD_VYP.KOD_NPR_2,0) AS KOD_NPR_2, 
  nvl(V_GD_VYP.EXPORT_2,0) AS EXPORT_2, 
  V_GD_VYP.KOD_GROTP AS KOD_GROTP, 
  V_GD_VYP.GROTP AS GROTP, 
  nvl(V_GD_VYP.FACT_MON_C,0) AS FACT_MON_C, 
  nvl(V_GD_VYP.FACT_MON_T,0) AS FACT_MON_T, 
  nvl(V_GD_VYP.FACT_SUT_C,0) AS FACT_SUT_C, 
  nvl(V_GD_VYP.F_SOBC_SUT,0) AS F_SOBC_SUT, 
  nvl(V_GD_VYP.F_SOBC_MON,0) AS F_SOBC_MON, 
  nvl(V_GD_VYP.F_SOBV_MON,0) AS F_SOBV_MON, 
  nvl(V_GD_VYP.FACT_SUT_T,0) AS FACT_SUT_T
  FROM
(SELECT DISTINCT * FROM
(SELECT tip_otgr_2 AS tip_otgr,kod_npr_2 AS kod_npr, export_2 AS export FROM V_GD_VYP
 UNION ALL
 SELECT tip_otgr_1,kod_npr_1,export_1 FROM V_GD_VYP_GDPLAN)) a,V_GD_VYP_GDPLAN,V_GD_VYP,kls_prod,kls_prod_gu12
 WHERE 
   a.tip_otgr=V_GD_VYP_GDPLAN.tip_otgr_1(+) and
   a.kod_npr=V_GD_VYP_GDPLAN.kod_npr_1(+) and
   a.export=V_GD_VYP_GDPLAN.export_1(+) and
   a.tip_otgr=V_GD_VYP.tip_otgr_2(+) and
   a.kod_npr=V_GD_VYP.kod_npr_2(+) and
   a.export=V_GD_VYP.export_2(+) and
   a.kod_npr=kls_prod.ID_NPR and
   kls_prod.PROD_GU12_ID=kls_prod_gu12.ID
ORDER BY
  TIP_OTGR,ORDER_GDPL,EXPORT;


