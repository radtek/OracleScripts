--
-- V_MREE_REESTR_SNP  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_MREE_REESTR_SNP
(REFINERY_ID, REFINERY_NAME, IS_ZAKAZ, ORDER_NPR, PROD_PLAN_ID, 
 NAME_NPR, DOG_ID, DOG_NUMBER, GROUPDOG_ID, PLAT_ID, 
 PLAT_NAME, FOR_ID, FOR_NAME, LOAD_TYPE_ID, TYPE_OTGR_NAME, 
 OTHER, NOM_ZD, ABBR_NPR, TONN_DECLARED, LOAD_VES, 
 TONN_LOADED, CIST_DECLARED, LOAD_KOL, CIST_LOADED, PRIM, 
 POLUCH_NAME, STAN_NAME, PREDPR_NPO, ZAKAZ_NUM, ZAKAZ_DATE, 
 ZAKAZ_ID, ETRAN_NUM, ETRAN_SOGL, PLANALLDOG, PLANALLDOGWITHFOR, 
 PLANALLPROD, PLANALLPRODOPT, PLANALLPRODOPTCLEAN, PLANALLPRODOPTKOMI, PLANALLPRODOPTARH, 
 PLANFIRSTDOG, PLANFIRSTDOGWITHFOR, PLANFIRSTPROD, PLANFIRSTPRODOPT, PLANFIRSTPRODOPTCLEAN, 
 PLANFIRSTPRODOPTKOMI, PLANFIRSTPRODOPTARH)
