--
-- V_FUCKING_AKCIZ_BY_SF  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FUCKING_AKCIZ_BY_SF
(PRODUCE_YEAR, PRODUCE_MONTH, DATE_VYR, AKCIZ_SVID, ITWASPRODICEDBYLUKOIL, 
 PREDPR_NAME, DOG_NUMBER, DOG_DATE, NOM_DOK, NOM_SF, 
 DATE_VYP_SF, NAKL_NUM, DATE_KVIT, GROUP_ID, GROUP_NAME, 
 LONG_NAME_NPR, VES_GAS80, SUM_GAS80, VES_GASNO80, SUM_GASNO80, 
 VES_DT, SUM_DT, VES_OIL, SUM_OIL, VES_GASPRYAM, 
 SUM_GASPRYAM)
AS 
SELECT  
  to_char(sf_poz_vyr.DATEVYR,'YYYY') AS produce_year,
  to_char(sf_poz_vyr.DATEVYR,'MM.YYYY') AS produce_month,
  sf_poz_vyr.DATEVYR AS DATE_VYR,
  Get_Akciz_Svid(kls_predpr.ID,kls_prod_groups.ID,bills.DATE_KVIT,bills.NO_AKCIZ) AS akciz_svid,
  '1' AS ItWasProdicedByLukoil,
  kls_predpr.PREDPR_NAME,
  kls_dog.DOG_NUMBER,
  kls_dog.DOG_DATE,
  bills.NOM_DOK,
  bills.NOM_SF,
  bills.DATE_VYP_SF,
  get_list_nakl_num(bills.NOM_DOK) AS nakl_num,
  bills.DATE_KVIT,
  kls_prod_groups.ID AS GROUP_ID,
  kls_prod_groups.GROUP_NAME,
  kls_prod.LONG_NAME_NPR,
  DECODE(kls_prod_groups.ID,114,sf_poz_vyr.KOL,0) AS ves_gas80,
  DECODE(kls_prod_groups.ID,114,sf_poz_vyr.SUMMA,0) AS sum_gas80,
  DECODE(kls_prod_groups.ID,115,sf_poz_vyr.KOL,0) AS ves_gasNo80,
  DECODE(kls_prod_groups.ID,115,sf_poz_vyr.SUMMA,0) AS sum_gasNo80,
  DECODE(kls_prod_groups.ID,116,sf_poz_vyr.KOL,0) AS ves_DT,
  DECODE(kls_prod_groups.ID,116,sf_poz_vyr.SUMMA,0) AS sum_DT,
  DECODE(kls_prod_groups.ID,117,sf_poz_vyr.KOL,0) AS ves_OIL,
  DECODE(kls_prod_groups.ID,117,sf_poz_vyr.SUMMA,0) AS sum_OIL,
  DECODE(kls_prod_groups.ID,118,sf_poz_vyr.KOL,0) AS ves_gasPryam,
  DECODE(kls_prod_groups.ID,118,sf_poz_vyr.SUMMA,0) AS sum_gasPryam
  FROM kls_predpr,kls_dog,bills,
    (SELECT 
	  TRUNC(kvit_date_vir.DATE_ViR,'Month') AS datevyr,
	  SUM(kvit_date_vir.VES) AS kol,
	  SUM(kvit_date_vir.SUM_PROD+kvit_date_vir.SUM_PROD_NDS+kvit_date_vir.SUM_AKCIZ) AS summa,
	  kvit_date_vir.bill_id AS KOD_PROD,
	  kvit.prod_id_npr AS ID_NFPROD 
	  FROM kvit_date_vir,kvit
	  WHERE  kvit_date_vir.kvit_id=kvit.id
	  GROUP BY TRUNC(kvit_date_vir.DATE_ViR,'Month'),kvit_date_vir.bill_id,kvit.prod_id_npr) sf_poz_vyr,
	kls_prod,kls_prod_groups_desc,kls_prod_groups
  WHERE
    kls_predpr.ID=kls_dog.PREDPR_ID and
	bills.NOM_DOK=sf_poz_vyr.KOD_PROD and
	kls_prod.ID_NPR=sf_poz_vyr.ID_NFPROD and
	bills.DOG_ID=kls_dog.ID and
	kls_prod_groups_desc.PROD_ID_NPR=kls_prod.ID_NPR and
	kls_prod_groups_desc.PROD_GROUPS_ID=kls_prod_groups.ID and
	kls_prod_groups.PROD_TYPE_GRP_ID=6 and
	bills.DATE_VYP_SF between
	  (SELECT MAX(begin_date) FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='AKCIZ_BY_SF.XLS') and
	  (SELECT MAX(end_date) FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='AKCIZ_BY_SF.XLS')
  ORDER BY produce_year,akciz_svid,ItWasProdicedByLukoil,PREDPR_NAME,dog_number,nom_sf;


