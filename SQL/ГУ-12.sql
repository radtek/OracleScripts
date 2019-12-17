SELECT *  from v_master_reports

/* Данные о плательщике */
SELECT
  KLS_PREDPR.PREDPR_NAME
FROM KLS_PREDPR
WHERE ID=FOR_TEMP.GET_AS_NUM('LC_PLAT','MASTER','GD_AGENT.XLS')  

SELECT /*+ RULE */
  /* Предоставлено разнарядок */
  -- Основные заявки
  mon.client_number as RAZN_NUM,
  mon.client_date as RAZN_DATE,
  old_mon.STAN_ID as STAN_OLD_ID,
  old_STAN.STAN_NAME as STAN_OLD_NAME,
  mon.STAN_ID,
  KLS_STAN.STAN_NAME,
  KLS_PROD.ID_NPR as PROD_ID,
  kls_prod.NAME_NPR as PROD_NAME,
  mon.KOL,
  mon.REQUEST as VES,
  (
    SELECT COUNT(*) FROM kvit,month,v_master_reports C,kls_vid_otgr 
	 WHERE kvit.nom_zd=month.nom_zd AND month.zakaz_id=mon.id
--       AND kvit.date_oforml>=TO_DATE(TO_CHAR(C.BEGIN_DATE-1,'dd.mm.yyyy')||' 17:00','dd.mm.yyyy hh24:mi') 
--       AND kvit.date_oforml<=TO_DATE(TO_CHAR(C.END_DATE,'dd.mm.yyyy')||' 17:00','dd.mm.yyyy hh24:mi') 
       AND kvit.date_otgr>=C.BEGIN_DATE 
       AND kvit.date_otgr<=C.END_DATE
       AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT.XLS' 
       AND month.PROD_ID_NPR<>'90000' -- Без НЕФТИ 
       AND month.load_abbr=kls_vid_otgr.load_abbr 
       AND kls_vid_otgr.LOAD_TYPE_ID IN (1,6) -- Только ЖД и контейнеры 
   ) as SPEED_KOL,
  (
    SELECT SUM(kvit.ves_brutto) FROM kvit,month,v_master_reports C,kls_vid_otgr 
	 WHERE kvit.nom_zd=month.nom_zd AND month.zakaz_id=mon.id
--       AND kvit.date_oforml>=TO_DATE(TO_CHAR(C.BEGIN_DATE-1,'dd.mm.yyyy')||' 17:00','dd.mm.yyyy hh24:mi') 
--       AND kvit.date_oforml<=TO_DATE(TO_CHAR(C.END_DATE,'dd.mm.yyyy')||' 17:00','dd.mm.yyyy hh24:mi') 
       AND kvit.date_otgr>=C.BEGIN_DATE 
       AND kvit.date_otgr<=C.END_DATE
       AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT.XLS' 
       AND month.PROD_ID_NPR<>'90000' -- Без НЕФТИ 
       AND month.load_abbr=kls_vid_otgr.load_abbr 
       AND kls_vid_otgr.LOAD_TYPE_ID IN (1,6) -- Только ЖД и контейнеры 
   ) as SPEED_VES,
  DECODE(mon.ZAKAZ_OLD_ID,NULL,'','В счет заказа № '||old_mon.CLIENT_NUMBER||' ст.'||old_stan.STAN_NAME || ' ')  as PRIM,
  10 as STATUS_ZAKAZ_ID
FROM month_all mon,kls_dog,v_master_reports C, kls_stan,kls_prod,month_all old_mon,kls_stan old_stan
WHERE mon.KLS_dog_id=kls_dog.id
  AND mon.ZAKAZ_OLD_ID=old_mon.ID(+)
  AND old_mon.stan_id=old_stan.ID (+)
  AND KLS_DOG.PREDPR_ID=FOR_TEMP.GET_AS_NUM('LC_PLAT','MASTER','GD_AGENT.XLS')
  AND mon.date_plan BETWEEN C.BEGIN_DATE AND C.END_DATE
  AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT.XLS'
  AND mon.KLS_PROD_ID<>'90000' -- Без НЕФТИ
  AND mon.PARUS_RN is null -- Без СНП
  AND mon.IS_AGENT=1 -- Только агентские
  AND mon.STAN_ID=KLS_STAN.ID
  and mon.kls_prod_id=kls_prod.id_npr
