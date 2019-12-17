
update zakaz set dog_id=3447,lukdog_id=3447 where date_plan=to_date('01.03.2009','dd.mm.yyyy') and is_agent=2 and is_accept=1
and plat_id=2641


update zakaz set lukdog_id=3447,dog_id=dog_id+50000 where date_plan=to_date('01.03.2009','dd.mm.yyyy') and is_agent=2 and is_accept=1
and plat_id<>10





select a.* from zakaz a where date_plan=to_date('01.03.2009','dd.mm.yyyy') and is_agent=1 and is_accept=1
and plat_id=10
and id=3010090178




select * from zakaz a, zakaz_hist where date_plan=to_date('01.03.2009','dd.mm.yyyy') and is_agent=2 and is_accept=1
and plat_id=10
and client_number='595'

select b.* from zakaz a,zakaz_hist b where a.id=b.zakaz_id and
exists 
(select
  aa.*
from zakaz_hist bb, zakaz aa where bb.id in (3020185038,3020186069) and aa.id=bb.zakaz_id
and bb.link_hist_id=b.id) 


-- Обновляем заказы
update zakaz zz 
set (link_id,link_hist_id)= 
(
select
snp.zakaz_id as link_id,
snp.zakaz_hist_id as link_hist_id
from 
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=2 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.lukdog_id=3447
order by b.zakaz_id,b.id) snp,
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=1 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.plat_id=10) unp,
zakaz link_snp
where 
unp.client_number=snp.client_number
and unp.link_id=link_snp.ID(+)
and (unp.link_id is null or link_snp.client_number='?')
and snp.link_id is null 
and UNP.zakaz_id=zz.id
--and unp.zakaz_id=3010090977
)
--
--select * from zakaz zz    
where exists
(
select null from zakaz zzz where zzz.date_plan=to_date('01.03.2009','dd.mm.yyyy') and zzz.is_agent=1 and zzz.is_accept=1
and zzz.id=zz.id 
)
and exists
(
select
null
from 
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=2 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.lukdog_id=3447
order by b.zakaz_id,b.id) snp,
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=1 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.plat_id=10) unp,
zakaz link_snp
where 
unp.client_number=snp.client_number
and UNP.zakaz_id=zz.id
and unp.link_id=link_snp.ID(+)
and (unp.link_id is null or link_snp.client_number='?')
and snp.link_id is null 
)


  




--Обновялем позиции 
update zakaz_hist zz 
set (link_id,link_hist_id)= 
(
select
snp.zakaz_id as link_id,
snp.zakaz_hist_id as link_hist_id
from 
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=2 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.lukdog_id=3447
order by b.zakaz_id,b.id) snp,
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=1 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.plat_id=10) unp,
zakaz link_snp
where 
unp.client_number=snp.client_number
and unp.link_id=link_snp.ID(+)
and (unp.link_id is null or link_snp.client_number='?')
and snp.link_id is null 
and UNP.zakaz_hist_id=zz.id
)
--
--select * from zakaz_hist zz    
where exists
(
select null from zakaz zzz where zzz.date_plan=to_date('01.03.2009','dd.mm.yyyy') and zzz.is_agent=1 and zzz.is_accept=1
and zzz.id=zz.zakaz_id 
)
and exists
(
select
null
from 
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=2 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.lukdog_id=3447
order by b.zakaz_id,b.id) snp,
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=1 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.plat_id=10) unp,
zakaz link_snp
where 
unp.client_number=snp.client_number
and UNP.zakaz_hist_id=zz.id
and unp.link_id=link_snp.ID(+)
and (unp.link_id is null or link_snp.client_number='?')
and snp.link_id is null 
)


