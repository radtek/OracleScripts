--
-- V_REE_MONTH  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_REE_MONTH
(ORDER_NPR, KIND_NPR, PLAT_NAME, PLATSNP_NAME, FILIAL_NAME, 
 FILIAL_TRANSIT, KINDPROD_NAME, DOG_NUMBER, ABBR_NPR, INPUT_DATE, 
 NOM_ZD, TONN_DECLARED, TONN_LOADED, CIST_LOADED, POLU_NAME, 
 NAIM_REGION, STAN_NAME, GDOR_NAME, FLG_ALLOW_8_AXES, LOAD_ABBR, 
 NORMOTGR, CENA_OTP, PRIM, OST, PLANMOSCOWDOG, 
 PLANMOSCOWDOGWITHFOR, PLANOURDOG, PLANOURDOGWITHFOR, PLANMOSCOWPROD, PLANMOSCOWPRODOPT, 
 PLANOURPROD, PLANOURPRODOPT, FACTDOG, FACTDOGWITHFOR, FACTPROD, 
 ETRAN_NUM, ETRAN_DATE, ETRAN_SOGL, GU12_A_ID, STAN_ID, 
 PROD_ID_NPR, KOD_ISU)
AS 
SELECT
  order_npr,
  TO_CHAR(kls_prod.PROD_PLAN_ID) AS kind_npr,
  plat.PREDPR_NAME AS plat_name,
  NVL(platSNP.Predpr_name,' ') AS platSnp_name,
  NVL(kls_planstru.FOR_NAME,' ') AS Filial_name,
  DECODE(kls_planstru.FOR_ID,1,DECODE(kls_planstru.TIP_REAL_ID,2,'“–¿Õ«»“',' '),' ') AS Filial_transit,
  KLS_PROD_PLAN.NAME_NPR AS kindprod_name,
  kls_dog.DOG_NUMBER,
  kls_prod.ABBR_NPR,
 (SELECT MAX(date_razn) FROM raznar WHERE month.NOM_ZD=raznar.nom_zd) AS INPUT_DATE,
  month.NOM_ZD,
  month.TONN_DECLARED,
  NVL((SELECT SUM(kvit.VES_BRUTTO) FROM kvit WHERE kvit.nom_zd=month.nom_zd
    AND kvit.DATE_OFORML<=V_TEMP_REESTR_PARAMS.DATETIME_REPORT),0) AS tonn_loaded,
  NVL((SELECT COUNT(*) FROM kvit WHERE kvit.nom_zd=month.nom_zd
    AND kvit.DATE_OFORML<=V_TEMP_REESTR_PARAMS.DATETIME_REPORT),0) AS cist_loaded,
  polu.PREDPR_NAME AS polu_name,
  kls_region.REGION_NAME AS naim_region,
  kls_stan.STAN_NAME,
  KLS_GDOR.SHORT_NAME AS gdor_name,
  month.FLG_ALLOW_8_AXES,
  month.LOAD_ABBR,
  kls_prod.NORMOTGR,
  month.CENA_OTP,
  month.PRIM,
  v_ree_rez.OST,
  NVL((SELECT
    SUM(DECODE(NVL(kls_planstru.FOR_ID,0),v_ree_planpost.FOR_ID,v_ree_planpost.PLAN_VES,0))
	FROM v_ree_planpost,kls_prod
	WHERE v_ree_planpost.DATE_PLAN=month.DATE_PLAN AND
	  v_ree_planpost.DOG_ID=month.dog_id AND
	  v_ree_planpost.PROD_PLAN_ID=kls_prod.prod_plan_id AND
	  kls_prod.ID_NPR=month.PROD_ID_NPR AND
	  (v_ree_planpost.plan_id=2 or v_ree_planpost.plan_id=3)),0)
	AS planMoscowDog,
  NVL((SELECT
    SUM(v_ree_planpost.PLAN_VES)
	FROM v_ree_planpost,kls_prod
	WHERE v_ree_planpost.DATE_PLAN=month.DATE_PLAN AND
	  v_ree_planpost.DOG_ID=month.dog_id AND
	  v_ree_planpost.PROD_PLAN_ID=kls_prod.prod_plan_id AND
	  kls_prod.ID_NPR=month.PROD_ID_NPR AND
	  (v_ree_planpost.plan_id=2 or v_ree_planpost.plan_id=3)),0)
	AS planMoscowDogWithFor,
  NVL((SELECT
    SUM(DECODE(NVL(kls_planstru.FOR_ID,0),v_ree_planpost.FOR_ID,v_ree_planpost.PLAN_VES,0))
	FROM v_ree_planpost,kls_prod
	WHERE v_ree_planpost.DATE_PLAN=month.DATE_PLAN AND
	  v_ree_planpost.DOG_ID=month.dog_id AND
	  v_ree_planpost.PROD_PLAN_ID=kls_prod.prod_plan_id AND
	  kls_prod.ID_NPR=month.PROD_ID_NPR AND
	  v_ree_planpost.plan_id=1),0)
	AS planOurDog,
  NVL((SELECT
    SUM(v_ree_planpost.PLAN_VES)
	FROM v_ree_planpost,kls_prod
	WHERE v_ree_planpost.DATE_PLAN=month.DATE_PLAN AND
	  v_ree_planpost.DOG_ID=month.dog_id AND
	  v_ree_planpost.PROD_PLAN_ID=kls_prod.prod_plan_id AND
	  kls_prod.ID_NPR=month.PROD_ID_NPR AND
	  v_ree_planpost.plan_id=1),0)
	AS planOurDogWithFor,
  NVL((SELECT
    SUM(v_ree_planpost.PLAN_VES)
	FROM v_ree_planpost,kls_prod
	WHERE v_ree_planpost.DATE_PLAN=month.DATE_PLAN AND
	  v_ree_planpost.PROD_PLAN_ID=kls_prod.prod_plan_id AND
	  kls_prod.ID_NPR=month.PROD_ID_NPR AND
	  (v_ree_planpost.plan_id=2 or v_ree_planpost.plan_id=3)),0)
	AS planMoscowProd,
  NVL((SELECT
    SUM(v_ree_planpost.PLAN_VES)
	FROM v_ree_planpost,kls_planstru,kls_prod
	WHERE v_ree_planpost.DATE_PLAN=month.DATE_PLAN AND
	  v_ree_planpost.PROD_PLAN_ID=kls_prod.prod_plan_id AND
	  kls_prod.ID_NPR=month.PROD_ID_NPR AND
	  v_ree_planpost.PLANSTRU_ID=kls_planstru.ID and
	  (kls_planstru.KOD_SGR=91 and
	  kls_planstru.KOD_SPG in (10,15) or
	  kls_planstru.KOD_SGR=20) and
	  (v_ree_planpost.plan_id=2 or v_ree_planpost.plan_id=3)),0)
	AS planMoscowProdOpt,
  NVL((SELECT
    SUM(v_ree_planpost.PLAN_VES)
	FROM v_ree_planpost,kls_prod
	WHERE v_ree_planpost.DATE_PLAN=month.DATE_PLAN AND
	  v_ree_planpost.PROD_PLAN_ID=kls_prod.prod_plan_id AND
	  kls_prod.ID_NPR=month.PROD_ID_NPR AND
	  v_ree_planpost.plan_id=1),0)
	AS planOurProd,
  NVL((SELECT
    SUM(v_ree_planpost.PLAN_VES)
	FROM v_ree_planpost,kls_planstru,kls_prod
	WHERE v_ree_planpost.DATE_PLAN=month.DATE_PLAN AND
	  v_ree_planpost.PROD_PLAN_ID=kls_prod.prod_plan_id AND
	  kls_prod.ID_NPR=month.PROD_ID_NPR AND
	  v_ree_planpost.PLANSTRU_ID=kls_planstru.ID and
	  (kls_planstru.KOD_SGR=91 and
	  kls_planstru.KOD_SPG in (10,15) or
	  kls_planstru.KOD_SGR=20) and
	  v_ree_planpost.plan_id=1),0)
	AS planOurProdOpt,
  NVL((SELECT
--    SUM(DECODE(NVL(kls_planstru.FOR_ID,0),0,kvit.ves_brutto,
--	  DECODE(NVL(kls_planstru.FOR_ID,0),ps2.FOR_ID,kvit.ves_brutto,0)))
    SUM(DECODE(NVL(kls_planstru.FOR_ID,0),NVL(ps2.FOR_ID,0),kvit.ves_brutto,0))
	FROM kvit,month m2,kls_planstru ps2,kls_prod,kls_prod pr2
	WHERE month.date_plan=m2.date_plan AND
	  m2.DOG_ID=month.dog_id AND
	  kvit.prod_id_npr=pr2.id_npr AND
	  month.prod_id_npr=kls_prod.ID_NPR AND
	  kls_prod.PROD_PLAN_ID=pr2.PROD_PLAN_ID AND
	  kvit.nom_zd=m2.nom_zd AND
	  m2.planstru_id=ps2.ID AND
	  kvit.DATE_OFORML<=V_TEMP_REESTR_PARAMS.DATETIME_REPORT),0)
	AS factDog,
  NVL((SELECT
    SUM(kvit.ves_brutto)
	FROM kvit,month m2,kls_prod,kls_prod pr2
	WHERE month.date_plan=m2.date_plan AND
	  m2.DOG_ID=month.dog_id AND
	  kvit.prod_id_npr=pr2.id_npr AND
	  month.prod_id_npr=kls_prod.ID_NPR AND
	  kls_prod.PROD_PLAN_ID=pr2.PROD_PLAN_ID AND
	  kvit.nom_zd=m2.nom_zd AND
	  kvit.DATE_OFORML<=V_TEMP_REESTR_PARAMS.DATETIME_REPORT),0)
	AS factDogWithFor,
  NVL((SELECT
    SUM(v_ree_factprod.ves_brutto)
	FROM v_ree_factprod,kls_prod
	WHERE v_ree_factprod.PROD_PLAN_ID=kls_prod.PROD_PLAN_ID and
	  month.PROD_ID_NPR=kls_prod.ID_NPR),0)
	AS factProd,
  gu12_a.NOM_Z,
  gu12_a.REG_DATE,
  gu12_a.SOGL,
  gu12_a.ID,
  KLS_STAN.ID,
  KLS_PROD.ID_NPR,
  zh.kod_isu
  FROM month,kls_predpr plat,kls_predpr polu,kls_dog,
       kls_prod,kls_stan,kls_gdor,kls_prod_plan,kls_region,
       kls_predpr platSnp,kls_dog dogSnp,kls_planstru,
	   V_TEMP_REESTR_PARAMS,v_ree_rez,gu12_a,zakaz_hist zh
  WHERE
    month.gu12_a_id=gu12_a.id(+) and
    month.DOG_ID=kls_dog.ID AND
	kls_dog.PREDPR_ID=plat.ID AND
	month.PROD_ID_NPR=kls_prod.ID_NPR AND
	kls_prod.PROD_PLAN_ID=kls_prod_plan.ID AND
	month.STAN_ID=kls_stan.ID AND
	kls_stan.GDOR_ID=kls_gdor.ID AND
	month.PLANSTRU_ID=kls_planstru.ID AND
	kls_region.ID(+)=kls_stan.region_id AND
	month.POLUCH_ID=polu.ID AND
	month.NPODOG_ID=dogSnp.ID(+) AND
	dogSNP.predpr_ID=platSNP.ID(+) AND
	month.PROD_ID_NPR BETWEEN '10300' AND '99999' AND
	month.date_plan=V_TEMP_REESTR_PARAMS.DATE_PLAN AND
	kls_prod.PROD_PLAN_ID=v_ree_rez.KIND_NPR(+) and
    month.zakaz_hist_id=zh.id(+)
ORDER BY order_npr, kind_npr, plat_name, Filial_name,platSnp_name,Filial_transit,nom_zd;


