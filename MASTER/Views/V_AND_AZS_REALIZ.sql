--
-- V_AND_AZS_REALIZ  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_AND_AZS_REALIZ
(PROD_ID_NPR, PROD_NAME, KSSS_PROD_ID, ORG_STRU_ID, ORG_NAME, 
 KSSS_ORG_ID, DATE_OPER, FACT_SUM, FACT)
AS 
SELECT pr.prod_id_npr, pr.NAME AS prod_name, prod.ksss_prod_id,
       org.org_stru_id, org.NAME AS org_name, os.ksss_id AS ksss_org_id,
       fr.date_oper, fr.fact_sum, fr.fact
  FROM load_fil_realiz fr,
       load_fil_prod pr,
       load_fil_org org,
       kls_prod prod,
       org_structure os
 WHERE pr.ID = fr.fil_prod_id
   AND org.ID = fr.fil_org_id
   AND org.org_stru_id = os.ID
   AND pr.prod_id_npr = prod.id_npr
   AND fr.date_oper > '01-dec-2005'
   AND fr.type_oper_id = 1
   AND org.org_kind_id = 5;


