select 
--t.name as type_owner,
decode(a.auto,1,'Àâòîìîáèëü','Ïðèöåï') as car_type,
a.model_id,b.name as model_name,
a.id as car_id,
a.name as car_number,
c.secno,
c.volume
from car_owner a, car_model b, car_volume c, type_owner t 
where 
a.model_id=b.id and a.id=c.car_id and a.tp_owner_id=t.id(+) and
a.name not in ('**','***','-','-*','--','1','ÒÐÓÁÀ','ÒÐÊ') and
b.name not in ('ÖÈÑÒÅÐÍÀ') and
a.name in (select name from car_owner group by name having count(*)=1) 
and a.name in (select cc.name from OUT_WBILL_MO_OS dd,car_owner cc where dd.car_dull_id=cc.id and dd.doc_date>=to_date('01.01.2010','dd.mm.yyyy'))
order by a.name,a.id,c.secno 
--order by a.id



select * from car_volume