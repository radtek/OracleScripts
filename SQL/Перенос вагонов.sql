select 
  month.nom_zd,sved_num,date_otgr,num_cist,date_oforml
from kvit,month,kls_vid_otgr
where kvit.nom_zd=month.nom_zd and month.load_abbr=kls_vid_otgr.load_abbr and
  kvit.date_otgr=to_date('28.02.2005','dd.mm.yyyy') and
  date_oforml>=to_date('28.02.2005 17:00','dd.mm.yyyy hh24:mi') and
  kls_vid_otgr.load_type_id in (1,6) 
    