UNION ALL
SELECT /*+ RULE */
  -- Переадресовки в пути
  mon.client_number as RAZN_NUM,
  mon.client_date as RAZN_DATE,
  mon.STAN_OLD_ID,
  old_stan.STAN_NAME as STAN_OLD_NAME,
  mon.STAN_ID,
  KLS_STAN.STAN_NAME,
  KLS_PROD.ID_NPR as PROD_ID,
  kls_prod.NAME_NPR as PROD_NAME,
  ABS(mon.KOL) as KOL,
  ABS(mon.REQUEST) as VES,
  ABS(mon.SPEED_KOL) as SPEED_KOL,
  ABS(mon.SPEED_VES) as SPEED_VES,
  ''  as PRIM,
  mon.STATUS_ZAKAZ_ID
FROM month_all_row mon,month_all,kls_dog,v_master_reports C, kls_stan,kls_prod, kls_stan old_stan
WHERE mon.KLS_dog_id=kls_dog.id
  AND mon.month_all_id=month_all.id
  AND KLS_DOG.PREDPR_ID=FOR_TEMP.GET_AS_NUM('LC_PLAT','MASTER','GD_AGENT.XLS')
  AND month_all.date_plan BETWEEN C.BEGIN_DATE AND C.END_DATE
  AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT.XLS'
  AND mon.KLS_PROD_ID<>'90000' -- Без НЕФТИ
  AND month_all.PARUS_RN is null -- Без СНП
  AND month_all.IS_AGENT=1 -- Только агентские
  AND mon.STAN_ID=KLS_STAN.ID
  AND mon.STAN_OLD_ID=old_stan.ID
  and mon.kls_prod_id=kls_prod.id_npr
  and mon.status_zakaz_id in (41,42)
UNION ALL
SELECT /*+ RULE */
  -- Отказы
  mon.client_number as RAZN_NUM,
  mon.client_date as RAZN_DATE,
  NULL as STAN_OLD_ID,
  NULL as STAN_OLD_NAME,
  mon.STAN_ID,
  KLS_STAN.STAN_NAME,
  KLS_PROD.ID_NPR as PROD_ID,
  kls_prod.NAME_NPR as PROD_NAME,
  ABS(mon.KOL) as KOL,
  ABS(mon.REQUEST) as VES,
  ABS(mon.SPEED_KOL) as SPEED_KOL,
  ABS(mon.SPEED_VES) as SPEED_VES,
  ''  as PRIM,
  mon.STATUS_ZAKAZ_ID
FROM month_all_row mon,month_all,kls_dog,v_master_reports C, kls_stan,kls_prod
WHERE mon.KLS_dog_id=kls_dog.id
  AND mon.month_all_id=month_all.id
  AND KLS_DOG.PREDPR_ID=FOR_TEMP.GET_AS_NUM('LC_PLAT','MASTER','GD_AGENT.XLS')
  AND month_all.date_plan BETWEEN C.BEGIN_DATE AND C.END_DATE
  AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT.XLS'
  AND mon.KLS_PROD_ID<>'90000' -- Без НЕФТИ
  AND month_all.PARUS_RN is null -- Без СНП
  AND month_all.IS_AGENT=1 -- Только агентские
  AND mon.STAN_ID=KLS_STAN.ID
  and mon.kls_prod_id=kls_prod.id_npr
  and mon.status_zakaz_id in (50)
ORDER BY
  razn_date,
  razn_num,
  prod_id,
  STAN_NAME


 

/* Представлено разнарядок */
SELECT * FROM V_GD_AGENT_MONTH_ALL
WHERE STATUS_ZAKAZ_ID=10

/* Переадресовки (в пути и на станции назначения) */ 
SELECT * FROM V_GD_AGENT_MONTH_ALL
WHERE STATUS_ZAKAZ_ID IN (41,42)

/* Кол-во переадресовок */
SELECT 
  SUM(DECODE(STATUS_ZAKAZ_ID,41,KOL,0)) as READDR_VPUTI,
  SUM(DECODE(STATUS_ZAKAZ_ID,42,KOL,0)) as READDR_STAN
FROM V_GD_AGENT_MONTH_ALL
WHERE STATUS_ZAKAZ_ID IN (41,42)

  
/* Отказы клиента */ 
SELECT * FROM V_GD_AGENT_MONTH_ALL
WHERE STATUS_ZAKAZ_ID=50
   


CREATE OR REPLACE VIEW V_GD_AGENT_GU12 AS  
SELECT /*+ RULE */
  /* Все заявки, действующие в отчетном месяце */
  gu12_a.ID as GU12_A_ID, 
  gu12_a.NOM_Z as ZAYV_NUM,
  gu12_a.REG_DATE as ZAYV_DATE,
  gu12_a.FROM_DATE,
  gu12_a.TO_DATE,
  C.BEGIN_DATE,
  C.END_DATE,
  gu12_b.NOM_LETTER as RAZN_NUM,
  gu12_b.DATE_LETTER as RAZN_DATE,
  gu12_b.STAN_ID,
  KLS_STAN.STAN_NAME,
  KLS_PROD_GU12.ID as PROD_ID,
  kls_prod_gu12.NAME_GU12 as PROD_NAME,
  gu12_b.KOL_VAG as KOL,
  gu12_b.VES as VES,
  NVL(gu12_b.ISCOR,0) as IS_KORR,
  GU12_B.FOX_KOD
