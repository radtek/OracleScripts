--
-- V_GD_AGENT_2006_MONTH_ALL  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GD_AGENT_2006_MONTH_ALL
(FROM_DATE, BEGIN_DATE, END_DATE, RAZN_NUM, RAZN_DATE, 
 INPUT_DATE, STAN_OLD_ID, STAN_OLD_NAME, STAN_ID, STAN_NAME, 
 POLUCH_ID, POLUCH_NAME, PROD_ID, PROD_NAME, KOL, 
 VES, SPEED_KOL, SPEED_VES, PRIM, STATUS_ZAKAZ_ID, 
 MAIN_RAZN_NUM, MAIN_RAZN_DATE, MAIN_INPUT_DATE)
AS 
SELECT 
  FROM_DATE, 
  BEGIN_DATE, 
  END_DATE, 
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
  z.FROM_DATE, 
  c.BEGIN_DATE, 
  c.END_DATE, 
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
  SUM(z.KOL) as KOL, 
  SUM(z.REQUEST) as VES, 
  SUM(z.FACT_KOL) as SPEED_KOL, 
  SUM(z.FACT_VES) as SPEED_VES, 
  ''  as PRIM, 
  10 as STATUS_ZAKAZ_ID, 
  mon.client_number as MAIN_RAZN_NUM, 
  mon.client_date as MAIN_RAZN_DATE, 
  mon.input_date as MAIN_INPUT_DATE 
FROM month_all mon,v_gd_agent_2006_zakaz z, kls_dog,v_master_reports C, kls_stan,kls_prod,month_all old_mon,kls_stan old_stan, kls_predpr poluch 
WHERE mon.ID=z.ID 
  AND mon.KLS_dog_id=kls_dog.id 
  AND mon.ZAKAZ_OLD_ID=old_mon.ID(+) 
  AND old_mon.stan_id=old_stan.ID (+) 
--  AND KLS_DOG.PREDPR_ID=FOR_TEMP.GET_AS_NUM('LC_PLAT','MASTER','GD_AGENT_2006.XLS') 
  AND KLS_DOG.DOG_NUMBER LIKE C.DOG_NUMBER 
--  AND mon.date_plan BETWEEN C.BEGIN_DATE AND C.END_DATE 
  AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT_2006.XLS' 
  AND mon.KLS_PROD_ID<>'90000' -- Без НЕФТИ 
  AND mon.PARUS_RN is null -- Без СНП 
  AND mon.IS_AGENT=1 -- Только агентские 
  AND mon.STAN_ID=KLS_STAN.ID 
  and mon.kls_prod_id=kls_prod.id_npr 
  and mon.POLUCH_ID=poluch.ID(+) 
  and mon.STAN_ID<>2595 -- без АВТОНАЛИВА 
GROUP BY 
  z.FROM_DATE, 
  c.BEGIN_DATE, 
  c.END_DATE, 
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
  -- Отказы 
  z.FROM_DATE, 
  c.BEGIN_DATE, 
  c.END_DATE, 
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
FROM month_all_row mon,v_gd_agent_2006_zakaz z,month_all,kls_dog,v_master_reports C, kls_stan,kls_prod,kls_predpr poluch 
WHERE month_all.KLS_dog_id=kls_dog.id 
  AND mon.month_all_id=month_all.id AND month_all.id=z.id 
--  AND KLS_DOG.PREDPR_ID=FOR_TEMP.GET_AS_NUM('LC_PLAT','MASTER','GD_AGENT_2006.XLS') 
  AND KLS_DOG.DOG_NUMBER LIKE C.DOG_NUMBER 
--  AND month_all.date_plan BETWEEN C.BEGIN_DATE AND C.END_DATE 
  AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT_2006.XLS' 
  AND month_all.KLS_PROD_ID<>'90000' -- Без НЕФТИ 
  AND month_all.PARUS_RN is null -- Без СНП 
  AND month_all.IS_AGENT=1 -- Только агентские 
  AND month_all.STAN_ID=KLS_STAN.ID 
  and month_all.kls_prod_id=kls_prod.id_npr 
  and mon.status_zakaz_id in (50) 
  and month_all.POLUCH_ID=poluch.ID(+) 
  and mon.STAN_ID<>2595 -- без АВТОНАЛИВА 
GROUP BY 
  z.FROM_DATE, 
  c.BEGIN_DATE, 
  c.END_DATE, 
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


