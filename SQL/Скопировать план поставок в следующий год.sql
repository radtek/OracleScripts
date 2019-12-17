delete from gu12_br where date_r>=to_date('01.12.2008','dd.mm.yyyy')

delete from gu12_b where id_a in
 (select id from gu12_a where from_date>=to_date('01.12.2008','dd.mm.yyyy'))

delete from gu12_a where from_date>=to_date('01.12.2008','dd.mm.yyyy')
 

insert into gu12_a
select 
  3000000+id as id,
  nom_z,
  add_months(from_date,12) as from_date,
  add_months(to_date,12) as to_date,
  add_months(sogl_date,12) as sogl_date,
  add_months(reg_date,12) as reg_date,
  dogovor,
  stanotpr_id,
  grotp_id,
  exped_id,
  gr_gruz_id,
  vidsoob_id,
  podach_id,
  sogl,
  plattar_id,
  prod_id,
  priznotpr_id,
  vladput_id,
  rodvag_id,
  id_nosogl,
  fox_kod,
  iscor,
  zakr_date
from gu12_a
where from_date>=to_date('01.12.2007','dd.mm.yyyy')

insert into gu12_b
select 
add_months(pdate,12) as pdate,
sobstvvag_id,
stan_id,
stan_per_id,
gruzpol_id,
kol_vag,
ves,
vidotpr_id,
mrk,
id_a+3000000 as id_a,
id+3000000 as id,
plat_id,
fox_kod,
iscor,
date_letter,
nom_letter,
date_vhod,
nom_vhod,
prinvag_id,
old_id,
states_id
from gu12_b
where id_a+3000000 in (select id from gu12_a)


insert into gu12_br
select 
id+3000000 as id,
id_b+3000000 as id_b,
add_months(date_r,12) as date_r,
kol_vag,
ves,
id_npr,
metka,
zakaz_hist_id
from gu12_br
where id_b+3000000 in (select id from gu12_b)




update XX101_ZVZAV_DATA set propagatestatus=null

update XX101_ZVZAV_DATA set actioncode=1, propagatestatus=null

update XX101_ZKERP_DATA set propagatestatus=null

delete from kvit where date_otgr>=to_date('01.01.2009','dd.mm.yyyy')

delete from month where date_plan>=to_date('01.11.2008','dd.mm.yyyy')

delete from zakaz_hist where zakaz_id in (select id from zakaz where date_plan>=to_date('01.11.2008','dd.mm.yyyy') and is_agent=1)

delete from zakaz where date_plan>=to_date('01.11.2008','dd.mm.yyyy') and is_agent=1

delete from zakaz_hist where zakaz_id in (select id from zakaz where id>300000000 and is_agent=2)

delete from zakaz where id>300000000 and is_agent=2 


-- скопировать заявки СНП
insert into zakaz 
select 
  (300000000+id) as id,
  is_agent,
  add_months(date_plan,12) as date_plan,
  client_number,
  add_months(client_date,12) as client_date,
  input_number,
  add_months(input_date,12) as input_date,
  add_months(begin_date,12) as begin_date,
  is_accept,
  filial_id,
  plat_id,
  dog_id,
  prod_id_npr,
  usl_opl_id,
  load_abbr,
  stan_id,
  vetka_id,
  poluch_id,
  potreb_id,
  potreb_name,
  neftebasa,
  payform_id,
  planstru_id,
  price_client,
  price,
  ves,
  kol,
  speed_ves,
  speed_kol,
  '' as nom_zd_list,
  fact_ves,
  fact_kol,
  prim,
  gr4,
  load_ves,
  load_kol,
  zakaz_prev_id,
  gosprog_id,
  gp_napr_id,
  lukdog_id,
  is_auto,
  link_id,
  link_hist_id,
  period_id,
  tip_corp_id
from zakaz
where date_plan>=to_date('01.01.2008','dd.mm.yyyy') and is_agent=2
and id+300000000 not in (select id from zakaz)
--and /*plat_id<>2641 and*/ is_accept=1