AS 
SELECT
  M.REFINERY_ID,
  M.REFINERY_NAME,
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
  M.ABBR_NPR,
  M.TONN_DECLARED,
  M.LOAD_VES,
  M.TONN_LOADED,
  M.CIST_DECLARED,
  M.LOAD_KOL,
  M.CIST_LOADED,
  M.PRIM,
  M.POLUCH_NAME,
  M.STAN_NAME,
  M.PREDPR_NPO,
  M.ZAKAZ_NUM,
  M.ZAKAZ_DATE,
  M.ZAKAZ_ID,
  M.ETRAN_NUM,
  M.ETRAN_SOGL,
  M.PLANALLDOG,
  (SELECT SUM(B.PLANALLDOG) FROM V_MREE_SNP_PLANBYDOGDETAIL B WHERE
    M.dog_id=B.dog_id AND M.prod_plan_id=B.prod_plan_id AND B.OTHER=NVL(M.other,0) AND B.REFINERY_ID=m.REFINERY_ID) AS PlanAllDogWithFor,
  (SELECT SUM(B.PLANALLDOG) FROM V_MREE_SNP_PLANBYDOGDETAIL B WHERE
    M.prod_plan_id=b.prod_plan_id AND B.REFINERY_ID=m.REFINERY_ID) AS PlanAllProd,
  NVL((SELECT SUM(a.PLAN_VES)
 FROM v_mree_snp_planpost a,kls_planstru,kls_prod,v_temp_mreestr_snp_params b
 WHERE a.DATE_PLAN=b.DATE_PLAN AND
   a.ID_NPR=kls_prod.ID_NPR AND
   kls_prod.PROD_PLAN_ID=M.prod_plan_id AND
   a.PLANSTRU_ID=kls_planstru.ID and
   (kls_planstru.KOD_SGR=91 and
   kls_planstru.KOD_SPG in (10,15) or
   kls_planstru.KOD_SGR=20)
    AND A.REFINERY_ID=m.REFINERY_ID),0) AS PlanAllProdOpt,
  NVL((SELECT SUM(a.PLAN_VES)
 FROM v_mree_snp_planpost a,kls_planstru,kls_prod,v_temp_mreestr_snp_params b
 WHERE a.DATE_PLAN=b.DATE_PLAN AND
   a.ID_NPR=kls_prod.ID_NPR AND
   kls_prod.PROD_PLAN_ID=M.prod_plan_id AND
   a.PLANSTRU_ID=kls_planstru.ID and
   (kls_planstru.KOD_SGR=91 and
   kls_planstru.KOD_SPG in (10) and kls_planstru.kod_rzd<>20 or
   kls_planstru.KOD_SGR=20) 
   AND A.REFINERY_ID=m.REFINERY_ID),0) AS PlanAllProdOptClean,
  NVL((SELECT SUM(a.PLAN_VES)
 FROM v_mree_snp_planpost a,kls_planstru,kls_prod,v_temp_mreestr_snp_params b
 WHERE a.DATE_PLAN=b.DATE_PLAN AND
   a.ID_NPR=kls_prod.ID_NPR AND
   kls_prod.PROD_PLAN_ID=M.prod_plan_id AND
   a.PLANSTRU_ID=kls_planstru.ID and
   (kls_planstru.KOD_SGR=31 and kls_planstru.KOD_SPG=10 and
   kls_planstru.kod_rzd=65 and kls_planstru.KOD_prz=10) 
   AND A.REFINERY_ID=m.REFINERY_ID),0) AS PlanAllProdOptKomi,
  NVL((SELECT SUM(a.PLAN_VES)
 FROM v_mree_snp_planpost a,kls_planstru,kls_prod,v_temp_mreestr_snp_params b
 WHERE a.DATE_PLAN=b.DATE_PLAN AND
   a.ID_NPR=kls_prod.ID_NPR AND
   kls_prod.PROD_PLAN_ID=M.prod_plan_id AND
   a.PLANSTRU_ID=kls_planstru.ID and
   (kls_planstru.KOD_SGR=31 and kls_planstru.KOD_SPG=10 and
   kls_planstru.kod_rzd=65 and kls_planstru.KOD_prz=20) 
   AND A.REFINERY_ID=m.REFINERY_ID),0) AS PlanAllProdOptArh,
  M.PLANFIRSTDOG,
  (SELECT SUM(B.PLANFIRSTDOG) FROM V_MREE_SNP_PLANBYDOGDETAIL B WHERE
    M.dog_id=b.dog_id AND M.prod_plan_id=b.prod_plan_id AND b.OTHER=NVL(M.other,0) AND B.REFINERY_ID=m.REFINERY_ID) AS PlanFirstDogWithFor,
  (SELECT SUM(B.PLANFIRSTDOG) FROM V_MREE_SNP_PLANBYDOGDETAIL B WHERE
    M.prod_plan_id=b.prod_plan_id AND B.REFINERY_ID=m.REFINERY_ID) AS PlanFirstProd,
  NVL((SELECT SUM(a.PLAN_VES)
 FROM v_mree_snp_planpost a,kls_planstru,kls_prod,v_temp_mreestr_snp_params b
 WHERE a.DATE_PLAN=b.DATE_PLAN AND
   a.ID_NPR=kls_prod.ID_NPR AND
   kls_prod.PROD_PLAN_ID=M.prod_plan_id AND
   a.PLANSTRU_ID=kls_planstru.ID and
   (kls_planstru.KOD_SGR=91 and
   kls_planstru.KOD_SPG in (10,15) or
   kls_planstru.KOD_SGR=20) and
   (a.plan_id=12) AND A.REFINERY_ID=m.REFINERY_ID),0) AS PlanFirstProdOpt,
  NVL((SELECT SUM(a.PLAN_VES)
 FROM v_mree_snp_planpost a,kls_planstru,kls_prod,v_temp_mreestr_snp_params b
 WHERE a.DATE_PLAN=b.DATE_PLAN AND
   a.ID_NPR=kls_prod.ID_NPR AND
   kls_prod.PROD_PLAN_ID=M.prod_plan_id AND
   a.PLANSTRU_ID=kls_planstru.ID and
   (kls_planstru.KOD_SGR=91 and
   kls_planstru.KOD_SPG in (10) and kls_planstru.kod_rzd<>20 or
   kls_planstru.KOD_SGR=20) and
   (a.plan_id=12) AND A.REFINERY_ID=m.REFINERY_ID),0) AS PlanFirstProdOptClean,
  NVL((SELECT SUM(a.PLAN_VES)
 FROM v_mree_snp_planpost a,kls_planstru,kls_prod,v_temp_mreestr_snp_params b
 WHERE a.DATE_PLAN=b.DATE_PLAN AND
   a.ID_NPR=kls_prod.ID_NPR AND
   kls_prod.PROD_PLAN_ID=M.prod_plan_id AND
   a.PLANSTRU_ID=kls_planstru.ID and
   (kls_planstru.KOD_SGR=31 and kls_planstru.KOD_SPG=10 and
   kls_planstru.kod_rzd=65 and kls_planstru.KOD_prz=10) and
   (a.plan_id=12) AND A.REFINERY_ID=m.REFINERY_ID),0) AS PlanFirstProdOptKomi,
  NVL((SELECT SUM(a.PLAN_VES)
 FROM v_mree_snp_planpost a,kls_planstru,kls_prod,v_temp_mreestr_snp_params b
 WHERE a.DATE_PLAN=b.DATE_PLAN AND
   a.ID_NPR=kls_prod.ID_NPR AND
   kls_prod.PROD_PLAN_ID=M.prod_plan_id AND
   a.PLANSTRU_ID=kls_planstru.ID and
   (kls_planstru.KOD_SGR=31 and kls_planstru.KOD_SPG=10 and
   kls_planstru.kod_rzd=65 and kls_planstru.KOD_prz=20) and
   (a.plan_id=12) AND A.REFINERY_ID=m.REFINERY_ID),0) AS PlanFirstProdOptArh