-- восстанавливаем связи в заказах УНП
update zakaz_hist zz 
set (link_id,link_hist_id)= 
(
select
unp.link_id,
unp.link_hist_id
from  
(select a.id as zakaz_id,a.client_number,a.link_id,a.link_hist_id from zakaz a where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=1 and a.is_accept=1
and a.plat_id=10 
--and a.id=3010090178
) unp
where  UNP.zakaz_id=zz.zakaz_id
)
--
--select * from zakaz_hist zz    
where exists
(
select null from zakaz zzz where zzz.date_plan=to_date('01.03.2009','dd.mm.yyyy') and zzz.is_agent=1 and zzz.is_accept=1
and zzz.id=zz.zakaz_id
--and zzz.id=3010090178 
)
and exists
(
select
null
from  
(select a.id as zakaz_id,a.client_number,a.link_id,a.link_hist_id from zakaz a where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=1 and a.is_accept=1
and a.plat_id=10 
--and a.id=3010090178
) unp,
zakaz link_snp
where UNP.zakaz_id=zz.zakaz_id
and unp.link_id=link_snp.id
and link_snp.client_number<>'?'
)
and zz.link_id is null
and zz.status_zakaz_id=20 


 
-- восстанавливаем связи в заказах СНП
update zakaz_hist zz 
set (link_id,link_hist_id)= 
(
select
unp.zakaz_id as link_id,
unp.zakaz_hist_id as link_hist_id
from  
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id,b.link_hist_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=2 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.lukdog_id=3447) snp,
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id, b.link_hist_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=1 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.plat_id=10) unp
where 
unp.link_hist_id=snp.zakaz_hist_id
and SNP.zakaz_hist_id=zz.id
)
--
--select * from zakaz_hist zz    
where exists
(
select null from zakaz zzz where zzz.date_plan=to_date('01.03.2009','dd.mm.yyyy') and zzz.is_agent=2 and zzz.is_accept=1
and zzz.id=zz.zakaz_id
and zzz.client_number<>'?' 
)
and exists
(
select
null
from  
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id,b.link_hist_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=2 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.lukdog_id=3447) snp,
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id, b.link_hist_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=1 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.plat_id=10) unp
where 
unp.link_hist_id=snp.zakaz_hist_id
and SNP.zakaz_hist_id=zz.id
)
and zz.link_hist_id is null














--update zakaz_hist zz set link_id=null,link_hist_id=null,nom_zd=''
select * from zakaz_hist    zz 
where exists
(
select null from zakaz zzz where zzz.date_plan=to_date('01.03.2009','dd.mm.yyyy') and zzz.is_agent=2
and zzz.id=zz.zakaz_id 
and zzz.client_number='?'
)
and zz.status_zakaz_id=20
and exists
(select
null
from zakaz_hist a 
where a.id=zz.link_hist_id
and a.link_hist_id<>zz.id
)


update zakaz_hist zz 
set (link_id,link_hist_id)= 
(
select
unp.zakaz_id as link_id,
unp.zakaz_hist_id as link_hist_id
from  
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id,b.link_hist_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=2 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.lukdog_id=3447) snp,
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id, b.link_hist_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=1 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.plat_id=10) unp
where 
unp.link_hist_id=snp.zakaz_hist_id
and SNP.zakaz_hist_id=zz.id
)
--
--select * from zakaz_hist zz    
where exists
(
select null from zakaz zzz where zzz.date_plan=to_date('01.03.2009','dd.mm.yyyy') and zzz.is_agent=2 and zzz.is_accept=1
and zzz.id=zz.zakaz_id
and zzz.client_number<>'?' 
)
and exists
(
select
null
from  
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id,b.link_hist_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=2 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.lukdog_id=3447) snp,
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id, b.link_hist_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=1 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.plat_id=10) unp
where 
unp.link_hist_id=snp.zakaz_hist_id
and SNP.zakaz_hist_id=zz.id
)
and zz.link_id is null



update zakaz_hist zz 
set (link_id,link_hist_id)= 
(
select
unp.zakaz_id as link_id,
unp.zakaz_hist_id as link_hist_id
from  
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id,b.link_hist_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=2 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.lukdog_id=3447) snp,
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id, b.link_hist_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=1 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.plat_id=10) unp
where 
unp.link_hist_id=snp.zakaz_hist_id
and SNP.zakaz_hist_id=zz.id
)
--

select * from zakaz_hist zz    
where exists
(
select null from zakaz zzz where zzz.date_plan=to_date('01.03.2009','dd.mm.yyyy') and zzz.is_agent=2 and zzz.is_accept=1
and zzz.id=zz.zakaz_id
and zzz.client_number='655' 
)
and exists
(
select
null
from  
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id,b.link_hist_id from zakaz a,zakaz_hist b where a.date_plan=to_date('01.03.2009','dd.mm.yyyy') and a.is_agent=2 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.lukdog_id=3447) snp
,
zakaz_hist unp
where 
unp.link_id=snp.zakaz_id and 
SNP.zakaz_hist_id=zz.id
)

and zz.link_id is null



--update zakaz_hist zz set link_id=null,link_hist_id=null,nom_zd=''
select * from zakaz_hist    zz 
where exists
(
select null from zakaz zzz where zzz.date_plan=to_date('01.03.2009','dd.mm.yyyy') and zzz.is_agent=2
and zzz.id=zz.zakaz_id 
and zzz.client_number='?'
)
and zz.status_zakaz_id=20
and exists
(select
null
from zakaz_hist a 
where a.id=zz.link_hist_id
and a.link_hist_id<>zz.id
)

