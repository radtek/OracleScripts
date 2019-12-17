--
-- V_PASP  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PASP
(ID, PASP_NUM, REZ_NUM, PASP_DATE, INSPEKTOR, 
 PROD_ID_NPR, DATE_VIR, PERER_ID, MESTO_ID, PRIM, 
 IS_PASP_UNP)
AS 
SELECT /*+ RULE */
  ID,
  PASP_NUM,
  REZ_NUM,
  PASP_DATE,
  INSPEKTOR,
  PROD_ID_NPR,
  DATE_VIR,
  NVL(PERER_ID,8) as PERER_ID,
  MESTO_ID,
  '' as PRIM,
  0 as IS_PASP_UNP
FROM KLS_PASP
--where pasp_date>=to_date('01.01.2006','dd.mm.yyyy') and pasp_num='33'
UNION ALL
SELECT
  TO_CHAR(a.ID_PASPORT) as ID,
  a.NOMER_PASPORT as PASP_NUM,
  TO_CHAR(a.NOMER_RESERVUAR) as REZ_NUM,
  a.DATE_PASPORT as PASP_DATE,
  a.INSPEKTOR,
  i.PROD_ID_NPR,
  a.DATE_IZGOTOVL as DATE_VIR,
  8 as PERER_ID,
  1 as MESTO_ID,
  (CASE
     WHEN a.NOMER_CISTERN IS NULL THEN ''
	 ELSE 'Цистерн: '||a.NOMER_CISTERN
   END) as PRIM,
  1 as IS_PASP_UNP
from unp_pasport a, kls_prod_pasp_unp i
where a.kod_oil_product=i.kod_oil_product
--  and date_pasport>=to_date('01.01.2006','dd.mm.yyyy') and nomer_pasport='33'
;


