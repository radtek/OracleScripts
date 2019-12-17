--
-- V_GD_AGENT_2008_MONTH_ALL  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GD_AGENT_2008_MONTH_ALL
(RAZN_NUM, RAZN_DATE, INPUT_DATE, STAN_OLD_ID, STAN_OLD_NAME, 
 STAN_ID, STAN_NAME, POLUCH_ID, POLUCH_NAME, PROD_ID, 
 PROD_NAME, KOL, VES, SPEED_KOL, SPEED_VES, 
 PRIM, STATUS_ZAKAZ_ID, MAIN_RAZN_NUM, MAIN_RAZN_DATE, MAIN_INPUT_DATE)
AS 
SELECT
  RAZN_NUM,
  RAZN_DATE,
  INPUT_DATE,
  STAN_OLD_ID,
  STAN_OLD_NAME,
  STAN_ID,
  STAN_NAME,
  POLUCH_ID,
  POLUCH_NAME,
  PROD_ID,
  PROD_NAME,
  KOL,
  VES,
  SPEED_KOL,
  SPEED_VES,
  PRIM,
  STATUS_ZAKAZ_ID,
  MAIN_RAZN_NUM,
  MAIN_RAZN_DATE,
  MAIN_INPUT_DATE
FROM
(
SELECT /*+ RULE */
  /* Предоставлено разнарядок */
  -- Основные заявки
  mon.client_number as RAZN_NUM,
  mon.client_date as RAZN_DATE,
  mon.input_date,
  old_mon.STAN_ID as STAN_OLD_ID,
  old_STAN.STAN_NAME as STAN_OLD_NAME,
  mon.STAN_ID,
  KLS_STAN.STAN_NAME,
  mon.POLUCH_ID,
  poluch.SF_NAME as POLUCH_NAME,
  KLS_PROD.ID_NPR as PROD_ID,
  kls_prod.NAME_NPR as PROD_NAME,
  SUM(NVL(mon.KOL,0)) as KOL,
  SUM(NVL(mon.REQUEST,0)) as VES,
  SUM(NVL((
    SELECT COUNT(*) FROM kvit,month,v_master_reports C,kls_vid_otgr
	 WHERE kvit.nom_zd=month.nom_zd AND month.zakaz_id=mon.id
--       AND kvit.date_oforml>=TO_DATE(TO_CHAR(C.BEGIN_DATE-1,'dd.mm.yyyy')||' 17:00','dd.mm.yyyy hh24:mi')
--       AND kvit.date_oforml<=TO_DATE(TO_CHAR(C.END_DATE,'dd.mm.yyyy')||' 17:00','dd.mm.yyyy hh24:mi')
       AND kvit.date_otgr>=C.BEGIN_DATE
       AND kvit.date_otgr<=C.END_DATE
       AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT_2008.XLS'
       AND month.PROD_ID_NPR<>'90000' -- Без НЕФТИ
       AND month.load_abbr=kls_vid_otgr.load_abbr
       AND kls_vid_otgr.LOAD_TYPE_ID IN (1,6) -- Только ЖД и контейнеры
   ),0)) as SPEED_KOL,
  SUM(NVL((
    SELECT SUM(kvit.ves_brutto) FROM kvit,month,v_master_reports C,kls_vid_otgr
	 WHERE kvit.nom_zd=month.nom_zd AND month.zakaz_id=mon.id
--       AND kvit.date_oforml>=TO_DATE(TO_CHAR(C.BEGIN_DATE-1,'dd.mm.yyyy')||' 17:00','dd.mm.yyyy hh24:mi')
--       AND kvit.date_oforml<=TO_DATE(TO_CHAR(C.END_DATE,'dd.mm.yyyy')||' 17:00','dd.mm.yyyy hh24:mi')
       AND kvit.date_otgr>=C.BEGIN_DATE
       AND kvit.date_otgr<=C.END_DATE
       AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT_2008.XLS'
       AND month.PROD_ID_NPR<>'90000' -- Без НЕФТИ
       AND month.load_abbr=kls_vid_otgr.load_abbr
       AND kls_vid_otgr.LOAD_TYPE_ID IN (1,6) -- Только ЖД и контейнеры
   ),0)) as SPEED_VES,
  ''  as PRIM,
  10 as STATUS_ZAKAZ_ID,
  mon.client_number as MAIN_RAZN_NUM,
  mon.client_date as MAIN_RAZN_DATE,
  mon.input_date as MAIN_INPUT_DATE
FROM month_all mon,kls_dog,v_master_reports C, kls_stan,kls_prod,month_all old_mon,kls_stan old_stan, kls_predpr poluch
WHERE mon.KLS_dog_id=kls_dog.id
  AND mon.ZAKAZ_OLD_ID=old_mon.ID(+)
  AND old_mon.stan_id=old_stan.ID (+)
--  AND KLS_DOG.PREDPR_ID=FOR_TEMP.GET_AS_NUM('LC_PLAT','MASTER','GD_AGENT_2008.XLS')
  AND KLS_DOG.DOG_NUMBER LIKE C.DOG_NUMBER
  AND mon.date_plan BETWEEN C.BEGIN_DATE AND C.END_DATE
  AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT_2008.XLS'
  AND mon.KLS_PROD_ID<>'90000' -- Без НЕФТИ
  AND mon.PARUS_RN is null -- Без СНП
  AND mon.IS_AGENT=1 -- Только агентские
  AND mon.STAN_ID=KLS_STAN.ID
  and mon.kls_prod_id=kls_prod.id_npr
  and mon.POLUCH_ID=poluch.ID(+)
  and mon.STAN_ID<>2595 -- без АВТОНАЛИВА
GROUP BY
  mon.client_number,
  mon.client_date,
  mon.input_date,
  old_mon.STAN_ID,
  old_STAN.STAN_NAME,
  mon.STAN_ID,
  KLS_STAN.STAN_NAME,
  mon.POLUCH_ID,
  poluch.SF_NAME,
  KLS_PROD.ID_NPR,
  kls_prod.NAME_NPR,
  DECODE(mon.ZAKAZ_OLD_ID,NULL,'','В счет заказа № '||old_mon.CLIENT_NUMBER||' ст.'||old_stan.STAN_NAME || ' ')
--
UNION ALL
--
SELECT /*+ RULE */
  -- Переадресовки в пути
  mon.client_number as RAZN_NUM,
  mon.client_date as RAZN_DATE,
  mon.input_date,
  mon.STAN_OLD_ID,
  old_stan.STAN_NAME as STAN_OLD_NAME,
  mon.STAN_ID,
  KLS_STAN.STAN_NAME,
  mon.POLUCH_ID,
  poluch.SF_NAME as POLUCH_NAME,
  KLS_PROD.ID_NPR as PROD_ID,
  kls_prod.NAME_NPR as PROD_NAME,
  SUM(ABS(NVL(mon.KOL,0))) as KOL,
  SUM(ABS(NVL(mon.REQUEST,0))) as VES,
  SUM(ABS(NVL(mon.SPEED_KOL,0))) as SPEED_KOL,
  SUM(ABS(NVL(mon.SPEED_VES,0))) as SPEED_VES,
  ''  as PRIM,
  mon.STATUS_ZAKAZ_ID,
  month_all.client_number as MAIN_RAZN_NUM,
  month_all.client_date as MAIN_RAZN_DATE,
  month_all.input_date as MAIN_INPUT_DATE
FROM month_all_row mon,month_all,kls_dog,v_master_reports C, kls_stan,kls_prod, kls_stan old_stan, kls_predpr poluch
WHERE mon.KLS_dog_id=kls_dog.id
  AND mon.month_all_id=month_all.id
--  AND KLS_DOG.PREDPR_ID=FOR_TEMP.GET_AS_NUM('LC_PLAT','MASTER','GD_AGENT_2008.XLS')
  AND KLS_DOG.DOG_NUMBER LIKE C.DOG_NUMBER
  AND month_all.date_plan BETWEEN C.BEGIN_DATE AND C.END_DATE
  AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT_2008.XLS'
  AND mon.KLS_PROD_ID<>'90000' -- Без НЕФТИ
  AND month_all.PARUS_RN is null -- Без СНП
  AND month_all.IS_AGENT=1 -- Только агентские
  AND mon.STAN_ID=KLS_STAN.ID
  AND mon.STAN_OLD_ID=old_stan.ID
  and mon.kls_prod_id=kls_prod.id_npr
  and month_all.POLUCH_ID=poluch.ID(+)
  and mon.status_zakaz_id in (41,42)
  and mon.STAN_ID<>2595 -- без АВТОНАЛИВА
GROUP BY
  mon.client_number,
  mon.client_date,
  mon.input_date,
  mon.STAN_OLD_ID,
  old_stan.STAN_NAME,
  mon.STAN_ID,
  KLS_STAN.STAN_NAME,
  mon.POLUCH_ID,
  poluch.SF_NAME,
  KLS_PROD.ID_NPR,
  kls_prod.NAME_NPR,
  mon.STATUS_ZAKAZ_ID,
  month_all.client_number,
  month_all.client_date,
  month_all.input_date
--
UNION ALL
--
SELECT /*+ RULE */
  -- Отказы
  mon.client_number as RAZN_NUM,
  mon.client_date as RAZN_DATE,
  mon.input_date,
  NULL as STAN_OLD_ID,
  NULL as STAN_OLD_NAME,
  mon.STAN_ID,
  KLS_STAN.STAN_NAME,
  mon.POLUCH_ID,
  poluch.SF_NAME as POLUCH_NAME,
  KLS_PROD.ID_NPR as PROD_ID,
  kls_prod.NAME_NPR as PROD_NAME,
  SUM(ABS(NVL(mon.KOL,0))) as KOL,
  SUM(ABS(NVL(mon.REQUEST,0))) as VES,
  SUM(ABS(NVL(mon.SPEED_KOL,0))) as SPEED_KOL,
  SUM(ABS(NVL(mon.SPEED_VES,0))) as SPEED_VES,
  ''  as PRIM,
  mon.STATUS_ZAKAZ_ID,
  month_all.client_number as MAIN_RAZN_NUM,
  month_all.client_date as MAIN_RAZN_DATE,
  month_all.input_date as MAIN_INPUT_DATE
FROM month_all_row mon,month_all,kls_dog,v_master_reports C, kls_stan,kls_prod,kls_predpr poluch
WHERE month_all.KLS_dog_id=kls_dog.id
  AND mon.month_all_id=month_all.id
--  AND KLS_DOG.PREDPR_ID=FOR_TEMP.GET_AS_NUM('LC_PLAT','MASTER','GD_AGENT_2008.XLS')
  AND KLS_DOG.DOG_NUMBER LIKE C.DOG_NUMBER
  AND month_all.date_plan BETWEEN C.BEGIN_DATE AND C.END_DATE
  AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT_2008.XLS'
  AND month_all.KLS_PROD_ID<>'90000' -- Без НЕФТИ
  AND month_all.PARUS_RN is null -- Без СНП
  AND month_all.IS_AGENT=1 -- Только агентские
  AND month_all.STAN_ID=KLS_STAN.ID
  and month_all.kls_prod_id=kls_prod.id_npr
  and mon.status_zakaz_id in (50)
  and month_all.POLUCH_ID=poluch.ID(+)
  and mon.STAN_ID<>2595 -- без АВТОНАЛИВА
GROUP BY
  mon.client_number,
  mon.client_date,
  mon.input_date,
  mon.STAN_ID,
  KLS_STAN.STAN_NAME,
  mon.POLUCH_ID,
  poluch.SF_NAME,
  KLS_PROD.ID_NPR,
  kls_prod.NAME_NPR,
  mon.STATUS_ZAKAZ_ID,
  month_all.client_number,
  month_all.client_date,
  month_all.input_date
)
ORDER BY
  razn_date,
  razn_num,
  prod_id,
  STAN_NAME;