insert into zakaz_hist
select
id+300000000 as id,
zakaz_id+300000000 as zakaz_id,
sortby,
status_zakaz_id,
client_number,
add_months(client_date,12) as client_date,
input_number,
add_months(input_date,12) as input_date,
prod_id_npr,
old_stan_id,
stan_id,
poluch_id,
price,
ves,
kol,
speed_ves,
speed_kol,
'' as nom_zd,
fact_ves,
fact_kol,
gu12_a_id,
is_auto,
add_months(begin_date,12) as begin_date,
grafik,
potreb_id,
load_ves,
load_kol,
null as link_id,
null as link_hist_id,
is_auto_month,
'' as kod_isu
from zakaz_hist
where zakaz_id+300000000 in (select id from zakaz)
and id+300000000 not in (select id from zakaz_hist)
--and is_auto_month=0 /*and is_auto=0*/




select distinct prod_id_npr,shabexp_id from kvit where date_otgr>=to_date('01.03.2008','dd.mm.yyyy')


select * from kls_prod where id_npr='23756'



select to_number(a.WAYBILLID),to_number(a.WAYBILLROWID),a.* from xx101_zpostav a 
where 
exists (select null from xx101_zkerp_data b
where to_number(b.WAYBILLID)=to_number(a.WAYBILLID)
and to_number(b.WAYBILLROWID)=to_number(a.WAYBILLROWID)
and b.ACTIONCODE=1
)


select to_number(b.WAYBILLID),to_number(b.WAYBILLROWID),b.shipmentdate,b.*  
from xx101_zkerp_data b
where b.ACTIONCODE=1



select to_number(a.ordernum),a.* from xx101_zraznar a 
where 
exists (select null from xx101_zvzav_data b
where to_number(b.ordernum)=to_number(a.ordernum)
and b.ACTIONCODE=1
)

select * from month
-- select a.*, a.rowid from xx101_zvzav_data a 
--update xx101_zvzav_data set propagatestatus=null
--where ordernum in
where MONTH.date_plan>=to_date('01.04.2008','dd.mm.yyyy')
and nom_zd in 
(
select nom_zd from month a 
where 
not exists (
SELECT
  MONTH.*,
  KLS_PROD.NAME_NPR,
  NVL(kv.ves,0) AS FACT_VES,
  MONTH.CENA_OTP*NVL(kv.ves,0) AS FACT_SUM
FROM V_MONTH MONTH, KLS_PROD,
  (SELECT
     NOM_ZD,
     SUM(VES_BRUTTO) AS VES
   FROM KVIT
   WHERE date_otgr>=to_date('01.04.2008','dd.mm.yyyy')
   GROUP BY NOM_ZD) kv
WHERE MONTH.NOM_ZD=kv.NOM_ZD (+)
  AND MONTH.PROD_ID_NPR=KLS_PROD.ID_NPR
  AND MONTH.date_plan>=to_date('01.04.2008','dd.mm.yyyy')
  AND MONTH.date_plan<=to_date('31.12.2008','dd.mm.yyyy')
  AND month.nom_zd=a.nom_zd
)
)

select ordernum from xx101_zraznar
group by ordernum
having count(*)>1


select a.waybillid||a.waybillrowid,a.* from xx101_zpostav a
where 
not exists (select null from kvit b
where b.id=to_number(a.waybillid||a.waybillrowid)
)




select * from plan_periods
where plan_id in (1,2) and 
(
date_plan=to_date('01.03.2008','dd.mm.yyyy') or
date_plan=to_date('01.03.2009','dd.mm.yyyy')
) 


select * from plan_post where plan_per_id in (609,612)


insert into plan_post
select 
0,
plan_cena,
plan_ves,
plan_sum,
plan_id,
612,
planstru_id,
dog_id,
prod_id_npr,
payform_id,
date_cena,
cat_cen_id,
appl_tag,
refinery_id,
orgstru_id
from plan_post
where plan_per_id=556

insert into plan_post
select 
0,
plan_cena,
plan_ves,
plan_sum,
plan_id,
609,
planstru_id,
dog_id,
prod_id_npr,
payform_id,
date_cena,
cat_cen_id,
appl_tag,
refinery_id,
orgstru_id
from plan_post
where plan_per_id=543




select a.*, a.rowid from XX101_ZVZAV_DATA a where exists (
select * from month where poluch_id is null and nom_zd=ordernum
)
order by filename desc


delete from XX101_ZVZAV_DATA where enddate<to_date('01.04.2008','dd.mm.yyyy')

delete from XX101_ZKERP_DATA where SHIPMENTDATE<to_date('01.04.2008','dd.mm.yyyy')



select * from gu12_a where id in (
select id_a  from gu12_b where kol_vag=0 and id_a in
 (select id from gu12_a where from_date>=to_date('01.03.2008','dd.mm.yyyy'))
)