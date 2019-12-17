-- Продукт и план (ПОСТАВКА)
SELECT 
  SUM(NVL(plan_NB,0)) as plan_NB,
  SUM(NVL(plan_TRAN,0)) as plan_TRAN,
  SUM(NVL(plan_VNCORPTR,0)) as plan_VNCORPTR,
  SUM(NVL(plan_OTHER,0)) as plan_OTHER
FROM
(
SELECT 
  /* План поставок */
  plan_post.Prod_id_npr,
  DECODE(NVL(TIP_REAL_ID,0),1,Plan_post.plan_ves,0) as PLAN_NB,
  DECODE(NVL(TIP_REAL_ID,0),2,Plan_post.plan_ves,0) as PLAN_TRAN,
  DECODE(NVL(TIP_REAL_ID,0),0,DECODE(spf_group_name,'ВНУТРИКОРПОРАТИВНЫЙ ТРАНЗИТ',Plan_post.plan_ves,0),0) as PLAN_VNCORPTR,
  DECODE(NVL(TIP_REAL_ID,0),0,DECODE(spf_group_name,'ПРОЧЕЕ',Plan_post.plan_ves,0),0) as PLAN_OTHER
FROM Plan_periods,Plan_post,
(
 SELECT * FROM v_Kls_planstru
  WHERE v_Kls_planstru.IS_SNP=1 /* План по ЛУКОЙЛ-СНП */
  AND v_Kls_planstru.IS_TO_HRAN=0 /* Без отгрузки на хранение */
  AND DECODE (v_Kls_planstru.Region_id, 21, 40, 31) = :Filial_id
  AND v_Kls_planstru.Parent_id<>218
) PS  
WHERE Plan_post.Plan_per_id = Plan_periods.ID
  AND Plan_post.Plan_id = 1  /* Рабочий план */
  AND Plan_periods.Date_plan = :Date_plan
  AND Plan_post.Planstru_id=PS.ID  
) PP,
(
SELECT Link_id_Npr
   FROM v_prod_linked_grp_4
  WHERE fact_id_npr = :prod_id_npr
) Prods
WHERE Prods.Link_Id_npr =  PP.Prod_id_npr(+)


v_zakaz_temp

begin
 for_zakaz.EmptyTemp(3);
 for_zakaz.FillTemp(3,TRUNC(SYSDATE,'MONTH'),LAST_DAY(SYSDATE));
end;

zakaz_temp 



-- Заказы (ПОСТАВКА)
SELECT /*+ RULE */
  mon.ROWID,
  mon.*,
  TO_CHAR(mon.date_plan, 'Month YYYY') AS d_plan, 
  PLAT.PREDPR_NAME as PLAT_NAME,
  PLAT.INN as PLAT_INN,
  KLS_DOG.DOG_NUMBER,
  KLS_PROD.NAME_NPR as NAME_NPR,
  KLS_PROD.NORMOTGR,
  KLS_STAN.STAN_KOD,
  KLS_STAN.STAN_NAME,
  KLS_USL_OPL.NAME as USL_OPL_NAME,
  ORG_STRUCTURE.FULL_NAME as FILIAL_NAME,
  poluch.PREDPR_NAME as POLUCH_NAME,
  poluch.OKPO as POLUCH_OKPO,
  potreb.PREDPR_NAME as POTREB_NAME_1,
  KLS_PAYFORM.PAYFORM_NAME,  
  KLS_VID_OTGR.LOAD_NAME,
  KLS_VETKA.VETKA_NAME,
  V_PLAN_STRU.NAME as PLANSTRU_NAME,
  NVL((SELECT DISTINCT 1 FROM zakaz_hist a where a.zakaz_id=mon.id),0) as EXIST_HIST
FROM ZAKAZ mon,KLS_DOG,KLS_PROD,KLS_STAN,KLS_USL_OPL,ORG_STRUCTURE,KLS_PREDPR poluch,KLS_PREDPR potreb, 
     KLS_PREDPR plat,KLS_PAYFORM,KLS_VID_OTGR,KLS_VETKA,V_PLAN_STRU
WHERE mon.PLAT_ID=plat.ID
  AND mon.FILIAL_ID=ORG_STRUCTURE.ID 
  AND mon.PROD_ID_NPR=KLS_PROD.ID_NPR
  AND mon.DOG_ID=KLS_DOG.ID(+)
  AND mon.STAN_ID=KLS_STAN.ID (+)
  AND mon.USL_OPL_ID=KLS_USL_OPL.ID (+)
  AND mon.POLUCH_ID=poluch.ID(+)
  AND mon.POTREB_ID=potreb.ID(+)
  AND mon.PAYFORM_ID=KLS_PAYFORM.ID(+)
  AND mon.LOAD_ABBR=KLS_VID_OTGR.LOAD_ABBR(+)
  AND mon.VETKA_ID=KLS_VETKA.ID(+)
  AND mon.PLANSTRU_ID=V_PLAN_STRU.ID(+)
  AND mon.is_agent=2 AND mon.DATE_PLAN>=TO_DATE('01.09.2004','dd.mm.yyyy') AND  mon.DATE_PLAN<=TO_DATE('30.09.2004','dd.mm.yyyy') 
  AND 1=1 -- Фильтр 
