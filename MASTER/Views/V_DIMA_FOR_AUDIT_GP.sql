--
-- V_DIMA_FOR_AUDIT_GP  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_DIMA_FOR_AUDIT_GP
(GOSPROG_NAME, DATE_OTGR, PREDPR_NAME, DOG_NUMBER, REGION_NAME, 
 STAN_NAME, POLUCH, LONG_NAME_NPR, VES, CENA_OTP)
AS 
select
  kls_gosprog.GOSPROG_NAME,
  kvit.DATE_OTGR,
  kls_predpr.PREDPR_NAME,
  kls_dog.DOG_NUMBER,
  kls_region.REGION_NAME,
  kls_stan.STAN_NAME,
  kls_predpr2.PREDPR_NAME AS poluch,
  kls_prod.LONG_NAME_NPR,
  sum(kvit.ves) as ves,
  kvit.CENA_OTP
  from kvit,month,kls_gosprog,kls_prod,kls_predpr,kls_dog,kls_predpr kls_predpr2,kls_stan,kls_region
  where 
    kvit.NOM_ZD=month.NOM_ZD and
	kls_dog.ID=month.DOG_ID and
	kls_predpr.ID=kls_dog.PREDPR_ID and
	month.POLUCH_ID=kls_predpr2.ID and
	kls_stan.ID=month.STAN_ID and
	kls_stan.REGION_ID=kls_region.ID and
	month.GOSPROG_ID=kls_gosprog.ID and
	month.PROD_ID_NPR=kls_prod.ID_NPR and
	month.GOSPROG_ID<>0
	and month.DATE_PLAN between
	  TO_DATE('01.01.2003','dd.mm.yyyy') and
	  TO_DATE('30.06.2004','dd.mm.yyyy')
GROUP BY
  kls_gosprog.GOSPROG_NAME,
  kvit.DATE_OTGR,
  kls_predpr.PREDPR_NAME,
  kls_dog.DOG_NUMBER,
  kls_region.REGION_NAME,
  kls_stan.STAN_NAME,
  kls_predpr2.PREDPR_NAME,
  kls_prod.LONG_NAME_NPR,
  kvit.CENA_OTP;


