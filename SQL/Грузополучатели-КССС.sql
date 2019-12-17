SELECT /*+ RULE */ distinct
  poluch.*,
  kls_region.REGION_NAME,
  reg_pol.REGION_NAME
FROM
  kvit, month, kls_dog, kls_predpr plat, kls_predpr poluch, kls_vid_otgr, kls_load_type, kls_predpr sobstv, kls_dog_main, kls_dog main_dog,
  kls_prod,kls_vagowner,kls_predpr exped,
  kls_shabexp,kls_pasp,kls_stan,kls_region,kls_states,kls_region reg_pol,ksss_material material	  
WHERE
  kvit.nom_zd = month.nom_zd AND
  month.dog_id = kls_dog.ID and
  kls_dog.predpr_id=plat.ID AND
  month.poluch_id=poluch.ID AND 
  month.LOAD_ABBR=kls_vid_otgr.LOAD_ABBR AND
  KLS_VID_OTGR.LOAD_TYPE_ID=KLS_LOAD_TYPE.ID AND 
  month.npr_sobstv_id = sobstv.ID AND
  kvit.prod_id_npr=kls_prod.id_npr AND kls_prod.ksss_prod_id=material.material_id(+) and
  kvit.VAGOWNER_ID=kls_vagowner.id(+) and
  month.exped_ID = exped.id(+) and
  kvit.SHABEXP_ID=kls_shabexp.ID(+) and
  kvit.pasp_id=kls_pasp.id(+) and
  month.stan_id=kls_stan.id and
  kls_stan.REGION_ID=kls_region.id(+) and
  kls_stan.STATES_ID=kls_states.id(+) and
  poluch.REGION_ID=reg_pol.id(+) and
  kls_dog_main.is_agent=kls_dog.is_agent and
  month.date_plan between kls_dog_main.from_date and kls_dog_main.to_date and
  kls_dog_main.dog_id=main_dog.id and
  kvit.date_otgr>=:BEGIN_DATE and
  kvit.date_otgr<=:END_DATE and
  nvl(poluch.KSSS_PREDPR_ID,0)=0