FROM
(
SELECT
  A.REFINERY_NAME,
  A.REFINERY_ID,
  NVL(mon.IS_ZAKAZ,0) as IS_ZAKAZ,
  A.PROD_PLAN_ID,
  A.DOG_ID,
  A.FOR_ID,
  A.FOR_NAME,
  mon.LOAD_TYPE_ID,
  mon.TYPE_OTGR_NAME,
  A.other,
  mon.NOM_ZD,
  mon.ABBR_NPR,
  NVL(mon.TONN_DECLARED,0) as TONN_DECLARED,
  NVL(mon.LOAD_VES,0) as LOAD_VES,
  NVL(mon.TONN_LOADED,0) as TONN_LOADED,
  NVL(mon.CIST_DECLARED,0) as CIST_DECLARED,
  NVL(mon.LOAD_KOL,0) as LOAD_KOL,
  NVL(mon.CIST_LOADED,0) as CIST_LOADED,
  mon.PRIM,
  mon.poluch_name,
  mon.stan_name,
  mon.predpr_npo,
  mon.zakaz_num,
  mon.zakaz_date,
  mon.zakaz_id,
  mon.ETRAN_NUM,
  mon.ETRAN_SOGL,
  NVL(A.PLANALLDOG,0) as PLANALLDOG,
  NVL(A.PLANFIRSTDOG,0) as PLANFIRSTDOG
FROM
(
SELECT /*+ RULE */
  (CASE
     WHEN kls_dog2.is_agent=8 THEN kls_dog2.agent_id 
  ELSE 8
   END) as REFINERY_ID,
  1 as IS_ZAKAZ,
  kls_prod_plan.ID as PROD_PLAN_ID,
  ZAKAZ.LUKDOG_ID as DOG_ID,
  NVL(kls_planstru.FOR_ID,0) as FOR_ID,
  kls_planstru.FOR_NAME,
  KLS_VID_OTGR.LOAD_TYPE_ID AS LOAD_TYPE_ID,
  kls_load_type.TYPE_OTGR_NAME,
  NVL(DECODE(kls_planstru.KOD_SGR,91,DECODE(kls_planstru.KOD_SPG,10,1,0),0),0) AS other,
  ZAKAZ_HIST.NOM_ZD,
  kls_prod.ABBR_NPR,
  ZAKAZ.VES as TONN_DECLARED,
  (CASE
     WHEN kls_dog2.is_agent=8 or kls_dog2.is_agent=4175 THEN ZAKAZ_HIST.LOAD_VES 
  ELSE MONTH.TONN_DECLARED
   END) as LOAD_VES,
  DECODE(ZAKAZ_HIST.ID,NULL,ZAKAZ.FACT_VES,ZAKAZ_HIST.FACT_VES) as TONN_LOADED,
  ZAKAZ.KOL as CIST_DECLARED,
--  DECODE(ZAKAZ_HIST.ID,NULL,ZAKAZ.LOAD_KOL,ZAKAZ_HIST.LOAD_KOL) as LOAD_KOL,
  (CASE
     WHEN kls_dog2.is_agent=8 or kls_dog2.is_agent=4175 THEN ZAKAZ_HIST.LOAD_KOL 
  ELSE MONTH.CIST_DECLARED 
   END) as LOAD_KOL,
  DECODE(ZAKAZ_HIST.ID,NULL,ZAKAZ.FACT_KOL,ZAKAZ_HIST.FACT_KOL) as CIST_LOADED,
  ZAKAZ.PRIM,
  poluch.PREDPR_NAME AS poluch_name,
  kls_stan.stan_name || ' ' || kls_gdor.SHORT_NAME AS stan_name,
  DECODE(kls_predpr.ID,2641,'',kls_predpr.PREDPR_NAME) AS predpr_npo,
  ZAKAZ.INPUT_NUMBER AS zakaz_num,
  ZAKAZ.INPUT_DATE AS zakaz_date,
  ZAKAZ.ID AS zakaz_id,
  DECODE(MONTH.GU12_A_ID,NULL,GU12_A.NOM_Z,mon_GU12_A.NOM_Z) as ETRAN_NUM,
  DECODE(MONTH.GU12_A_ID,NULL,NVL(GU12_A.SOGL,0),NVL(mon_GU12_A.SOGL,0)) as ETRAN_SOGL
FROM ZAKAZ,kls_prod_plan,kls_dog,kls_predpr,kls_predpr poluch,
     (select a.* from kls_dog_main a,V_TEMP_MREESTR_SNP_PARAMS b where a.IS_AGENT=2 AND b.DATE_PLAN BETWEEN a.from_date and a.to_date) dog_main,
  kls_dog kls_dog2,
     kls_planstru,kls_vid_otgr,kls_load_type,V_TEMP_MREESTR_SNP_PARAMS, kls_prod, kls_gdor, kls_stan,
  gu12_a, gu12_a mon_gu12_a, (select * from zakaz_hist where status_zakaz_id=20) zakaz_hist, MONTH
WHERE
  ZAKAZ.DATE_PLAN=V_TEMP_MREESTR_SNP_PARAMS.DATE_PLAN AND -- Ограничиваем по дате
  ZAKAZ.IS_ACCEPT=1 and  -- Только "Утвержденные"
  ZAKAZ.dog_id=kls_dog.id(+) and
  ZAKAZ.PLAT_ID=kls_predpr.id and
  ZAKAZ.PROD_ID_NPR=kls_prod.ID_NPR and
  kls_prod.PROD_PLAN_ID=kls_prod_plan.ID and
  ZAKAZ.load_abbr=kls_vid_otgr.load_abbr(+) and
  kls_vid_otgr.LOAD_TYPE_ID=kls_load_type.id(+) and
  ZAKAZ.planstru_id=kls_planstru.id(+) and
  ZAKAZ.STAN_ID=kls_stan.id(+) and
  kls_stan.GDOR_ID=kls_gdor.id(+)  and
  ZAKAZ.POLUCH_ID=poluch.id(+) and
  ZAKAZ.IS_AGENT=dog_main.is_agent(+) and
  ZAKAZ.lukdog_id=kls_dog2.id(+) and
  zakaz.IS_AGENT=2 and
  zakaz.id=zakaz_hist.zakaz_id(+) and
  zakaz_hist.GU12_A_ID=gu12_a.id(+) and
  zakaz_hist.NOM_ZD=MONTH.NOM_ZD(+) and
  month.gu12_a_id=mon_gu12_a.id(+)

) mon,V_MREE_SNP_PLANBYDOGDETAIL A
WHERE
  a.refinery_id=mon.refinery_id(+) AND
  a.dog_id=mon.dog_id(+) AND
  a.for_id=mon.for_id(+) AND
  a.other=mon.other(+) AND
  a.prod_plan_id=mon.prod_plan_id(+)
) M,kls_prod_plan,kls_dog,kls_predpr
WHERE
 kls_prod_plan.ID=M.PROD_PLAN_ID AND
 kls_dog.id=M.dog_id AND
 kls_dog.PREDPR_ID=kls_predpr.ID AND
 M.PROD_PLAN_ID>='10100' and
 kls_dog.dog_number<>'1-2000'
ORDER BY
  M.REFINERY_ID,
  M.REFINERY_NAME,
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
  nom_zd;


