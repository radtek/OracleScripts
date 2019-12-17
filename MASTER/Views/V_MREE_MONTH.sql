--
-- V_MREE_MONTH  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_MREE_MONTH
(PROD_PLAN_ID, ABBR_NPR, DOG_ID, FOR_ID, LOAD_TYPE_ID, 
 TYPE_OTGR_NAME, NOM_ZD, OTHER, INPUT_DATE, UPDATE_DATE, 
 TONN_DECLARED, TONN_LOADED, CIST_DECLARED, CIST_LOADED, PRIM, 
 POLUCH_NAME, STAN_NAME, PREDPR_NPO, ZAKAZ_ID, ZAKAZ_NUM, 
 ZAKAZ_DATE, ZAKAZ_VOL, ETRAN_NUM, ETRAN_DATE, KOD_ISU)
AS 
SELECT /*+ RULE */ 
  kls_prod.prod_plan_id, 
  kls_prod.ABBR_NPR, 
  month.dog_id, 
  kls_planstru.FOR_ID, 
  kls_load_type.ID AS load_type_id, 
  kls_load_type.TYPE_OTGR_NAME, 
  month.nom_zd, 
  DECODE(kls_planstru.KOD_SGR,91,DECODE(kls_planstru.KOD_SPG,10,1,0),0) AS other, 
  month.INPUT_DATE, 
  month.UPDATE_DATE, 
  NVL(month.tonn_RAZNAR,month.TONN_DECLARED) as TONN_DECLARED, 
  NVL((SELECT SUM(ves_brutto) FROM kvit where nom_zd=month.nom_zd),0) AS TONN_LOADED, 
  NVL(month.cist_raznar,NVL(DECODE(kls_load_type.ID,1,month.TONN_DECLARED,0)/kls_prod.normotgr,0)) AS cist_declared,
  NVL((SELECT SUM(DECODE(kls_load_type.ID,1,1,0)) FROM kvit where nom_zd=month.nom_zd),0) AS cist_LOADED, 
  month.prim, 
  kls_predpr.PREDPR_NAME AS poluch_name, 
  kls_stan.stan_name || ' ' || kls_gdor.SHORT_NAME AS stan_name, 
  plat.predpr_name AS predpr_npo, 
  month_all.ID AS zakaz_id, 
  month_all.INPUT_NUMBER AS zakaz_num, 
  month_all.INPUT_DATE AS zakaz_date, 
  month_all.REQUEST as zakaz_vol, 
  gu12_a.NOM_Z as etran_num, 
  gu12_a.REG_DATE as etran_date,
  zh.kod_isu 
  FROM month,kls_prod,kls_planstru,kls_stan,kls_predpr,kls_gdor,kls_load_type, 
    KLS_VID_OTGR,V_TEMP_MREESTR_PARAMS,kls_dog,kls_predpr plat,month_all,gu12_a,zakaz_hist zh 
  WHERE 
    month.DATE_PLAN=V_TEMP_MREESTR_PARAMS.DATE_PLAN AND 
	month.ZAKAZ_ID=month_all.ID(+) and 
	month.GU12_A_ID=gu12_a.ID(+) and 
	kls_prod.ID_NPR=month.PROD_ID_NPR AND 
	month.PLANSTRU_ID=kls_planstru.ID AND 
	month.STAN_ID=kls_stan.ID AND 
	month.POLUCH_ID=kls_predpr.ID AND 
	kls_stan.gdor_id=kls_gdor.ID AND 
	month.LOAD_ABBR=KLS_VID_OTGR.LOAD_ABBR AND 
	KLS_VID_OTGR.LOAD_TYPE_ID=kls_load_type.ID AND 
	month.npodog_id=kls_dog.id(+) AND 
	kls_dog.predpr_id=plat.id(+) AND
    month.ZAKAZ_HIST_ID=zh.id(+);


