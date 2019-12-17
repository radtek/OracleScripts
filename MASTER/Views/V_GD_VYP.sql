--
-- V_GD_VYP  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GD_VYP
(TIP_OTGR_2, KOD_NPR_2, EXPORT_2, KOD_GROTP, GROTP, 
 FACT_MON_C, FACT_MON_T, FACT_SUT_C, F_SOBC_SUT, F_SOBC_MON, 
 F_SOBV_MON, FACT_SUT_T)
AS 
SELECT /*+ RULE */
  kls_vid_otgr.LOAD_TYPE_ID AS tip_otgr_2,
  kvit.PROD_ID_NPR AS kod_npr_2,
  DECODE(month.NAZN_OTG_ID,5,2,1) AS export_2,
  month.GROTP_ID AS kod_grotp,
  kls_tex_pd.GROTP_SHORT_NAME AS grotp,
  COUNT(*) AS fact_mon_c,
  SUM(kvit.ves_brutto) AS fact_mon_t,
  SUM(DECODE(SIGN(kvit.DATE_OFORML-(V_TEMP_VYP_GD_PARAMS.END_DATE-7/24)),1,1,0,1,0)) AS fact_sut_c,
  SUM(DECODE(SIGN(kvit.DATE_OFORML-(V_TEMP_VYP_GD_PARAMS.END_DATE-7/24)),1,DECODE(kvit.vagowner_id,3,0,1),0,DECODE(kvit.vagowner_id,3,0,1),0)) AS f_sobc_sut,
  SUM(DECODE(kvit.vagowner_id,3,0,1)) AS f_sobc_mon,
  SUM(DECODE(kvit.vagowner_id,3,0,kvit.ves_brutto)) AS f_sobv_mon,
  SUM(DECODE(SIGN(kvit.DATE_OFORML-(V_TEMP_VYP_GD_PARAMS.END_DATE-7/24)),1,kvit.ves_brutto,0,kvit.ves_brutto,0)) AS fact_sut_t
  FROM kvit,month,kls_vid_otgr,kls_prod,kls_prod kls_prod_gr,kls_tex_pd,kls_prod_plan,V_TEMP_VYP_GD_PARAMS
    where
   kvit.NOM_ZD=month.NOM_ZD and
   month.LOAD_ABBR=kls_vid_otgr.LOAD_ABBR and
   kvit.PROD_ID_NPR=kls_prod.ID_NPR and
   kls_prod.ID_GROUP_NPR=kls_prod_gr.ID_NPR and
   month.TEX_PD_ID=kls_tex_pd.ID and
   month.GROTP_ID=kls_tex_pd.GROTP_ID and
   kls_prod.PROD_PLAN_ID=kls_prod_plan.ID and
   kls_vid_otgr.LOAD_TYPE_ID<>5 and
   kvit.DATE_OFORML between
     V_TEMP_VYP_GD_PARAMS.BEGIN_DATE-7/24 and -- с 17:00
     V_TEMP_VYP_GD_PARAMS.END_DATE+(17*60*60-1)/(24*60*60) -- по 16:59:59
GROUP BY
  kls_vid_otgr.LOAD_TYPE_ID,
  kvit.PROD_ID_NPR,
  DECODE(month.NAZN_OTG_ID,5,2,1),
  kls_prod.NORMOTGR,
  kls_prod_gr.ID_NPR,
  month.GROTP_ID,
  kls_tex_pd.GROTP_SHORT_NAME;


