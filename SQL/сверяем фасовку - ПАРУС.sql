select 
 a.sdep_ready,
 -- a.nam, 
 -- a.dat,
--  a.vid, 
--  a.kol, 
--  a.azs,
  sum(a.sum_s) sum1,
  sum(a.sum_f) sum2, 
  sum(a.sum_u) sum3
  --,a.nam1
--sum(a.sum_s+a.sum_f+a.sum_u) sum4 
from
(
--
--
select
nam,sdep_ready,dat,nomen_name,
sum(sum_s) sum_s,sum(sum_f) sum_f, sum(sum_u) sum_u
from
(
select      
  t2.snumb as nam,  
  t2.SDEP_READY,
       t1.date_smena dat,
	   d.nomen_name,
	--   ps.*,
       decode(trim(d.group_code),'СОПУТТОВ',decode(ps.factret_sign,0,t.nsumm/1000,t.nsumm/1000*-1), 
       decode(trim(d.group_code),'МАТЕРИАЛ',decode(ps.factret_sign,0,t.nsumm/1000,t.nsumm/1000*-1),
       decode(trim(d.group_code),'СПЕЦОДЕЖДА',decode(ps.factret_sign,0,t.nsumm/1000,t.nsumm/1000*-1),
       decode(trim(d.group_code),'АВТОЗАПЧАСТИ',decode(ps.factret_sign,0,t.nsumm/1000,t.nsumm/1000*-1),0)))) sum_s,
       decode(trim(d.group_code),'СОПУТТОВ',0, 
       decode(trim(d.group_code),'МАТЕРИАЛ',0,
       decode(trim(d.group_code),'СПЕЦОДЕЖДА',0,
       decode(trim(d.group_code),'АВТОЗАПЧАСТИ',0,
       decode(trim(d.group_code),'УСЛУГА',0, decode(ps.factret_sign,0,t.nsumm/1000,t.nsumm/1000*-1)))))) sum_f,
       decode(trim(d.group_code),'СОПУТТОВ',0, 
       decode(trim(d.group_code),'МАТЕРИАЛ',0,
       decode(trim(d.group_code),'СПЕЦОДЕЖДА',0,
       decode(trim(d.group_code),'АВТОЗАПЧАСТИ',0,decode(trim(d.group_code),'УСЛУГА',decode(ps.factret_sign,0,t.nsumm/1000,t.nsumm/1000*-1),0))))) sum_u
from parus.v_azsrepout     t, 
           dicbunts       pb,
           vaneev.v_dicnomns_soput_psv        d,
--           DICGNOMN       dd, 
           vaneev.v_dicstore_psv   t2,
           azssreportmain t1,
           AZSAZSSMLIST   az,
--           INS_DEPARTMENT ins,
           AZSGSMWAYSTYPES ps   --  новая
 where  t1.rn = t.nprn and
        t.nouttype = ps.rn and 
        t1.azs_pbe = pb.rn(+) and
        t.nnomen = d.rn and
        t1.date_smena >= to_date('01.10.2006','dd.mm.yyyy') and
        t1.date_smena <=  to_date('31.10.2006','dd.mm.yyyy') and
        t1.azs_number = t2.nrn and
--        d.group_code  = dd.rn  and  
        t1.azs_number = t2.nrn and
        /*(t2.nrn <> 281213312 and t2.nrn <> 291574147 and t2.nrn <> 299331040 and t2.nrn <> 293417509 and
         t2.nrn <> 293410972 and t2.nrn <> 293418249 and t2.nrn <> 293418792 and t2.nrn <> 293480810 and
         t2.nrn <> 299330929 and t2.nrn <> 299330954 and t2.nrn <> 311658186 and t2.nrn <> 339095070 and 
         t2.nrn <> 513723810 and t2.nrn <> 602293380) and  -- базы хранения*/
--        t2.department = ins.rn and --- новая
        t2.nstore_type = 0 and   ---- закрыла
        t.nnomen = d.rn and 
        t1.azs_smena = az.rn  --and  
		--and ps.factret_sign<>0      
 --and d.GROUP_TYPE in ('Фасованные масла','ТТХ','Смазки','Керосины')
-- and t2.SDEP_READY='ИНТА'
-- and t2.snumb='303'
) 
group by
nam,sdep_ready,dat,nomen_name
--
--  
union all
--
--
select 
al.snumb,
al.SDEP_READY,
       tt.docdate dat,
--        decode(al.store_type,0,(insd.name||'*'),insd.name) nam,
       dc.nomen_name,
--       decode(al.store_type,0,1,2) vid,
       decode(trim(dc.group_code),'СОПУТТОВ',st.summwithnds/1000, 
       decode(trim(dc.group_code),'МАТЕРИАЛ',st.summwithnds/1000,
       decode(trim(dc.group_code),'СПЕЦОДЕЖДА',st.summwithnds/1000,
       decode(trim(dc.group_code),'АВТОЗАПЧАСТИ',st.summwithnds/1000,0)))) sum_s,
       decode(trim(dc.group_code),'СОПУТТОВ',0, 
       decode(trim(dc.group_code),'МАТЕРИАЛ',0,
       decode(trim(dc.group_code),'СПЕЦОДЕЖДА',0,
       decode(trim(dc.group_code),'АВТОЗАПЧАСТИ',0,
       decode(trim(dc.group_code),'УСЛУГА',0,st.summwithnds/1000))))) sum_f,
       decode(trim(dc.group_code),'СОПУТТОВ',0, 
       decode(trim(dc.group_code),'МАТЕРИАЛ',0,
       decode(trim(dc.group_code),'СПЕЦОДЕЖДА',0,
       decode(trim(dc.group_code),'АВТОЗАПЧАСТИ',0,
       decode(trim(dc.group_code),'УСЛУГА',st.summwithnds/1000,0))))) sum_u
from TRANSINVCUST tt, TRANSINVCUSTSPECS st, vaneev.v_dicstore_psv al,vaneev.v_dicnomns_soput_psv dc, NOMMODIF nf--,DICGNOMN dg
, AZSGSMWAYSTYPES tp            
--INS_DEPARTMENT insd, 
,acatalog aa
where tt.rn = st.prn
  and tt.crn = aa.rn
 /* and (aa.rn = 188193665 -- Склад магазин(Сыкт)
       or aa.rn = 65996104 -- Маслобаза_фас(Ухта)
       or aa.rn = 129536314 -- фасовка(Усинк)
       or aa.rn = 207117748 -- Фасовка(У-Цильма)
       or aa.rn = 192656849 -- Фасовка(Печора)
       or aa.rn = 176196569 -- Фасовка(Инта)
       or aa.rn = 205096281 -- Фасовка(Ижма)
       or aa.rn = 207117286 -- Фасовка(Кослан)       
       or aa.rn = 218704704 -- Фасовка(Воркута)              
       or aa.rn = 223697979 -- Фасовка(Нарьян_Мар)              
       or aa.rn = 288449598 -- Фасовка(Арх)              
       or aa.rn = 570059525 -- Фасовка(Котлас)  
	   or aa.rn = 311962497
       --or (aa.rn = 311962497 and al.snumb like 'А018ф%')
       --or (aa.rn = 311962497 and al.snumb like 'А025ф%')
       )*/
  and aa.rn<>118738553	 
 and tt.status = 1
  and tt.stoper = tp.rn  -- отработан
  and tp.gsmways_type = 0 -- расход
  --and tp.factret_sign = 0 -- не возврат
--  and tp.section = 0 -- внешняя
  and tt.store = al.nrn
 /* and   (al.nrn <> 281213312 and al.nrn <> 291574147 and al.nrn <> 299331040 and al.nrn <> 293417509 and
         al.nrn <> 293410972 and al.nrn <> 293418249 and al.nrn <> 293418792 and al.nrn <> 293480810 and
         al.nrn <> 299330929 and al.nrn <> 299330954 and al.nrn <> 311658186 and al.nrn <> 339095070 and 
         al.nrn <> 513723810 and al.nrn <> 602293380)   -- базы хранения*/
--  and al.department = insd.rn  --- новая
  and (al.nstore_type = 0 or al.nstore_type = 0)  ---  добавила 0
  and tt.docdate >= to_date('01.10.2006','dd.mm.yyyy')
  and tt.docdate <= to_date('31.10.2006','dd.mm.yyyy')
  and st.nommodif = nf.rn
  and nf.prn = dc.rn
 -- and dc.group_code  = dg.rn  
 --and al.SDEP_READY='ИНТА'
 --and dc.GROUP_TYPE in ('Фасованные масла','ТТХ','Смазки','Керосины')
 --and al.snumb='300'
--
--
) a
group by a.sdep_ready--,a.nam
--order by a.sdep_ready,a.nam
--group by a.nam--,a.dat
--group by  a.kol,a.vid,a.nam, a.azs, a.nam1 order by a.kol, a.vid, a.nam, a.nam1


select * from acatalog where name like '%транзит%'