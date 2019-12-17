--
-- V_SBYTREPORT_AN  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_SBYTREPORT_AN
(PREDPR_NAME, DOG_NUMBER, LONG_NAME_NPR, NOM_ZD, DATE_PLAN, 
 INPUT_DATE, TONN_DECLARED, DATE_OTGR, VES)
AS 
SELECT 
  kls_predpr.predpr_name, 
  kls_dog.dog_number,
  gr_prod.LONG_NAME_NPR,
  month.nom_zd,
  month.DATE_PLAN,
  month.INPUT_DATE,
  month.TONN_DECLARED,
  kvit.DATE_OTGR,
  sum(kvit.VES)
  FROM MONTH, kls_dog, kls_predpr, kls_prod, kvit, kls_prod gr_prod
WHERE 
 MONTH.dog_id = kls_dog.id AND 
 kls_predpr.id = kls_dog.predpr_id and
 month.PROD_ID_NPR=kls_prod.ID_NPR and
 month.nom_zd=kvit.nom_zd and
 month.LOAD_ABBR='ÑÀÌ' and 
 month.date_plan>=SYSDATE-100 and
 kvit.MESTO_ID=2 AND
 kls_prod.ID_GROUP_NPR=gr_prod.id_npr
GROUP BY
  kls_predpr.predpr_name, 
  kls_dog.dog_number,
  gr_prod.LONG_NAME_NPR,
  month.nom_zd,
  month.DATE_PLAN,
  month.INPUT_DATE,
  month.TONN_DECLARED,
  kvit.DATE_OTGR;


