--
-- V_GD_AGENT_2008_GU12_GRP  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GD_AGENT_2008_GU12_GRP
(GU12_A_ID, ZAYV_NUM, ZAYV_DATE, FROM_DATE, TO_DATE, 
 BEGIN_DATE, END_DATE, FOX_KOD, STAN_ID, STAN_NAME, 
 PROD_ID, PROD_NAME, IS_KORR, ORIG_KOL, ORIG_VES, 
 KOL, VES)
AS 
SELECT 
  /* ��� ������ ����������� � ������� ������ (������������� �� ������ � �������) */ 
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
  SUM(DECODE(IS_KORR,2,0,KOL)) as KOL, 
  SUM(DECODE(IS_KORR,2,0,VES)) as VES 
FROM V_GD_AGENT_2008_GU12 
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
  GU12_A_ID;


