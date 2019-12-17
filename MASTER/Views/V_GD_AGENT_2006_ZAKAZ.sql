--
-- V_GD_AGENT_2006_ZAKAZ  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GD_AGENT_2006_ZAKAZ
(ID, FROM_DATE, KOL, REQUEST, FACT_KOL, 
 FACT_VES)
AS 
SELECT
  ID,
  FROM_DATE,
  MAX(KOL) as KOL,
  MAX(REQUEST) as REQUEST,
  SUM(FACT_KOL) as FACT_KOL,
  SUM(FACT_VES) as FACT_VES
FROM
(     
SELECT /*+ RULE */
  /* Предоставлено заявок */
  mon.ID,
  TRUNC(NVL(gu12_a.FROM_DATE,mon.DATE_PLAN),'MONTH') as FROM_DATE,
  NVL(mon.KOL,0) as KOL,
  NVL(mon.REQUEST,0) as REQUEST,
  (CASE WHEN gu12_a.id is null then 0 ELSE NVL(mon_r.LOAD_KOL,0) END) as LOAD_KOL,
  (CASE WHEN gu12_a.id is null then 0 ELSE NVL(mon_r.LOAD_VES,0) END) as LOAD_VES,
  NVL((SELECT COUNT(*) FROM kvit WHERE kvit.nom_zd=month.nom_zd),0) as FACT_KOL,
  NVL((SELECT SUM(kvit.ves_brutto) FROM kvit WHERE kvit.nom_zd=month.nom_zd),0) as FACT_VES
FROM month_all mon,v_master_reports C,
  (
  select * from zakaz_hist where status_zakaz_id=20
  ) mon_r,
  month,gu12_a
WHERE mon.id=mon_r.zakaz_id(+)
  AND mon_r.nom_zd=month.nom_zd(+)
  AND month.GU12_A_ID=GU12_A.ID(+)
  AND mon.IS_AGENT=1
  AND DECODE(gu12_a.id,NULL,mon.DATE_PLAN,gu12_a.ZAKR_DATE) BETWEEN C.BEGIN_DATE AND C.END_DATE -- Если нет плана перевозок
  AND NLS_UPPER(C.REPORT_FILE)='GD_AGENT_2006.XLS'
)
GROUP BY
ID,FROM_DATE;


