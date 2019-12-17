--
-- V_RITM_POST_PLAN  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_RITM_POST_PLAN
(PLAT_ID, PLAT_NAME, PLAN_VES)
AS 
SELECT
  -- ������ �����������: ���� �������� � ������ ���
  plat.ID AS PLAT_ID,
  plat.PREDPR_NAME AS PLAT_NAME,
  SUM(A.PLAN_VES) AS PLAN_VES
FROM PLAN_POST A, PLAN_PERIODS P, KLS_DOG D, KLS_PREDPR plat,
           (SELECT * FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='RITM_POST.XLS') r
WHERE A.DOG_ID=D.ID
      AND A.PLAN_ID IN (2,3)
      AND A.PLAN_PER_ID=P.ID
	  AND P.DATE_PLAN BETWEEN TRUNC(r.BEGIN_DATE,'MONTH') AND LAST_DAY(r.END_DATE)
	  AND D.PREDPR_ID=plat.ID
	  AND A.PROD_ID_NPR<>'90000'
	  AND D.AGENT_ID IN (8,1,4175) AND plat.ID<>1334
	  AND plat.ID=DECODE(r.IS_UNP,1,plat.ID,2641)
GROUP BY
  plat.ID,
  plat.PREDPR_NAME
ORDER BY
  plat.ID,
  plat.PREDPR_NAME;