update zakaz_hist zz set link_id=null,link_hist_id=null
--select zz.rowid,zz.* from zakaz zz 
where exists
(
select null from zakaz zzz where zzz.date_plan=to_date('01.03.2009','dd.mm.yyyy') and zzz.is_agent=1
and zzz.id=zz.zakaz_id 
and zzz.client_number in ('488','491','505','503','533','507','515','516','519','529','530','531','532')
)
and zz.status_zakaz_id=20

update zakaz_hist zz set nom_zd=''
--select * from zakaz_hist    zz 
where exists
(
select null from zakaz zzz where zzz.date_plan=to_date('01.03.2009','dd.mm.yyyy') and zzz.is_agent=2
and zzz.id=zz.zakaz_id 
--and zzz.client_number='?'
)
and zz.status_zakaz_id=20
and zz.link_id is null
and zz.nom_zd like '3020%'


begin
  FOR_ZAKAZ.FILLFACTTHISMONTH;
end;  



--update zakaz_hist zz set link_id=null,link_hist_id=null,nom_zd=''
select zz.*,zzh.* from zakaz zz, zakaz_hist zzh 
where exists
(
select null from zakaz zzz where zzz.date_plan=to_date('01.03.2009','dd.mm.yyyy') and zzz.is_agent=2
and zzz.id=zz.id 
and zzz.client_number='?'
)
and zz.id=zzh.zakaz_id
and zzh.input_number like '6%'

(select
null
from zakaz_hist a 
where a.id=zz.link_hist_id
and a.link_hist_id<>zz.id
)


create or replace view v_zakaz_unp_for_sznp as 
select  
b.zakaz_id
,b.id as zakaz_hist_id
,'Заказ N '||a.client_number ||' от '||to_char(a.client_date,'dd.mm.yyyy')||' - '||to_char(b.load_ves)||' тн, '||KLS_STAN.STAN_NAME||', '||KLS_PROD.ABBR_NPR||', '||POLUCH.PREDPR_NAME as NAME
,KLS_STAN.STAN_NAME
,KLS_PROD.ABBR_NPR as PROD_NAME
,POLUCH.PREDPR_NAME as POLUCH_NAME
,B.LOAD_VES as ves
from zakaz a, zakaz_hist b, kls_prod, kls_stan, kls_predpr poluch 
where a.id=b.zakaz_id 
and a.date_plan=trunc(sysdate,'month') 
and a.is_agent=1 
and a.is_accept=1
and a.plat_id=10
and B.STATUS_ZAKAZ_ID=20
and a.prod_id_npr=KLS_PROD.ID_NPR (+)
and a.stan_id=kls_stan.id(+)
and a.poluch_id=poluch.id(+)
order by b.zakaz_id,b.sortby,b.id


create or replace view v_zakaz_sznp as 
select  
b.zakaz_id
,b.id as zakaz_hist_id
,'Заказ N '||a.client_number ||' от '||to_char(a.client_date,'dd.mm.yyyy')||' - '||to_char(b.load_ves)||' тн, '||KLS_STAN.STAN_NAME||', '||KLS_PROD.ABBR_NPR||', '||POLUCH.PREDPR_NAME as NAME
,KLS_STAN.STAN_NAME
,KLS_PROD.ABBR_NPR as PROD_NAME
,POLUCH.PREDPR_NAME as POLUCH_NAME
,b.load_ves as ves
from zakaz a, zakaz_hist b, kls_prod, kls_stan, kls_predpr poluch 
where a.id=b.zakaz_id 
and a.date_plan=trunc(sysdate,'month') 
and a.is_agent=2
and a.is_accept=1
and a.lukdog_id=3447
and B.STATUS_ZAKAZ_ID=20
and a.prod_id_npr=KLS_PROD.ID_NPR (+)
and a.stan_id=kls_stan.id(+)
and a.poluch_id=poluch.id(+)
order by b.zakaz_id,b.sortby,b.id




begin
  LINK_UNP_TO_SNP_ZAKAZ_2(to_date('01.06.2009','dd.mm.yyyy'),3020210278,'05/01-1001');
end;  


begin
  LINK_UNP_TO_SNP_AUTO(trunc(sysdate,'month'));
end;  

УСИНСК:
=

СЫКТЫВКАР:
=05/01-1001

УСТЬ-ВЫМЬ:
=05/01-1001
