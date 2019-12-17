select
  num_cist,
  date_otgr,
  kls_prod.sf_name,
  kvit.kalibr_id,
  kvit.vzliv as vzliv_sm,
  KLS_VAGON_VZLIV.VOLUME,
  PL,
  FAKT_PL,
  TEMPER,
  ves_brutto*1000 as ves
from kvit,month,kls_vid_otgr,kls_prod,kls_vagon_vzliv,kls_dog
where
  kvit.nom_zd=month.nom_zd and
  month.load_abbr=kls_vid_otgr.load_abbr and
  kvit.prod_id_npr=kls_prod.id_npr and
  month.dog_id=kls_dog.id and
  kvit.kalibr_id=kls_vagon_vzliv.kalibr_id(+) and
  kvit.vzliv=kls_vagon_vzliv.VZLIV(+) and
  kls_vid_otgr.LOAD_TYPE_ID=1 and
  kls_dog.predpr_id=2641 and
  kvit.date_otgr>=to_date('01.01.2005','dd.mm.yyyy')
order by date_otgr,num_cist  
  