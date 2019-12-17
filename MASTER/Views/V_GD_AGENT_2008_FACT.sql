--
-- V_GD_AGENT_2008_FACT  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GD_AGENT_2008_FACT
(VES, KOL)
AS 
SELECT /*+ ORDERED INDEX(kvit) USE_NL(month,kvit,C,kls_vid_otgr,kls_dog ) */
  ROUND(SUM(ves_brutto)) as ves,
  COUNT(*) as kol
FROM (SELECT * FROM v_master_reports WHERE NLS_UPPER(REPORT_FILE)='GD_AGENT_2008.XLS') C, kvit,month,kls_vid_otgr,kls_dog
WHERE kvit.date_otgr>=C.BEGIN_DATE
  AND kvit.date_otgr<=C.END_DATE
  AND kvit.nom_zd=month.nom_zd
  AND month.PROD_ID_NPR<>'90000' -- Без НЕФТИ
  AND month.load_abbr=kls_vid_otgr.load_abbr
  AND kls_vid_otgr.LOAD_TYPE_ID IN (1,6) -- Только ЖД и контейнеры
  AND month.DOG_ID=kls_dog.ID
--  AND KLS_DOG.PREDPR_ID=FOR_TEMP.GET_AS_NUM('LC_PLAT','MASTER','GD_AGENT.XLS')
  AND KLS_DOG.DOG_NUMBER LIKE C.DOG_NUMBER
  AND month.date_plan BETWEEN C.BEGIN_DATE AND C.END_DATE;