ORDER BY mon.ID desc


-- Заявлено (ПОСТАВКА) 
SELECT
  Prods.GROUP_NAME_NPR as PROD_NAME,
  SUM(VES) as ZAYV_ALL_PROD,
  SUM(DECODE(IS_ACCEPT,1,VES,0)) as zayv_accept_prod,
  SUM(FACT_VES) as ZAYV_FACT_PROD,
  SUM(DECODE(NVL(DOG_ID,0),:DOG_ID,VES,0)) as zayv_all_dog,
  SUM(DECODE(NVL(DOG_ID,0),:DOG_ID,DECODE(IS_ACCEPT,1,VES,0),0)) as zayv_accept_dog,
  SUM(DECODE(NVL(DOG_ID,0),:DOG_ID,FACT_VES,0)) as zayv_fact_dog,
  SUM(DECODE(NVL(PLAT_ID,0),:PLAT_ID,VES,0)) as zayv_all_plat,
  SUM(DECODE(NVL(PLAT_ID,0),:PLAT_ID,DECODE(IS_ACCEPT,1,VES,0),0)) as zayv_accept_plat,
  SUM(DECODE(NVL(PLAT_ID,0),:PLAT_ID,FACT_VES,0)) as zayv_fact_plat
FROM ZAKAZ mon,
(
SELECT Link_id_Npr,GROUP_NAME_NPR
   FROM v_prod_linked_grp_4
  WHERE fact_id_npr = :prod_id_npr
) Prods
WHERE mon.is_agent=2 AND mon.date_plan BETWEEN :FromDate AND :ToDate
  AND mon.filial_id=:FILIAL_ID
  AND mon.PROD_ID_NPR=Prods.Link_Id_npr
GROUP BY Prods.GROUP_NAME_NPR 
  

-- Задолженность (ПОСТАВКА)
SELECT NVL(SUM(-NFACT_INGOOD_SUM+NFACT_OUTGOOD_SUM+NPLAN_OUTSERV_SUM+NFACT_OUTPAY_SUM-NFACT_INPAY_SUM),0) as SALDO
  FROM parus.V_contracts@oracle.world f, KLS_DOG_PARUS
 WHERE KLS_DOG_PARUS.DOG_ID=:dog_id
   AND TRIM (f.sdoc_pref) || TRIM (f.sdoc_numb)=KLS_DOG_PARUS.BASE_NUMB

   
   
/* -------------------------------------------------------------------------- */

   
-- Продукт и план (АГЕНТ)
SELECT 
  Prods.GROUP_NAME_NPR,
  SUM(NVL(plan_PROD,0)) as plan_PROD,
  SUM(NVL(plan_DOG,0)) as plan_DOG
FROM
(
SELECT /* */ 
  -- План поставок
  plan_post.Prod_id_npr,
  Plan_post.plan_ves as PLAN_PROD,
  DECODE(NVL(plan_post.dog_id,0),:DOG_ID,Plan_post.plan_ves,0) as PLAN_DOG
FROM Plan_periods,Plan_post,
(
 SELECT * FROM v_Kls_planstru
  WHERE v_Kls_planstru.IS_SNP=0 -- 
  AND v_Kls_planstru.IS_TO_HRAN=0 -- Без отгрузки на хранение
) PS  
WHERE Plan_post.Plan_per_id = Plan_periods.ID
  AND Plan_post.Plan_id in (2,3)  -- Московский план + ОБР
  AND Plan_periods.Date_plan = :Date_plan
  AND Plan_post.Planstru_id=PS.ID  
) PP,
(
SELECT Link_id_Npr,GROUP_NAME_NPR
   FROM v_prod_linked_grp_4
  WHERE fact_id_npr = :prod_id_npr
) Prods
WHERE Prods.Link_Id_npr =  PP.Prod_id_npr(+)
GROUP BY Prods.GROUP_NAME_NPR 


