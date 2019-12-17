select
  KLS_DOG.DOG_NUMBER,
  plat.PREDPR_NAME,
  POLUCH.PREDPR_NAME,
  KLS_STAN.STAN_NAME, 
  DATE_OTGR,
  KLS_PROD.NAME_NPR,
  NUM_CIST,
  VES_BRUTTO,
  CAPACITY,
  VZLIV,
  TEMPER,
  FAKT_PL,
  VES_CIST,
  NUM_KVIT,
  KALIBR_ID
from 
  kvit, month, kls_prod, kls_predpr poluch, kls_stan, kls_dog, kls_predpr plat
where kvit.prod_id_npr=kls_prod.id_npr
  and kvit.nom_zd=month.nom_zd
  and month.poluch_id=poluch.id
  and month.stan_id=kls_stan.id
  and month.dog_id=kls_dog.id
  and kls_dog.PREDPR_ID=plat.id
  and poluch.id in (2646,2725,2703)
  and kls_stan.id in (2290)
  and kvit.date_otgr>=to_date('01.03.2004','dd.mm.yyyy')
order by
  date_otgr,
  kvit.id  
