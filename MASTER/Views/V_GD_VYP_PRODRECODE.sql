--
-- V_GD_VYP_PRODRECODE  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GD_VYP_PRODRECODE
(PROD_GU12_ID, ID_NPR)
AS 
SELECT /*+ RULE */
  kls_prod.PROD_GU12_ID,
  MIN(kls_prod.ID_NPR) AS id_npr
  FROM kls_prod,kvit,V_TEMP_VYP_GD_PARAMS,kls_prod_plan
  WHERE kvit.PROD_ID_NPR=kls_prod.ID_NPR and
        kls_prod.PROD_PLAN_ID=kls_prod_plan.id and
       kvit.DATE_KVIT between
       V_TEMP_VYP_GD_PARAMS.BEGIN_DATE and
       V_TEMP_VYP_GD_PARAMS.END_DATE
  GROUP BY kls_prod.PROD_GU12_ID
UNION ALL
SELECT 
  kls_prod.PROD_GU12_ID,
  MIN(kls_prod.ID_NPR) AS id_npr 
  FROM kls_prod,kls_prod_plan WHERE
    kls_prod.PROD_PLAN_ID=kls_prod_plan.id and
    kls_prod.PROD_GU12_ID not in 
 (SELECT
  kls_prod.PROD_GU12_ID
  FROM kls_prod,kvit,V_TEMP_VYP_GD_PARAMS,kls_prod_plan
  WHERE kvit.PROD_ID_NPR=kls_prod.ID_NPR and
        kls_prod.PROD_PLAN_ID=kls_prod_plan.id and
       kvit.DATE_KVIT between
       V_TEMP_VYP_GD_PARAMS.BEGIN_DATE and
       V_TEMP_VYP_GD_PARAMS.END_DATE
     GROUP BY kls_prod.PROD_GU12_ID
  )
  GROUP BY kls_prod.PROD_GU12_ID;


