
select 
  TO_CHAR(date_kvit,'YYYYMM') as mon1,
  TO_CHAR(date_kvit,'mon YYYY') as mon,
  KLS_GDOR.GDOR_NAME,
  COUNT(*) as kol,
  SUM(ves_brutto) as ves
from kvit, MONTH, KLS_VAGOWNER, KLS_STAN, KLS_GDOR, KLS_VID_OTGR 
where date_kvit>=to_date('01.01.2003','dd.mm.yyyy')
  and date_kvit<=to_date('31.05.2004','dd.mm.yyyy')
  and kvit.vagowner_id=kls_vagowner.id
  and kvit.nom_zd=month.nom_zd
  and month.stan_id=kls_stan.id
  and kls_stan.GDOR_ID=kls_gdor.id
  and kls_vagowner.OWNER_ID=2 
  and month.is_exp=0   
  and month.LOAD_ABBR=kls_vid_otgr.LOAD_ABBR
  and kls_vid_otgr.LOAD_TYPE_ID=1
group by 
  TO_CHAR(date_kvit,'YYYYMM'),
  TO_CHAR(date_kvit,'mon YYYY'),
  KLS_GDOR.GDOR_NAME
  