FROM gu12_a,gu12_b,v_master_reports C,kls_stan,kls_prod_gu12
WHERE gu12_b.ID_A=gu12_a.id 
  AND gu12_b.PLAT_ID=FOR_TEMP.GET_AS_NUM('LC_PLAT','MASTER','GD_AGENT.XLS') 
  AND gu12_a.from_date<=C.END_DATE
  AND gu12_a.to_date>=C.BEGIN_DATE  
  AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT.XLS'
  and gu12_a.PROD_ID=kls_prod_gu12.ID
  AND gu12_a.PROD_ID<>201005 -- Без НЕФТИ
  AND gu12_b.STAN_ID=KLS_STAN.ID
   

CREATE OR REPLACE VIEW V_GD_AGENT_GU12_GRP AS  
SELECT 
  /* Все заявки действующие в текущем месяце (сгруппированы по Номеру и Станции) */
  GU12_A_ID,
  ZAYV_NUM,
  ZAYV_DATE,
  FROM_DATE,
  TO_DATE,
  BEGIN_DATE,
  END_DATE,
  MIN(FOX_KOD) as FOX_KOD,
  STAN_ID,
  STAN_NAME,
  PROD_ID,
  PROD_NAME,
  MAX(IS_KORR) as IS_KORR, 
  SUM(DECODE(IS_KORR,1,0,KOL)) as ORIG_KOL,
  SUM(DECODE(IS_KORR,1,0,VES)) as ORIG_VES,
  SUM(KOL) as KOL,
  SUM(VES) as VES
FROM V_GD_AGENT_GU12 
GROUP BY
  ZAYV_NUM,
  ZAYV_DATE,
  FROM_DATE,
  TO_DATE,
  BEGIN_DATE,
  END_DATE,
  STAN_ID,
  STAN_NAME,
  PROD_ID,
  PROD_NAME,
  GU12_A_ID


CREATE OR REPLACE VIEW V_GD_AGENT_GU12_ZAYV AS  
SELECT 
  /* Все заявки поданные в текущем месяце */
  *
FROM V_GD_AGENT_GU12_GRP 
WHERE from_date BETWEEN BEGIN_DATE AND END_DATE
  AND ORIG_KOL>0 

SELECT * FROM V_GD_AGENT_GU12_ZAYV
ORDER BY  
  ZAYV_DATE,
  PROD_ID,
  FOX_KOD

CREATE OR REPLACE VIEW V_GD_AGENT_GU12_KORR AS  
SELECT 
  /* Корректировки заявок */
  GU12_A_ID,
  ZAYV_NUM,
  ZAYV_DATE,
  RAZN_NUM,
  NVL(RAZN_DATE,ZAYV_DATE) as RAZN_DATE,
  FROM_DATE,
  TO_DATE,
  BEGIN_DATE,
  END_DATE,
  FOX_KOD,
  STAN_ID,
  STAN_NAME,
  PROD_ID,
  PROD_NAME,
  KOL as KOL,
  VES as VES
FROM V_GD_AGENT_GU12 
WHERE IS_KORR=1 AND KOL>0 AND VES>0
  AND from_date BETWEEN BEGIN_DATE AND END_DATE

/* Корректировки заявок */
SELECT * FROM V_GD_AGENT_GU12_KORR
ORDER BY  
  RAZN_DATE,
  ZAYV_DATE,
  PROD_ID,
  FOX_KOD

/* Кол-во бланков заявок */
SELECT COUNT(*) as KOL 
FROM (SELECT DISTINCT ZAYV_NUM FROM V_GD_AGENT_GU12_ZAYV
      UNION ALL 
      SELECT DISTINCT ZAYV_NUM FROM V_GD_AGENT_GU12_KORR)   
  
/* Тонн в изменяемых заявках */
SELECT SUM(VES) as VES FROM V_GD_AGENT_GU12_KORR