-- Заказы (АГЕНТ)
SELECT /*+ RULE */
  mon.ROWID,
  mon.*,
  TO_CHAR(mon.date_plan, 'Month YYYY') AS d_plan, 
  PLAT.PREDPR_NAME as PLAT_NAME,
  PLAT.INN as PLAT_INN,
  KLS_DOG.DOG_NUMBER,
  KLS_PROD.NAME_NPR as NAME_NPR,
  KLS_PROD.NORMOTGR,
  KLS_STAN.STAN_KOD,
  KLS_STAN.STAN_NAME,
  KLS_USL_OPL.NAME as USL_OPL_NAME,
  ORG_STRUCTURE.FULL_NAME as FILIAL_NAME,
  poluch.PREDPR_NAME as POLUCH_NAME,
  poluch.OKPO as POLUCH_OKPO,
  potreb.PREDPR_NAME as POTREB_NAME_1,
  KLS_PAYFORM.PAYFORM_NAME,  
  KLS_VID_OTGR.LOAD_NAME,
  KLS_VETKA.VETKA_NAME,
  V_PLAN_STRU.NAME as PLANSTRU_NAME,
  NVL((SELECT DISTINCT 1 FROM zakaz_hist a where a.zakaz_id=mon.id),0) as EXIST_HIST
FROM ZAKAZ mon,KLS_DOG,KLS_PROD,KLS_STAN,KLS_USL_OPL,ORG_STRUCTURE,KLS_PREDPR poluch,KLS_PREDPR potreb, 
     KLS_PREDPR plat,KLS_PAYFORM,KLS_VID_OTGR,KLS_VETKA,V_PLAN_STRU
WHERE mon.PLAT_ID=plat.ID
  AND mon.FILIAL_ID=ORG_STRUCTURE.ID 
  AND mon.PROD_ID_NPR=KLS_PROD.ID_NPR
  AND mon.DOG_ID=KLS_DOG.ID(+)
  AND mon.STAN_ID=KLS_STAN.ID (+)
  AND mon.USL_OPL_ID=KLS_USL_OPL.ID (+)
  AND mon.POLUCH_ID=poluch.ID(+)
  AND mon.POTREB_ID=potreb.ID(+)
  AND mon.PAYFORM_ID=KLS_PAYFORM.ID(+)
  AND mon.LOAD_ABBR=KLS_VID_OTGR.LOAD_ABBR(+)
  AND mon.VETKA_ID=KLS_VETKA.ID(+)
  AND mon.PLANSTRU_ID=V_PLAN_STRU.ID(+)
  AND mon.is_agent=1 AND mon.DATE_PLAN>=TO_DATE('01.09.2004','dd.mm.yyyy') AND  mon.DATE_PLAN<=TO_DATE('30.09.2004','dd.mm.yyyy') 
  AND 1=1 -- Фильтр 
ORDER BY mon.ID desc


-- Заявлено (АГЕНТ) 
SELECT 
  SUM(ZAYV_ALL_PROD) as ZAYV_ALL_PROD,
  SUM(zayv_accept_prod) as zayv_accept_prod,
  SUM(ZAYV_FACT_PROD) as ZAYV_FACT_PROD,
  SUM(zayv_all_dog) as zayv_all_dog,
  SUM(zayv_accept_dog) as zayv_accept_dog,
  SUM(zayv_FACT_dog) as zayv_FACT_dog,
  SUM(zayv_all_plat) as zayv_all_plat,
  SUM(zayv_accept_plat) as zayv_accept_plat,
  SUM(zayv_FACT_plat) as zayv_FACT_plat
FROM
(
SELECT
  SUM(VES) as ZAYV_ALL_PROD,
  SUM(DECODE(IS_ACCEPT,1,VES,0)) as zayv_accept_prod,
  SUM(FACT_VES) as ZAYV_FACT_PROD,
  SUM(DECODE(NVL(DOG_ID,0),:DOG_ID,VES,0)) as zayv_all_dog,
  SUM(DECODE(NVL(DOG_ID,0),:DOG_ID,DECODE(IS_ACCEPT,1,VES,0),0)) as zayv_accept_dog,
  SUM(DECODE(NVL(DOG_ID,0),:DOG_ID,FACT_VES,0)) as zayv_fact_dog,
  SUM(DECODE(NVL(PLAT_ID,0),:PLAT_ID,VES,0)) as zayv_all_plat,
  SUM(DECODE(NVL(PLAT_ID,0),:PLAT_ID,DECODE(IS_ACCEPT,1,VES,0),0)) as zayv_accept_plat,
  SUM(DECODE(NVL(PLAT_ID,0),:PLAT_ID,FACT_VES,0)) as zayv_fact_plat
FROM ZAKAZ mon,
(
SELECT Link_id_Npr
   FROM v_prod_linked_grp_4
  WHERE fact_id_npr = :prod_id_npr
) Prods
WHERE mon.is_agent=1 AND mon.date_plan BETWEEN :FromDate AND :ToDate
  AND mon.filial_id=:FILIAL_ID
  AND mon.PROD_ID_NPR=Prods.Link_Id_npr
)  


