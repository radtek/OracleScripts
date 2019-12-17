--
-- V_MREE_REESTR  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_MREE_REESTR
(IS_ZAKAZ, ORDER_NPR, PROD_PLAN_ID, NAME_NPR, DOG_ID, 
 DOG_NUMBER, GROUPDOG_ID, PLAT_ID, PLAT_NAME, FOR_ID, 
 FOR_NAME, LOAD_TYPE_ID, TYPE_OTGR_NAME, OTHER, NOM_ZD, 
 INPUT_DATE, ABBR_NPR, TONN_DECLARED, TONN_LOADED, CIST_DECLARED, 
 CIST_LOADED, PRIM, POLUCH_NAME, STAN_NAME, PREDPR_NPO, 
 ZAKAZ_NUM, ZAKAZ_DATE, ZAKAZ_VOL, ZAKAZ_ID, ETRAN_NUM, 
 ETRAN_DATE, PLANMOSCOWDOG, PLANMOSCOWDOGWITHFOR, PLANMOSCOWPROD, PLANMOSCOWPRODOPT, 
 PLANMOSCOWPRODOPTCLEAN, PLANMOSCOWPRODOPTKOMI, PLANMOSCOWPRODOPTARH, PLANOURDOG, PLANOURDOGWITHFOR, 
 PLANOURPROD, PLANOURPRODOPT, PLANOURPRODOPTCLEAN, PLANOURPRODOPTKOMI, PLANOURPRODOPTARH, 
 GU12_LOAD_ABBR, KOD_ISU)
