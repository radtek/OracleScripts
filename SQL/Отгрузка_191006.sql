select 
npz,
plat_name,
addr,
prinadl,
stan_name,
SUM(case when yy=2005 and prod_name='À-76 (80)' then ves else 0 end) as A76_2005,
SUM(case when yy=2005 and prod_name='ÀÈ-92' then ves else 0 end) as AI92_2005,
SUM(case when yy=2005 and prod_name='ÀÈ-95' then ves else 0 end) as AI95_2005,
SUM(case when yy=2005 and prod_name='ÀÈ-98' then ves else 0 end) as AI98_2005,
SUM(case when yy=2005 and prod_name='ÄÒ' then ves else 0 end) as DT_2005,
SUM(case when yy=2005 and prod_name='Àâèàêåðîñèí' then ves else 0 end) as Avia_2005,
SUM(case when yy=2005 and prod_name='Ìàçóò' then ves else 0 end) as MAZUT_2005,
SUM(case when yy=2005 and prod_name='?' then ves else 0 end) as PR_2005,
SUM(case when yy=2006 and prod_name='À-76 (80)' then ves else 0 end) as A76_2006,
SUM(case when yy=2006 and prod_name='ÀÈ-92' then ves else 0 end) as AI92_2006,
SUM(case when yy=2006 and prod_name='ÀÈ-95' then ves else 0 end) as AI95_2006,
SUM(case when yy=2006 and prod_name='ÀÈ-98' then ves else 0 end) as AI98_2006,
SUM(case when yy=2006 and prod_name='ÄÒ' then ves else 0 end) as DT_2006,
SUM(case when yy=2006 and prod_name='Àâèàêåðîñèí' then ves else 0 end) as Avia_2006,
SUM(case when yy=2006 and prod_name='Ìàçóò' then ves else 0 end) as MAZUT_2006,
SUM(case when yy=2006 and prod_name='?' then ves else 0 end) as PR_2006,
transp
from
(
select /*+ rule */
  'ËÓÊÎÉË-ÓÍÏ' as NPZ,
  kls_predpr.sf_name as plat_name,
  NVL(kls_predpr.FULL_ADDRESS_J,GET_ADDR(kls_predpr.REGION_ID,kls_predpr.POSTINDEX_J,kls_predpr.CITY_J,kls_predpr.ADDRESS_J)) as addr,
  ' ' as prinadl,
  kls_stan.stan_name,
  (CASE 
     WHEN kls_prod.id_npr>='10301' and kls_prod.id_npr<'10310' THEN 'À-76 (80)'
     WHEN kls_prod.id_npr>='10310' and kls_prod.id_npr<'10350' THEN 'ÀÈ-92'
     WHEN kls_prod.id_npr>='10350' and kls_prod.id_npr<'10370' THEN 'ÀÈ-95'
     WHEN kls_prod.id_npr>='10390' and kls_prod.id_npr<'10400' THEN 'ÀÈ-98'
     WHEN kls_prod.id_npr>='10400' and kls_prod.id_npr<'10500' THEN 'ÄÒ'
     WHEN kls_prod.id_npr>='10500' and kls_prod.id_npr<'10600' THEN 'Àâèàêåðîñèí'
     WHEN kls_prod.id_npr>='11500' and kls_prod.id_npr<'11600' THEN 'Ìàçóò'
     ELSE '?'
   END) as prod_name,
  to_char(date_kvit,'YYYY') as yy,
  kls_load_type.TYPE_OTGR_NAME as transp,
  ROUND(SUM(kvit.ves_brutto)/1000,0) as ves
from
kvit,month,kls_dog,kls_predpr,kls_stan,kls_prod,kls_vid_otgr,kls_load_type
where kvit.date_kvit>to_date('01.01.2005','dd.mm.yyyy')
and kvit.date_kvit<to_date('01.10.2006','dd.mm.yyyy')
and kvit.nom_zd=month.nom_zd
and month.dog_id=kls_dog.ID
and kls_dog.predpr_id=kls_predpr.ID
and month.stan_id=kls_stan.id
and kvit.prod_id_npr=kls_prod.id_npr
and month.load_abbr=kls_vid_otgr.load_abbr
and kls_vid_otgr.load_type_id=kls_load_type.id
group by
  kls_predpr.sf_name,
  NVL(kls_predpr.FULL_ADDRESS_J,GET_ADDR(kls_predpr.REGION_ID,kls_predpr.POSTINDEX_J,kls_predpr.CITY_J,kls_predpr.ADDRESS_J)),
  kls_stan.stan_name,
  (CASE 
     WHEN kls_prod.id_npr>='10301' and kls_prod.id_npr<'10310' THEN 'À-76 (80)'
     WHEN kls_prod.id_npr>='10310' and kls_prod.id_npr<'10350' THEN 'ÀÈ-92'
     WHEN kls_prod.id_npr>='10350' and kls_prod.id_npr<'10370' THEN 'ÀÈ-95'
     WHEN kls_prod.id_npr>='10390' and kls_prod.id_npr<'10400' THEN 'ÀÈ-98'
     WHEN kls_prod.id_npr>='10400' and kls_prod.id_npr<'10500' THEN 'ÄÒ'
     WHEN kls_prod.id_npr>='10500' and kls_prod.id_npr<'10600' THEN 'Àâèàêåðîñèí'
     WHEN kls_prod.id_npr>='11500' and kls_prod.id_npr<'11600' THEN 'Ìàçóò'
     ELSE '?'
   END),
  to_char(date_kvit,'YYYY'),
  kls_load_type.TYPE_OTGR_NAME
--having ROUND(SUM(kvit.ves_brutto)/1000,0)>10
)
--where prod_name<>'?'  
group by
npz,
plat_name,
addr,
prinadl,
stan_name,
transp

     
      
 