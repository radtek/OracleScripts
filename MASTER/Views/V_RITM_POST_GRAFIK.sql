--
-- V_RITM_POST_GRAFIK  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_RITM_POST_GRAFIK
(PLAT_ID, PLAT_NAME, NUM_DECADA, GRAF_VES)
AS 
SELECT
  --������ �����������: ������ �������� �� �������
  PLAT_ID,
  PLAT_NAME,
  NUM_DECADA,
  ROUND(SUM(GRAF_VES),0) AS GRAF_VES
FROM
(
  -- ������ �������� �� ��
  SELECT /*+ RULE */
    plat.ID AS PLAT_ID,
    plat.PREDPR_NAME AS PLAT_NAME,
    (CASE
        WHEN TO_NUMBER(TO_CHAR(GU12_BR.DATE_R,'DD'))<=10 THEN 1
        WHEN TO_NUMBER(TO_CHAR(GU12_BR.DATE_R,'DD'))<=20 THEN 2
  	    ELSE 3
  	 END) AS NUM_DECADA,
    GU12_BR.VES AS GRAF_VES
  FROM GU12_A,GU12_B,GU12_BR,KLS_PREDPR plat,
           (SELECT * FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='RITM_POST.XLS') r
  WHERE
	GU12_BR.ID_B=GU12_B.ID AND
    GU12_B.ID_A=GU12_A.ID AND
	GU12_BR.DATE_R BETWEEN r.BEGIN_DATE AND r.END_DATE AND
	GU12_B.PLAT_ID=plat.ID
    AND GU12_A.PROD_ID<>'201005'
    AND plat.ID=DECODE(r.IS_UNP,1,plat.ID,2641)
  UNION ALL
  -- ������ �������� �� ����������
  SELECT
    pp.PLAT_ID,
    pp.PLAT_NAME,
    wd.NUM_DECADA,
    pp.PLAN_VES*wd.COUNT_DECADA/wd.COUNT_MON AS GRAF_VES
  FROM
  (
    SELECT /*+ RULE */
      plat.ID AS PLAT_ID,
      plat.PREDPR_NAME AS PLAT_NAME,
      SUM(ZAKAZ.VES) AS plan_ves
    FROM ZAKAZ,KLS_DOG,KLS_PREDPR plat,
           (SELECT * FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='RITM_POST.XLS') r
    WHERE ZAKAZ.DOG_ID=KLS_DOG.ID AND KLS_DOG.PREDPR_ID=plat.ID AND
      ZAKAZ.STAN_ID=2595 AND -- ���������
   	  ZAKAZ.IS_ACCEPT=1 AND -- ������������
      ZAKAZ.DATE_PLAN BETWEEN TRUNC(r.BEGIN_DATE,'MONTH') AND LAST_DAY(r.END_DATE) AND
	  ZAKAZ.IS_AGENT=1 -- ������ ������ ���
	  AND KLS_DOG.AGENT_ID IN (8,1,4175) AND plat.ID<>1334
      AND plat.ID=DECODE(r.IS_UNP,1,plat.ID,2641)
    GROUP BY
      plat.ID,
      plat.PREDPR_NAME
  ) pp,
  (
     -- ������ ���-�� ������� ���� ��������� � �� �����
    SELECT
      A.NUM_DECADA,
  	  SUM(A.IS_WORK) AS COUNT_DECADA,
      MAX(B.COUNT_MON) AS COUNT_MON
    FROM
      (
       SELECT
          (CASE
            WHEN TO_NUMBER(TO_CHAR(VALUE,'DD'))<=10 THEN 1
            WHEN TO_NUMBER(TO_CHAR(VALUE,'DD'))<=20 THEN 2
  	        ELSE 3
    	   END) AS NUM_DECADA,
          IS_WORK
        FROM KLS_DATES,
           (SELECT * FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='RITM_POST.XLS') r
        WHERE VALUE BETWEEN r.BEGIN_DATE AND r.END_DATE
	  ) a,
      (
       SELECT
          SUM(IS_WORK) AS COUNT_MON
        FROM KLS_DATES,
           (SELECT * FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='RITM_POST.XLS') r
        WHERE VALUE BETWEEN TRUNC(r.BEGIN_DATE,'MONTH') AND LAST_DAY(r.END_DATE)
	  ) b
    GROUP BY A.NUM_DECADA
  ) wd
)
GROUP BY
  PLAT_ID,
  PLAT_NAME,
  NUM_DECADA
ORDER BY
  PLAT_ID,
  PLAT_NAME,
  NUM_DECADA;