/* -------------------------------------------------------------------------- */



-- Продукт и план (PARUS)
SELECT /*+ RULE */
  SUM(NVL(plan_NB,0)) as plan_NB,
  SUM(NVL(plan_AZS,0)) as plan_AZS,
  SUM(NVL(plan_TRAN,0)) as plan_TRAN,
  SUM(NVL(plan_VNCORPTR,0)) as plan_VNCORPTR
FROM
(
SELECT /* */ 
  -- План реализации
  plan_realiz.Prod_id_npr,
  DECODE(NVL(TIP_REAL_ID,0),1,DECODE(ORG_KIND_ID,1,Plan_realiz.VES,0),0) as PLAN_NB,
  DECODE(NVL(TIP_REAL_ID,0),1,DECODE(ORG_KIND_ID,5,Plan_realiz.VES,0),0) as PLAN_AZS,
  DECODE(NVL(TIP_REAL_ID,0),2,Plan_realiz.ves,0) as PLAN_TRAN,
  DECODE(NVL(TIP_REAL_ID,0),3,Plan_realiz.ves,0) as PLAN_VNCORPTR
FROM Plan_realiz
WHERE Plan_realiz.Date_plan = :Date_plan
) PR,
(
SELECT Link_id_Npr
   FROM v_prod_linked_grp_4,kls_prod_nomenklator
  WHERE kls_prod_nomenklator.is_actual=1
    AND fact_id_npr = kls_prod_nomenklator.prod  
	AND kls_prod_nomenklator.MODIF=:PARUS_NOMEN_TAG
) Prods
WHERE Prods.Link_Id_npr =  PR.Prod_id_npr


-- Заказы (PARUS)
SELECT /*+ RULE */
  mon.ROWID,
  mon.*,
  TO_CHAR(mon.date_plan, 'Month YYYY') AS d_plan, 
  KLS_USL_OPL.NAME as USL_OPL_NAME,
  ORG_STRUCTURE.FULL_NAME as FILIAL_NAME
FROM ZAKAZ_PARUS mon,KLS_USL_OPL,ORG_STRUCTURE
WHERE mon.FILIAL_ID=ORG_STRUCTURE.ID 
  AND mon.USL_OPL_ID=KLS_USL_OPL.ID (+)
  AND mon.DATE_PLAN>=TO_DATE('01.09.2004','dd.mm.yyyy') AND mon.DATE_PLAN<=TO_DATE('30.09.2004','dd.mm.yyyy') 
  AND 1=1 -- Фильтр 
ORDER BY mon.PARUS_RN desc


-- Заявлено (ПАРУС) 
SELECT
  mon.PARUS_NOMEN_NAME as PROD_NAME,
  SUM(VES) as ZAYV_ALL_PROD,
  SUM(DECODE(IS_ACCEPT+IS_WORK,2,VES,0)) as zayv_accept_prod,
  SUM(FACT_VES) as ZAYV_FACT_PROD,
  SUM(DECODE(PARUS_DOGOVOR,:PARUS_DOGOVOR,VES,0)) as zayv_all_dog,
  SUM(DECODE(PARUS_DOGOVOR,:PARUS_DOGOVOR,DECODE(IS_ACCEPT+IS_WORK,2,VES,0),0)) as zayv_accept_dog,
  SUM(DECODE(PARUS_DOGOVOR,:PARUS_DOGOVOR,FACT_VES,0)) as zayv_fact_dog,
  SUM(DECODE(PARUS_AGENT_TAG,:PARUS_AGENT_TAG,VES,0)) as zayv_all_plat,
  SUM(DECODE(PARUS_AGENT_TAG,:PARUS_AGENT_TAG,DECODE(IS_ACCEPT+IS_WORK,2,VES,0),0)) as zayv_accept_plat,
  SUM(DECODE(PARUS_AGENT_TAG,:PARUS_AGENT_TAG,FACT_VES,0)) as zayv_fact_plat
FROM ZAKAZ_PARUS mon
WHERE mon.date_plan BETWEEN :FromDate AND :ToDate
  AND mon.filial_id=:FILIAL_ID
  AND mon.PARUS_NOMEN_TAG=:PARUS_NOMEN_TAG
GROUP BY
  mon.PARUS_NOMEN_NAME
   
-- Задолженность (PARUS)
SELECT NVL(SUM(-NFACT_INGOOD_SUM+NFACT_OUTGOOD_SUM+NPLAN_OUTSERV_SUM+NFACT_OUTPAY_SUM-NFACT_INPAY_SUM),0) as SALDO
  FROM parus.V_contracts@oracle.world f
 WHERE TRIM (f.sdoc_pref) || TRIM (f.sdoc_numb)=:PARUS_DOGOVOR
   
   
   