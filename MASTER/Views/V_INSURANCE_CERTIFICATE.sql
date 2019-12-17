--
-- V_INSURANCE_CERTIFICATE  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_INSURANCE_CERTIFICATE
(NOM_CERT, DATE_VYP_SF, PREDPR_NAME, PREDPR_ADRESS, PREDPR_RS, 
 PREDPR_KS, PREDPR_BIK, BANK_NAME, BANK_ADRESS, LONG_NAME_NPR, 
 STAN_NAME, STRH_SUM, STRH, NUM_KVIT, DATE_KVIT, 
 NUM_CIST, VES)
AS 
SELECT
  bills.NOM_SF-6000000 AS nom_cert,
  bills.DATE_VYP_SF,
  kls_predpr.PREDPR_NAME,
  kls_predpr.POSTINDEX_J || ' ' || kls_predpr.CITY_J || ' ' || kls_predpr.ADDRESS_J AS Predpr_Adress,
  kls_predpr.RS AS Predpr_rs,
  kls_predpr.BANK_KORS AS Predpr_ks,
  kls_bank.BIK AS Predpr_bik,
  kls_bank.BANK_NAME,
  kls_bank.ADDRESS AS Bank_adress,
  kls_prod.LONG_NAME_NPR,
  kls_stan.stan_name,
  bills.PROD_SUM+bills.PROD_AKCIZ+bills.PROD_NDS+bills.PROD_GSM AS strh_sum,
  (SELECT SUM(bill_pos.SUMMA) from bill_pos WHERE bills.nom_dok=bill_pos.NOM_DOK AND bill_pos.BILL_POS_ID=20) AS strh,
  kvit.NUM_KVIT,
  kvit.DATE_KVIT,
  kvit.NUM_CIST,
  kvit.VES 
  FROM 
    bills,kls_dog,kls_predpr,kls_bank,month,kls_stan,kls_stan kls_stan2,kls_prod,kvit
  WHERE
    bills.DOG_ID=kls_dog.ID AND
	kls_dog.PREDPR_ID=kls_predpr.ID AND
	kls_predpr.BANK_KORS=kls_bank.KORS AND
	bills.PROD_ID_NPR=kls_prod.ID_NPR AND
	month.STAN_ID=kls_stan.id AND
	month.STANOTP_ID=kls_stan2.ID AND
	month.NOM_ZD=bills.NOM_ZD AND
	kvit.BILL_ID=bills.NOM_DOK AND
	bills.DATE_VYP_SF>=TO_DATE('01.01.2003','dd.mm.yyyy')
	and bills.nom_dok=6109399;


