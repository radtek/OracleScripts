--
-- V_FIL_SUT_REAL_GRP  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FIL_SUT_REAL_GRP
(DATE_BEGIN, DATE_END, DATE_PLAN, FILIAL_ORDER, FILIAL_ID, 
 FILIAL_NAME, ORG_KIND_ORDER, ORG_KIND_ID, ORG_KIND_NAME, ORG_STRU_ORDER, 
 ORG_STRU_ID, ORG_STRU_NAME, GROUP_ORDER, GROUP_NAME, GROUP_FULL_NAME, 
 FACT_REAL_VES, AVG_SUT_REAL_VES, FACT_REAL_SUMMA, AVG_SUT_REAL_SUMMA, END_OST, 
 PLAN_REAL_VES, NORMA_REAL_VES)
AS 
SELECT
  DATE_BEGIN,
  DATE_END,
  DATE_PLAN,
  FILIAL_ORDER,
  FILIAL_ID,
  FILIAL_NAME,
  ORG_KIND_ORDER,
  ORG_KIND_ID,
  ORG_KIND_NAME,
  ORG_STRU_ORDER,
  ORG_STRU_ID,
  ORG_STRU_NAME,
  GROUP_ORDER,
  GROUP_NAME,
  GROUP_FULL_NAME,
  SUM(FACT_REAL_VES) AS FACT_REAL_VES,
  SUM(AVG_SUT_REAL_VES) AS AVG_SUT_REAL_VES,
  SUM(FACT_REAL_SUMMA) AS FACT_REAL_SUMMA,
  SUM(AVG_SUT_REAL_SUMMA) AS AVG_SUT_REAL_SUMMA,
  SUM(END_OST) AS END_OST,
  SUM(PLAN_REAL_VES) as PLAN_REAL_VES,
  SUM(NORMA_REAL_VES) as NORMA_REAL_VES
FROM V_FIL_SUT_REAL
GROUP BY
  DATE_BEGIN,
  DATE_END,
  DATE_PLAN,
  FILIAL_ORDER,
  FILIAL_ID,
  FILIAL_NAME,
  ORG_KIND_ORDER,
  ORG_KIND_ID,
  ORG_KIND_NAME,
  ORG_STRU_ORDER,
  ORG_STRU_ID,
  ORG_STRU_NAME,
  GROUP_ORDER,
  GROUP_NAME,
  GROUP_FULL_NAME
ORDER BY
  DATE_BEGIN,
  DATE_END,
  DATE_PLAN,
  FILIAL_ORDER,
  ORG_KIND_ORDER,
  ORG_STRU_ORDER,
  GROUP_ORDER;