/* Список заявок ГУ-12, по которым была отгрузка в отчетном месяце и переходящие заявки с прошлого месяца */
CREATE OR REPLACE VIEW V_GD_AGENT_GU12_LIST AS  
SELECT /*+ RULE */
  GU12_A_ID,
  STAN_ID,
  SUM(kvit_vnut) as kvit_vnut,
  SUM(kvit_exp) as kvit_exp,
  SUM(client_kol) as client_kol,
  SUM(client_ves) as client_ves,
  SUM(fact_ves) as fact_ves,
  SUM(mps_vnut_before) as mps_vnut_before,
  SUM(sobs_vnut_before) as sobs_vnut_before,
  SUM(mps_exp_before) as mps_exp_before,
  SUM(sobs_exp_before) as sobs_exp_before
FROM
(  
SELECT /*+ RULE */
  month.GU12_A_ID,
  month.STAN_ID,
  kvit.num_kvit,
  DECODE(month.is_exp,0,1,0) as kvit_vnut,
  DECODE(month.is_exp,1,1,0) as kvit_exp,
  COUNT(*) as client_kol, -- Отгружено вагонов 
  SUM(kvit.ves_brutto) as client_ves, -- Вес клиента
  SUM(DECODE(SIGN(kvit.ves_brutto+kvit.upak_ves-10),1,CEIL(kvit.ves_brutto+kvit.upak_ves),CEIL((kvit.ves_brutto+kvit.upak_ves)*10)/10)) as fact_ves, -- Вес ЖД
  SUM(CASE
        -- Отгружено ранее срока вагонов МПС по России 
        WHEN kvit.date_kvit<A.ZAYV_DATE+10 AND month.IS_EXP=0 AND kvit.VAGOWNER_ID=3
		  THEN 1
		  ELSE 0
	  END) as MPS_VNUT_BEFORE,
  SUM(CASE
        -- Отгружено ранее срока НЕ вагонов МПС по России 
        WHEN kvit.date_kvit<A.ZAYV_DATE+10 AND month.IS_EXP=0 AND kvit.VAGOWNER_ID<>3
		  THEN 1
		  ELSE 0
	  END) as SOBS_VNUT_BEFORE,
  SUM(CASE
        -- Отгружено ранее срока вагонов МПС на Экспорт 
        WHEN kvit.date_kvit<A.ZAYV_DATE+15 AND month.IS_EXP=1 AND kvit.VAGOWNER_ID=3
		  THEN 1
		  ELSE 0
	  END) as MPS_EXP_BEFORE,
  SUM(CASE
        -- Отгружено ранее срока НЕ вагонов МПС на Экспорт 
        WHEN kvit.date_kvit<A.ZAYV_DATE+15 AND month.IS_EXP=1 AND kvit.VAGOWNER_ID<>3
		  THEN 1
		  ELSE 0
	  END) as SOBS_EXP_BEFORE
FROM month,kvit,V_GD_AGENT_GU12_GRP A,v_master_reports C,kls_dog,kls_vid_otgr
WHERE month.nom_zd=kvit.nom_zd
  AND month.GU12_A_ID=A.GU12_A_ID(+)
  AND month.STAN_ID=A.STAN_ID(+)
  AND month.dog_id=kls_dog.id
  AND KLS_DOG.PREDPR_ID=FOR_TEMP.GET_AS_NUM('LC_PLAT','MASTER','GD_AGENT.XLS') 
  AND kvit.date_oforml>=TO_DATE(TO_CHAR(C.BEGIN_DATE-1,'dd.mm.yyyy')||' 17:00','dd.mm.yyyy hh24:mi')
  AND kvit.date_oforml<=TO_DATE(TO_CHAR(C.END_DATE,'dd.mm.yyyy')||' 17:00','dd.mm.yyyy hh24:mi')
  AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT.XLS'
  AND month.PROD_ID_NPR<>'90000' -- Без НЕФТИ
  AND month.load_abbr=kls_vid_otgr.load_abbr
  AND kls_vid_otgr.LOAD_TYPE_ID IN (1,6) -- Только ЖД и контейнеры
GROUP BY
  month.GU12_A_ID,
  month.STAN_ID,
  kvit.num_kvit,
  month.is_exp
UNION ALL
SELECT
  GU12_A_ID,
  STAN_ID,
  0 as num_kvit,
  0 as kvit_vnut,
  0 as kvit_exp,
  0 as client_kol,
  0 as client_ves,
  0 as fact_ves,
  0 as mps_vnut_before,
  0 as sobs_vnut_before,
  0 as mps_exp_before,
  0 as sobs_exp_before
FROM
  V_GD_AGENT_GU12_GRP
WHERE FROM_DATE<BEGIN_DATE  
)  
GROUP BY
  GU12_A_ID,
  STAN_ID


