--
-- V_GD_AGENT_2008_MONTH  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GD_AGENT_2008_MONTH
(GU12_A_ID, STAN_ID, ZAYV_NUM, ZAYV_DATE, FROM_DATE, 
 TO_DATE, BEGIN_DATE, END_DATE, ORIG_KOL, ORIG_VES, 
 KOL, VES, IS_KORR, STAN_NAME, NOM_ZD, 
 CLIENT_KOL, CLIENT_VES, FACT_VES)
AS 
SELECT /*+ ORDERED */
  -- Заявки из ФИНАНСОВ текущего месяца с привязкой ГУ-12
  month.GU12_A_ID,
  month.STAN_ID,
  A.zayv_num,
  A.zayv_date,
  A.from_date,
  A.to_date,
  A.begin_date,
  A.end_date,
  A.orig_kol,
  A.orig_ves,
  A.kol,
  A.ves,
  A.IS_KORR,
  KLS_STAN.STAN_NAME,
  month.nom_zd,
  COUNT(*) as client_kol,
  SUM(kvit.ves_brutto) as client_ves,
  SUM(DECODE(SIGN(kvit.ves_brutto+kvit.upak_ves-10),1,CEIL(kvit.ves_brutto+kvit.upak_ves),CEIL((kvit.ves_brutto+kvit.upak_ves)*10)/10)) as fact_ves
FROM V_GD_AGENT_2008_GU12_GRP A,month,kvit, V_GD_AGENT_2008_GU12_LIST AA, kls_stan, kls_dog, kls_vid_otgr, v_master_reports C
WHERE month.GU12_A_ID=AA.GU12_A_ID -- Только из списка
  AND month.STAN_ID=AA.STAN_ID -- Только из списка
  AND month.GU12_A_ID=A.GU12_A_ID -- Реквизиты заявок
  AND month.STAN_ID=A.STAN_ID -- Реквизиты заявок
  AND month.nom_zd=kvit.nom_zd
  AND month.dog_id=kls_dog.id
  AND month.stan_id=kls_stan.id
--  AND KLS_DOG.PREDPR_ID=FOR_TEMP.GET_AS_NUM('LC_PLAT','MASTER','GD_AGENT.XLS')
  AND KLS_DOG.DOG_NUMBER LIKE C.DOG_NUMBER
  AND month.PROD_ID_NPR<>'90000' -- Без НЕФТИ
  AND month.load_abbr=kls_vid_otgr.load_abbr
  AND kls_vid_otgr.LOAD_TYPE_ID IN (1,6) -- Только ЖД и контейнеры
  AND kvit.date_oforml<TO_DATE(TO_CHAR(C.END_DATE+1,'dd.mm.yyyy')||' 00:00','dd.mm.yyyy hh24:mi')
  AND month.date_plan=TRUNC(C.BEGIN_DATE,'MONTH')
  AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT_2008.XLS'
GROUP BY
  month.GU12_A_ID,
  month.STAN_ID,
  A.zayv_num,
  A.zayv_date,
  A.from_date,
  A.to_date,
  A.begin_date,
  A.end_date,
  A.orig_kol,
  A.orig_ves,
  A.kol,
  A.ves,
  A.IS_KORR,
  KLS_STAN.STAN_NAME,
  month.nom_zd;