AS 
SELECT "IS_ZAKAZ","ORDER_NPR","PROD_PLAN_ID","NAME_NPR","DOG_ID","DOG_NUMBER","GROUPDOG_ID","PLAT_ID","PLAT_NAME","FOR_ID","FOR_NAME","LOAD_TYPE_ID","TYPE_OTGR_NAME","OTHER","NOM_ZD","INPUT_DATE","ABBR_NPR","TONN_DECLARED","TONN_LOADED","CIST_DECLARED","CIST_LOADED","PRIM","POLUCH_NAME","STAN_NAME","PREDPR_NPO","ZAKAZ_NUM","ZAKAZ_DATE","ZAKAZ_VOL","ZAKAZ_ID","ETRAN_NUM","ETRAN_DATE","PLANMOSCOWDOG","PLANMOSCOWDOGWITHFOR","PLANMOSCOWPROD","PLANMOSCOWPRODOPT","PLANMOSCOWPRODOPTCLEAN","PLANMOSCOWPRODOPTKOMI","PLANMOSCOWPRODOPTARH","PLANOURDOG","PLANOURDOGWITHFOR","PLANOURPROD","PLANOURPRODOPT","PLANOURPRODOPTCLEAN","PLANOURPRODOPTKOMI","PLANOURPRODOPTARH"
,"GU12_LOAD_ABBR",kod_isu 
FROM
(
SELECT
  M.IS_ZAKAZ,
  kls_prod_plan.ORDER_NPR,
  M.PROD_PLAN_ID,
  kls_prod_plan.NAME_NPR,
  M.DOG_ID,
  kls_dog.DOG_NUMBER,
  kls_dog.GROUPDOG_ID,
  kls_predpr.ID AS plat_id,
  kls_predpr.PREDPR_NAME AS plat_name,
  NVL(M.FOR_ID,0) as FOR_ID,
  M.FOR_NAME,
  DECODE(M.LOAD_TYPE_ID,2,0,1) AS LOAD_TYPE_ID,
  M.TYPE_OTGR_NAME,
  NVL(M.other,0) AS other,
  M.NOM_ZD,
  M.INPUT_DATE,
  M.ABBR_NPR,
  M.TONN_DECLARED,
  M.TONN_LOADED,
  M.CIST_DECLARED,
  M.CIST_LOADED,
  M.PRIM,
  M.POLUCH_NAME,
  M.STAN_NAME,
  M.PREDPR_NPO,
  M.ZAKAZ_NUM,
  M.ZAKAZ_DATE,
  M.ZAKAZ_VOL,
  M.ZAKAZ_ID,
  M.ETRAN_NUM,
  M.ETRAN_DATE,
  M.GU12_LOAD_ABBR,
  M.PLANMOSCOWDOG,
  (SELECT SUM(B.PLANMOSCOWDOG) FROM V_MREE_PLANBYDOGDETAIL B WHERE
    M.dog_id=B.dog_id AND M.prod_plan_id=B.prod_plan_id AND B.OTHER=NVL(M.other,0)) AS PlanMoscowDogWithFor,
  (SELECT SUM(B.PLANMOSCOWDOG) FROM V_MREE_PLANBYDOGDETAIL B WHERE
    M.prod_plan_id=b.prod_plan_id) AS PlanMoscowProd,
  NVL((SELECT SUM(v_mree_planpost.PLAN_VES)
 FROM v_mree_planpost,kls_planstru,kls_prod,v_temp_mreestr_params
 WHERE v_mree_planpost.DATE_PLAN=v_temp_mreestr_params.DATE_PLAN AND
   v_mree_planpost.ID_NPR=kls_prod.ID_NPR AND
   kls_prod.PROD_PLAN_ID=M.prod_plan_id AND
   v_mree_planpost.PLANSTRU_ID=kls_planstru.ID and
   (kls_planstru.KOD_SGR=91 and
   kls_planstru.KOD_SPG in (10,15) or
   kls_planstru.KOD_SGR=20) and
   (v_mree_planpost.plan_id=2 or v_mree_planpost.plan_id=3)),0) AS PlanMoscowProdOpt,
  NVL((SELECT SUM(v_mree_planpost.PLAN_VES)
 FROM v_mree_planpost,kls_planstru,kls_prod,v_temp_mreestr_params
 WHERE v_mree_planpost.DATE_PLAN=v_temp_mreestr_params.DATE_PLAN AND
   v_mree_planpost.ID_NPR=kls_prod.ID_NPR AND
   kls_prod.PROD_PLAN_ID=M.prod_plan_id AND
   v_mree_planpost.PLANSTRU_ID=kls_planstru.ID and
   (kls_planstru.KOD_SGR=91 and
   kls_planstru.KOD_SPG in (10) and kls_planstru.kod_rzd<>20 or
   kls_planstru.KOD_SGR=20) and
   (v_mree_planpost.plan_id=2 or v_mree_planpost.plan_id=3)),0) AS PlanMoscowProdOptClean,
  NVL((SELECT SUM(v_mree_planpost.PLAN_VES)
 FROM v_mree_planpost,kls_planstru,kls_prod,v_temp_mreestr_params
 WHERE v_mree_planpost.DATE_PLAN=v_temp_mreestr_params.DATE_PLAN AND
   v_mree_planpost.ID_NPR=kls_prod.ID_NPR AND
   kls_prod.PROD_PLAN_ID=M.prod_plan_id AND
   v_mree_planpost.PLANSTRU_ID=kls_planstru.ID and
   (kls_planstru.KOD_SGR=31 and kls_planstru.KOD_SPG=10 and
   kls_planstru.kod_rzd=65 and kls_planstru.KOD_prz=10) and
   (v_mree_planpost.plan_id in (2,3))),0) AS PlanMoscowProdOptKomi,
  NVL((SELECT SUM(v_mree_planpost.PLAN_VES)
 FROM v_mree_planpost,kls_planstru,kls_prod,v_temp_mreestr_params
 WHERE v_mree_planpost.DATE_PLAN=v_temp_mreestr_params.DATE_PLAN AND
   v_mree_planpost.ID_NPR=kls_prod.ID_NPR AND
   kls_prod.PROD_PLAN_ID=M.prod_plan_id AND
   v_mree_planpost.PLANSTRU_ID=kls_planstru.ID and
   (kls_planstru.KOD_SGR=31 and kls_planstru.KOD_SPG=10 and
   kls_planstru.kod_rzd=65 and kls_planstru.KOD_prz=20) and
   (v_mree_planpost.plan_id in (2,3))),0) AS PlanMoscowProdOptArh,
  M.PLANOURDOG,
  (SELECT SUM(B.PLANOURDOG) FROM V_MREE_PLANBYDOGDETAIL B WHERE
    M.dog_id=b.dog_id AND M.prod_plan_id=b.prod_plan_id AND b.OTHER=NVL(M.other,0)) AS PlanOurDogWithFor,
  (SELECT SUM(B.PLANOURDOG) FROM V_MREE_PLANBYDOGDETAIL B WHERE
    M.prod_plan_id=b.prod_plan_id) AS PlanOurProd,
  NVL((SELECT SUM(v_mree_planpost.PLAN_VES)
 FROM v_mree_planpost,kls_planstru,kls_prod,v_temp_mreestr_params
 WHERE v_mree_planpost.DATE_PLAN=v_temp_mreestr_params.DATE_PLAN AND
   v_mree_planpost.ID_NPR=kls_prod.ID_NPR AND
   kls_prod.PROD_PLAN_ID=M.prod_plan_id AND
   v_mree_planpost.PLANSTRU_ID=kls_planstru.ID and
   (kls_planstru.KOD_SGR=91 and
   kls_planstru.KOD_SPG in (10,15) or
   kls_planstru.KOD_SGR=20) and
   (v_mree_planpost.plan_id=2)),0) AS PlanOurProdOpt,
  NVL((SELECT SUM(v_mree_planpost.PLAN_VES)
 FROM v_mree_planpost,kls_planstru,kls_prod,v_temp_mreestr_params
 WHERE v_mree_planpost.DATE_PLAN=v_temp_mreestr_params.DATE_PLAN AND
   v_mree_planpost.ID_NPR=kls_prod.ID_NPR AND
   kls_prod.PROD_PLAN_ID=M.prod_plan_id AND
   v_mree_planpost.PLANSTRU_ID=kls_planstru.ID and
   (kls_planstru.KOD_SGR=91 and
   kls_planstru.KOD_SPG in (10) and kls_planstru.kod_rzd<>20 or
   kls_planstru.KOD_SGR=20) and
   (v_mree_planpost.plan_id=2)),0) AS PlanOurProdOptClean,
  NVL((SELECT SUM(v_mree_planpost.PLAN_VES)
 FROM v_mree_planpost,kls_planstru,kls_prod,v_temp_mreestr_params
 WHERE v_mree_planpost.DATE_PLAN=v_temp_mreestr_params.DATE_PLAN AND
   v_mree_planpost.ID_NPR=kls_prod.ID_NPR AND
   kls_prod.PROD_PLAN_ID=M.prod_plan_id AND
   v_mree_planpost.PLANSTRU_ID=kls_planstru.ID and
   (kls_planstru.KOD_SGR=31 and kls_planstru.KOD_SPG=10 and
   kls_planstru.kod_rzd=65 and kls_planstru.KOD_prz=10) and
   (v_mree_planpost.plan_id=2)),0) AS PlanOurProdOptKomi,
  NVL((SELECT SUM(v_mree_planpost.PLAN_VES)
 FROM v_mree_planpost,kls_planstru,kls_prod,v_temp_mreestr_params
 WHERE v_mree_planpost.DATE_PLAN=v_temp_mreestr_params.DATE_PLAN AND
   v_mree_planpost.ID_NPR=kls_prod.ID_NPR AND
   kls_prod.PROD_PLAN_ID=M.prod_plan_id AND
   v_mree_planpost.PLANSTRU_ID=kls_planstru.ID and
   (kls_planstru.KOD_SGR=31 and kls_planstru.KOD_SPG=10 and
   kls_planstru.kod_rzd=65 and kls_planstru.KOD_prz=20) and
   (v_mree_planpost.plan_id=2)),0) AS PlanOurProdOptArh,
 m.kod_isu  
FROM
(
SELECT /*+ RULE */
  0 as IS_ZAKAZ,
  A.PROD_PLAN_ID,
  A.DOG_ID,
  A.FOR_ID,
  A.FOR_NAME,
  v_mree_month.LOAD_TYPE_ID,
  v_mree_month.TYPE_OTGR_NAME,
  NVL(v_mree_month.other,NVL(A.other,0)) AS other,
  v_mree_month.NOM_ZD,
  (SELECT MAX(date_razn) FROM raznar WHERE v_mree_month.NOM_ZD=raznar.nom_zd) AS INPUT_DATE,
  v_mree_month.ABBR_NPR,
  v_mree_month.TONN_DECLARED,
  v_mree_month.TONN_LOADED,
  v_mree_month.CIST_DECLARED,
  v_mree_month.CIST_LOADED,
  v_mree_month.PRIM,
  v_mree_month.POLUCH_NAME,
  v_mree_month.STAN_NAME,
  v_mree_month.PREDPR_NPO,
  v_mree_month.ZAKAZ_NUM,
  v_mree_month.ZAKAZ_DATE,
  v_mree_month.ZAKAZ_VOL,
  v_mree_month.ZAKAZ_ID,
  v_mree_month.ETRAN_NUM,
  v_mree_month.ETRAN_DATE,
  for_reestr.GetLoadAbbr(v_mree_month.NOM_ZD) as GU12_LOAD_ABBR,
  v_mree_month.kod_isu,
  A.PLANMOSCOWDOG,
  A.PLANOURDOG
  FROM V_MREE_PLANBYDOGDETAIL A,v_mree_month
  WHERE --(a.PLANMOSCOWDOG<>0 or a.PLANOURDOG<>0) and
 a.dog_id=v_mree_month.dog_id(+) AND
 a.for_id=v_mree_month.for_id(+) AND
 a.other=v_mree_month.other(+) AND
 a.prod_plan_id=v_mree_month.prod_plan_id(+)
UNION ALL
SELECT
  mon.*,
  NVL(A.PLANMOSCOWDOG,0),
  NVL(A.PLANOURDOG,0)
FROM
(
SELECT /*+ RULE */
  1 as IS_ZAKAZ,
  kls_prod_plan.ID as PROD_PLAN_ID,
  DECODE(month_all.IS_AGENT,2,dog_main.DOG_ID,kls_dog.ID) as DOG_ID,
  NVL(kls_planstru.FOR_ID,0) as FOR_ID,
  kls_planstru.FOR_NAME,
  KLS_VID_OTGR.LOAD_TYPE_ID AS LOAD_TYPE_ID,
  kls_load_type.TYPE_OTGR_NAME,
  NVL(DECODE(kls_planstru.KOD_SGR,91,DECODE(kls_planstru.KOD_SPG,10,1,0),0),0) AS other,
  NULL as NOM_ZD,
  NULL AS INPUT_DATE,
  kls_prod.ABBR_NPR,
  0 as TONN_DECLARED,
  0 as TONN_LOADED,
  0 as CIST_DECLARED,
  0 as CIST_LOADED,
  month_all.PRICH as PRIM,
  poluch.PREDPR_NAME AS poluch_name,
  kls_stan.stan_name || ' ' || kls_gdor.SHORT_NAME AS stan_name,
  DECODE(month_all.IS_AGENT,2,DECODE(kls_predpr.ID,2641,'',kls_predpr.PREDPR_NAME),'') AS predpr_npo,
  month_all.INPUT_NUMBER AS zakaz_num,
  month_all.INPUT_DATE AS zakaz_date,
  NVL(zh.load_ves,month_all.REQUEST) as zakaz_vol,
  month_all.ID AS zakaz_id,
  NULL as ETRAN_NUM,
  NULL as ETRAN_DATE,
  kls_vid_otgr.LOAD_ABBR as GU12_LOAD_ABBR,
  zh.kod_isu
FROM MONTH_ALL,(select zakaz_id,kod_isu,sum(load_ves) as load_ves from zakaz_hist where status_zakaz_id=20 group by zakaz_id,kod_isu) zh,
      kls_prod_plan,kls_dog,kls_predpr,kls_predpr poluch,
     (select a.* from kls_dog_main a,V_TEMP_MREESTR_PARAMS b where b.DATE_PLAN BETWEEN a.from_date and a.to_date) dog_main,
     kls_planstru,kls_vid_otgr,kls_load_type,V_TEMP_MREESTR_PARAMS, kls_prod, kls_gdor, kls_stan
WHERE
  month_all.PARUS_RN IS NULL and -- Исключаем заявки из Паруса
  not exists (select NULL FROM month WHERE month.ZAKAZ_ID=month_all.ID) and -- Исключаем заявки по которым идет отгрузка
  month_all.DATE_PLAN=V_TEMP_MREESTR_PARAMS.DATE_PLAN AND -- Ограничиваем по дате
  month_all.IS_REQUESTED=1 and  -- Только "Утвержденные"
  month_all.kls_dog_id=kls_dog.id(+) and
  month_all.kls_predpr_id=kls_predpr.id and
  month_all.KLS_PROD_ID=kls_prod.ID_NPR and
  kls_prod.PROD_PLAN_ID=kls_prod_plan.ID and
  month_all.load_abbr=kls_vid_otgr.load_abbr(+) and
  kls_vid_otgr.LOAD_TYPE_ID=kls_load_type.id(+) and
  month_all.kls_planstruid=kls_planstru.id(+) and
  month_all.STAN_ID=kls_stan.id(+) and
  kls_stan.GDOR_ID=kls_gdor.id(+)  and
  month_all.POLUCH_ID=poluch.id(+) and
  month_all.IS_AGENT=dog_main.is_agent(+) and
  (month_all.DATE_PLAN<TO_DATE('01.01.2005','dd.mm.yyyy') OR month_all.IS_AGENT=1)  and
  month_all.ID=zh.zakaz_id(+)
) mon,V_MREE_PLANBYDOGDETAIL A
WHERE
  a.dog_id(+)=mon.dog_id AND
  a.for_id(+)=mon.for_id AND
  a.other(+)=mon.other AND
  a.prod_plan_id(+)=mon.prod_plan_id
) M,kls_prod_plan,kls_dog,kls_predpr
WHERE
 kls_prod_plan.ID=M.PROD_PLAN_ID AND
 kls_dog.id=M.dog_id AND
 kls_dog.PREDPR_ID=kls_predpr.ID AND
 M.PROD_PLAN_ID>='10100' and
 kls_dog.dog_number<>'1-2000'
ORDER BY
  ORDER_NPR,
  NAME_NPR,
  other,
  plat_name,
  DOG_NUMBER,
  FOR_ID,
  DECODE(predpr_npo,null,' ',predpr_npo),
  load_type_id,
  zakaz_num,
  ZAKAZ_id,
  nom_zd
) 
WHERE
 NVL(ZAKAZ_VOL,0)<>0 or NVL(TONN_DECLARED,0)<>0 or NVL(TONN_LOADED,0)<>0 or NVL(CIST_DECLARED,0)<>0 or NVL(CIST_LOADED,0)<>0 or
 PLANMOSCOWDOG<>0 or PLANMOSCOWDOGWITHFOR<>0 or PLANMOSCOWPROD<>0 or PLANMOSCOWPRODOPT<>0 or 
 PLANMOSCOWPRODOPTCLEAN<>0 or PLANMOSCOWPRODOPTKOMI<>0 or PLANMOSCOWPRODOPTARH<>0 or PLANOURDOG<>0 or PLANOURDOGWITHFOR<>0 or 
 PLANOURPROD<>0 or PLANOURPRODOPT<>0 or PLANOURPRODOPTCLEAN<>0 or PLANOURPRODOPTKOMI<>0 or PLANOURPRODOPTARH<>0;