/* Отгружено всего в отчетном месяце по плану перевозок*/
/* Отправлено вагонов ранее сроков */  
SELECT /*+ RULE */
  SUM(kvit_vnut) as kol_kvit_vnut,
  SUM(kvit_exp) as kol_kvit_exp,
  SUM(client_kol) as kol_vag,
  SUM(client_ves) as ves,
  SUM(MPS_VNUT_BEFORE) as MPS_VNUT_BEFORE,
  SUM(SOBS_VNUT_BEFORE) as SOBS_VNUT_BEFORE,
  SUM(MPS_EXP_BEFORE) as MPS_EXP_BEFORE,
  SUM(SOBS_EXP_BEFORE) as SOBS_EXP_BEFORE
FROM V_GD_AGENT_GU12_LIST
  

/* Отгружено всего в отчетном месяце по плану поставок*/
CREATE OR REPLACE VIEW V_GD_AGENT_FACT AS
SELECT /*+ RULE */
  SUM(ves_brutto) as ves,
  COUNT(*) as kol
FROM kvit,month,v_master_reports C,kls_vid_otgr,kls_dog 
WHERE kvit.nom_zd=month.nom_zd 
  AND kvit.date_otgr>=C.BEGIN_DATE 
  AND kvit.date_otgr<=C.END_DATE
  AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT.XLS' 
  AND month.PROD_ID_NPR<>'90000' -- Без НЕФТИ 
  AND month.load_abbr=kls_vid_otgr.load_abbr 
  AND kls_vid_otgr.LOAD_TYPE_ID IN (1,6) -- Только ЖД и контейнеры 
  AND month.DOG_ID=kls_dog.ID
  AND KLS_DOG.PREDPR_ID=FOR_TEMP.GET_AS_NUM('LC_PLAT','MASTER','GD_AGENT.XLS')
  AND month.date_plan BETWEEN C.BEGIN_DATE AND C.END_DATE



CREATE OR REPLACE VIEW V_GD_AGENT_MONTH AS  
SELECT /*+ RULE */
  -- Заявки из ФИНАНСОВ с привязкой ГУ-12 - для расчета штрафов и сборов
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
FROM month,kvit,V_GD_AGENT_GU12_GRP A, V_GD_AGENT_GU12_LIST AA, kls_stan, kls_dog, kls_vid_otgr, v_master_reports C
WHERE month.nom_zd=kvit.nom_zd
  AND month.GU12_A_ID=AA.GU12_A_ID -- Только из списка
  AND month.STAN_ID=AA.STAN_ID -- Только из списка
  AND month.GU12_A_ID=A.GU12_A_ID -- Реквизиты заявок
  AND month.STAN_ID=A.STAN_ID -- Реквизиты заявок
  AND month.dog_id=kls_dog.id
  AND month.stan_id=kls_stan.id
  AND KLS_DOG.PREDPR_ID=FOR_TEMP.GET_AS_NUM('LC_PLAT','MASTER','GD_AGENT.XLS') 
  AND month.PROD_ID_NPR<>'90000' -- Без НЕФТИ
  AND month.load_abbr=kls_vid_otgr.load_abbr
  AND kls_vid_otgr.LOAD_TYPE_ID IN (1,6) -- Только ЖД и контейнеры
  AND kvit.date_oforml<=TO_DATE(TO_CHAR(C.END_DATE,'dd.mm.yyyy')||' 17:00','dd.mm.yyyy hh24:mi')
  AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT.XLS'
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
  month.nom_zd

/* Заявки из ФИНАНСОВ */
SELECT *
FROM V_GD_AGENT_MONTH

 
SELECT sum(client_kol) FROM V_GD_AGENT_MONTH
ORDER BY  
  from_date,
  to_date,
  nom_zd  
  
/* Не отгружено по станции */
SELECT
  SUM(DECODE(SIGN(ZAYV_VES-FACT_VES),1,ZAYV_VES-FACT_VES,0)) as VES
FROM
(
SELECT
  GU12_A_ID,
  STAN_ID,
  VES as ZAYV_VES,
  SUM(FACT_VES) as FACT_VES
FROM V_GD_AGENT_MONTH  
WHERE TO_DATE<=END_DATE
GROUP BY
  GU12_A_ID,
  STAN_ID,
  VES
)
  
/* Неотгружено в целом по заявкам */
SELECT
  SUM(DECODE(SIGN(ZAYV_VES-FACT_VES),1,ZAYV_VES-FACT_VES,0)) as VES
FROM
(
SELECT
  GU12_A_ID,
  VES as ZAYV_VES,
  SUM(FACT_VES) as FACT_VES
FROM V_GD_AGENT_MONTH  
WHERE TO_DATE<=END_DATE
GROUP BY
  GU12_A_ID,
  VES
)
    