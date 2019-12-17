--
-- V_REE_FACTPROD  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_REE_FACTPROD
(PROD_PLAN_ID, VES_BRUTTO)
AS 
SELECT
  kls_prod.PROD_PLAN_ID,
  SUM(kvit.ves_brutto) AS ves_brutto 
	FROM kvit,month,kls_prod,V_TEMP_REESTR_PARAMS
	WHERE 
	  month.date_plan=V_TEMP_REESTR_PARAMS.DATE_PLAN and
	  kvit.DATE_OFORML<=V_TEMP_REESTR_PARAMS.DATETIME_REPORT and
	  kvit.PROD_ID_NPR=kls_prod.ID_NPR and
	  kvit.NOM_ZD=month.NOM_ZD
  GROUP BY kls_prod.PROD_PLAN_ID;


