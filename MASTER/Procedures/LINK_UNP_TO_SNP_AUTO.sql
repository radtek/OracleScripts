--
-- LINK_UNP_TO_SNP_AUTO  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.link_unp_to_snp_auto (pDatePlan DATE) as
  vIDSNP NUMBER;
  vIDSNPHist NUMBER;
  vIDUNP NUMBER;
  vIDUNPHist NUMBER;
  vIdOldSNPHist NUMBER;
begin

if pDatePlan<to_date('01.03.2009','dd.mm.yyyy') then
  return;
end if;  

-- Обновляем заказы
update zakaz zz 
set (link_id,link_hist_id)= 
(
select
snp.zakaz_id as link_id,
snp.zakaz_hist_id as link_hist_id
from 
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id from zakaz a,zakaz_hist b where a.date_plan=pDatePlan and a.is_agent=2 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.lukdog_id=3447
order by b.zakaz_id,b.id) snp,
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id from zakaz a,zakaz_hist b where a.date_plan=pDatePlan and a.is_agent=1 and a.is_accept=1
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
select null from zakaz zzz where zzz.date_plan=pDatePlan and zzz.is_agent=1 and zzz.is_accept=1
and zzz.id=zz.id 
)
and exists
(
select
null
from 
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id from zakaz a,zakaz_hist b where a.date_plan=pDatePlan and a.is_agent=2 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.lukdog_id=3447
order by b.zakaz_id,b.id) snp,
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id from zakaz a,zakaz_hist b where a.date_plan=pDatePlan and a.is_agent=1 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.plat_id=10) unp,
zakaz link_snp
where 
unp.client_number=snp.client_number
and UNP.zakaz_id=zz.id
and unp.link_id=link_snp.ID(+)
and (unp.link_id is null or link_snp.client_number='?')
and snp.link_id is null 
);


  




--Обновялем позиции 
update zakaz_hist zz 
set (link_id,link_hist_id)= 
(
select
snp.zakaz_id as link_id,
snp.zakaz_hist_id as link_hist_id
from 
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id from zakaz a,zakaz_hist b where a.date_plan=pDatePlan and a.is_agent=2 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.lukdog_id=3447
order by b.zakaz_id,b.id) snp,
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id from zakaz a,zakaz_hist b where a.date_plan=pDatePlan and a.is_agent=1 and a.is_accept=1
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
select null from zakaz zzz where zzz.date_plan=pDatePlan and zzz.is_agent=1 and zzz.is_accept=1
and zzz.id=zz.zakaz_id 
)
and exists
(
select
null
from 
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id from zakaz a,zakaz_hist b where a.date_plan=pDatePlan and a.is_agent=2 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.lukdog_id=3447
order by b.zakaz_id,b.id) snp,
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id from zakaz a,zakaz_hist b where a.date_plan=pDatePlan and a.is_agent=1 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.plat_id=10) unp,
zakaz link_snp
where 
unp.client_number=snp.client_number
and UNP.zakaz_hist_id=zz.id
and unp.link_id=link_snp.ID(+)
and (unp.link_id is null or link_snp.client_number='?')
and snp.link_id is null 
);


-- восстанавливаем связи в заказах УНП
update zakaz_hist zz 
set (link_id,link_hist_id)= 
(
select
unp.link_id,
unp.link_hist_id
from  
(select a.id as zakaz_id,a.client_number,a.link_id,a.link_hist_id from zakaz a where a.date_plan=pDatePlan and a.is_agent=1 and a.is_accept=1
and a.plat_id=10 
--and a.id=3010090178
) unp
where  UNP.zakaz_id=zz.zakaz_id
)
--
--select * from zakaz_hist zz    
where exists
(
select null from zakaz zzz where zzz.date_plan=pDatePlan and zzz.is_agent=1 and zzz.is_accept=1
and zzz.id=zz.zakaz_id
--and zzz.id=3010090178 
)
and exists
(
select
null
from  
(select a.id as zakaz_id,a.client_number,a.link_id,a.link_hist_id from zakaz a where a.date_plan=pDatePlan and a.is_agent=1 and a.is_accept=1
and a.plat_id=10 
--and a.id=3010090178
) unp,
zakaz link_snp
where UNP.zakaz_id=zz.zakaz_id
and unp.link_id=link_snp.id
and link_snp.client_number<>'?'
)
and zz.link_id is null
and zz.status_zakaz_id=20; 


 
-- восстанавливаем связи в заказах СНП
update zakaz_hist zz 
set (link_id,link_hist_id)= 
(
select
unp.zakaz_id as link_id,
unp.zakaz_hist_id as link_hist_id
from  
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id,b.link_hist_id from zakaz a,zakaz_hist b where a.date_plan=pDatePlan and a.is_agent=2 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.lukdog_id=3447) snp,
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id, b.link_hist_id from zakaz a,zakaz_hist b where a.date_plan=pDatePlan and a.is_agent=1 and a.is_accept=1
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
select null from zakaz zzz where zzz.date_plan=pDatePlan and zzz.is_agent=2 and zzz.is_accept=1
and zzz.id=zz.zakaz_id
and zzz.client_number<>'?' 
)
and exists
(
select
null
from  
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id,b.link_hist_id from zakaz a,zakaz_hist b where a.date_plan=pDatePlan and a.is_agent=2 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.lukdog_id=3447) snp,
(select b.zakaz_id,b.id as zakaz_hist_id,a.client_number,b.link_id, b.link_hist_id from zakaz a,zakaz_hist b where a.date_plan=pDatePlan and a.is_agent=1 and a.is_accept=1
and a.id=b.zakaz_id and b.status_zakaz_id=20
and a.plat_id=10) unp
where 
unp.link_hist_id=snp.zakaz_hist_id
and SNP.zakaz_hist_id=zz.id
)
and zz.link_hist_id is null;



FOR_ZAKAZ.FILLFACTTHISMONTH;
COMMIT;

end; 
/

