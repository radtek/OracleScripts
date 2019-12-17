--
-- V_RITM_POST_FACT  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_RITM_POST_FACT
(PLAT_ID, PLAT_NAME, NUM_DECADA, FACT_VES)
AS 
SELECT 
  --������ �����������: ���� �������� 
  PLAT_ID, 
  PLAT_NAME, 
  NUM_DECADA, 
  ROUND(SUM(FACT_VES),0) AS FACT_VES 
FROM 
( 
  SELECT /*+ RULE */ 
    plat.ID AS PLAT_ID, 
    plat.PREDPR_NAME AS PLAT_NAME, 
    (CASE 
        WHEN TO_NUMBER(TO_CHAR(KVIT.DATE_OTGR,'DD'))<=10 THEN 1 
        WHEN TO_NUMBER(TO_CHAR(KVIT.DATE_OTGR,'DD'))<=20 THEN 2 
  	    ELSE 3 
  	 END) AS NUM_DECADA, 
    KVIT.VES_BRUTTO AS FACT_VES 
  FROM KVIT,MONTH,KLS_DOG,KLS_PREDPR plat, 
           (SELECT * FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='RITM_POST.XLS') r 
  WHERE 
	KVIT.NOM_ZD=MONTH.NOM_ZD AND MONTH.DOG_ID=KLS_DOG.ID AND KLS_DOG.PREDPR_ID=plat.ID AND 
	KVIT.DATE_OTGR BETWEEN r.BEGIN_DATE AND r.END_DATE AND 
    KVIT.PROD_ID_NPR<>'90000' 
    AND KLS_DOG.AGENT_ID IN (8,1,4175) AND plat.ID<>1334 
    AND plat.ID=DECODE(r.IS_UNP,1,plat.ID,2641) 
) 
GROUP BY 
  PLAT_ID, 
  PLAT_NAME, 
  NUM_DECADA     
ORDER BY 
  PLAT_ID, 
  PLAT_NAME, 
  NUM_DECADA;


