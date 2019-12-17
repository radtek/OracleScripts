--
-- V_GD_AGENT_2008_GU12_LIST  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GD_AGENT_2008_GU12_LIST
(GU12_A_ID, STAN_ID, KVIT_VNUT, KVIT_EXP, CLIENT_KOL, 
 CLIENT_VES, FACT_VES, MPS_VNUT_BEFORE, SOBS_VNUT_BEFORE, MPS_EXP_BEFORE, 
 SOBS_EXP_BEFORE, MPS_VNUT_KV_BEFORE, SOBS_VNUT_KV_BEFORE, MPS_EXP_KV_BEFORE, SOBS_EXP_KV_BEFORE)
AS 
SELECT /*+ RULE */
  /* Факт отгрузки в отчетном периоде по заявкам */
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
  SUM(sobs_exp_before) as sobs_exp_before,
  SUM(
    CASE
      WHEN num_kvit>0 AND mps_vnut_before>0 THEN 1
      ELSE 0
    END) as mps_vnut_kv_before,   
  SUM(
    CASE
      WHEN num_kvit>0 AND sobs_vnut_before>0 THEN 1
      ELSE 0
    END) as sobs_vnut_kv_before,   
  SUM(
    CASE
      WHEN num_kvit>0 AND mps_exp_before>0 THEN 1
      ELSE 0
    END) as mps_exp_kv_before,   
  SUM(
    CASE
      WHEN num_kvit>0 AND sobs_exp_before>0 THEN 1
      ELSE 0
    END) as sobs_exp_kv_before   
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
        WHEN kvit.date_kvit>=TO_DATE('01.01.2006','dd.mm.yyyy') AND kvit.date_kvit<=A.ZAYV_DATE+10 AND month.IS_EXP=0 AND kvit.VAGOWNER_ID=3 THEN 1
        WHEN kvit.date_kvit<TO_DATE('01.01.2006','dd.mm.yyyy') AND kvit.date_kvit<A.ZAYV_DATE+10 AND month.IS_EXP=0 AND kvit.VAGOWNER_ID=3 THEN 1
  	    ELSE 0
	  END) as MPS_VNUT_BEFORE,
  SUM(CASE
        -- Отгружено ранее срока НЕ вагонов МПС по России
        WHEN kvit.date_kvit>=TO_DATE('01.01.2006','dd.mm.yyyy') AND kvit.date_kvit<=A.ZAYV_DATE+10 AND month.IS_EXP=0 AND kvit.VAGOWNER_ID<>3 THEN 1
        WHEN kvit.date_kvit<TO_DATE('01.01.2006','dd.mm.yyyy') AND kvit.date_kvit<A.ZAYV_DATE+10 AND month.IS_EXP=0 AND kvit.VAGOWNER_ID<>3 THEN 1
  	    ELSE 0
	  END) as SOBS_VNUT_BEFORE,
  SUM(CASE
        -- Отгружено ранее срока вагонов МПС на Экспорт
        WHEN kvit.date_kvit>=TO_DATE('01.01.2006','dd.mm.yyyy') AND kvit.date_kvit<=A.ZAYV_DATE+15 AND month.IS_EXP=1 AND kvit.VAGOWNER_ID=3 THEN 1
        WHEN kvit.date_kvit<TO_DATE('01.01.2006','dd.mm.yyyy') AND kvit.date_kvit<A.ZAYV_DATE+15 AND month.IS_EXP=1 AND kvit.VAGOWNER_ID=3 THEN 1
		ELSE 0
	  END) as MPS_EXP_BEFORE,
  SUM(CASE
        -- Отгружено ранее срока НЕ вагонов МПС на Экспорт
        WHEN kvit.date_kvit>=TO_DATE('01.01.2006','dd.mm.yyyy') AND kvit.date_kvit<=A.ZAYV_DATE+15 AND month.IS_EXP=1 AND kvit.VAGOWNER_ID<>3 THEN 1
        WHEN kvit.date_kvit<TO_DATE('01.01.2006','dd.mm.yyyy') AND kvit.date_kvit<A.ZAYV_DATE+15 AND month.IS_EXP=1 AND kvit.VAGOWNER_ID<>3 THEN 1
		ELSE 0
	  END) as SOBS_EXP_BEFORE
FROM month,kvit,V_GD_AGENT_2008_GU12_GRP A,v_master_reports C,kls_dog,kls_vid_otgr
WHERE month.nom_zd=kvit.nom_zd
  AND month.GU12_A_ID=A.GU12_A_ID(+)
  AND month.STAN_ID=A.STAN_ID(+)
  AND month.dog_id=kls_dog.id
--  AND KLS_DOG.PREDPR_ID=FOR_TEMP.GET_AS_NUM('LC_PLAT','MASTER','GD_AGENT.XLS')
  AND KLS_DOG.DOG_NUMBER LIKE C.DOG_NUMBER
  AND kvit.date_oforml>=TO_DATE(TO_CHAR(C.BEGIN_DATE-1,'dd.mm.yyyy')||' 17:00','dd.mm.yyyy hh24:mi')
  AND kvit.date_oforml<TO_DATE(TO_CHAR(C.END_DATE+1,'dd.mm.yyyy')||' 00:00','dd.mm.yyyy hh24:mi')
  AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT_2008.XLS'
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
  V_GD_AGENT_2008_GU12_GRP
--WHERE FROM_DATE<BEGIN_DATE
)
GROUP BY
  GU12_A_ID,
  STAN_ID;


