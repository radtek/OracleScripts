select
  bills.NOM_SF,
  kvit.NUM_KVIT,
  kvit.date_kvit,
  kvit.NUM_CIST,
  kvit.KALIBR_ID,
  kvit.ves_brutto,
  kvit.tarif,
  kls_prod.name_npr,
  kls_stan.STAN_KOD,
  kls_stan.STAN_NAME,
  kls_stan.RAST
from kvit,BILLS,kls_vagowner,month,kls_prod,kls_stan
where kvit.BILL_ID=BILLS.NOM_DOK
  and KVIT.date_otgr>=TO_DATE('01.11.2003','dd.mm.yyyy')
  and KVIT.date_otgr<=TO_DATE('31.12.2003','dd.mm.yyyy')
  and kvit.VAGOWNER_ID=kls_vagowner.id
  and kls_vagowner.OWNER_ID=2
  and kvit.nom_zd=month.nom_zd
  and month.dog_id=787
  and month.IS_EXP=0
  and kvit.prod_id_npr=kls_prod.id_npr
  and month.stan_id=kls_stan.id 
order by   
  kvit.date_kvit,
  kvit.num_kvit,
  kvit.id
    