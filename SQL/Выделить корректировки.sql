--Оригинальные счета
update bills a set is_korr=0, to_korr=0 where a.date_vyp_sf between :begin_date and :end_date

--Счета которые корректируют другие
update bills a set to_korr=1 where a.old_nom_dok in ( 
select /*+ RULE */ nom_dok from bills
)
and a.date_vyp_sf between :begin_date and :end_date

--Счета которые были откорректированы другими
update bills a set is_korr=1 where a.nom_dok in ( 
select /*+ RULE */ old_nom_dok from bills
)
and a.date_vyp_sf between :begin_date and :end_date

-- Счета которые были сторнированы
update bills a set is_korr=2 where a.is_korr=1 and a.nom_dok not in ( 
select b.old_nom_dok from bills b where b.to_korr=1 and b.summa_dok>0
)
and a.date_vyp_sf between :begin_date and :end_date

-- Счета которые сторнируют
update bills a set to_korr=2 where a.to_korr=1 and a.old_nom_dok in ( 
select b.nom_dok from bills b where b.is_korr=2 and b.summa_dok>0
)
and a.date_vyp_sf between :begin_date and :end_date


-- Выделение "минусовых"
update bills a set to_korr=sign(summa_dok)*abs(to_korr) where to_korr<>0
and a.date_vyp_sf between :begin_date and :end_date

update bills a set is_korr=sign(summa_dok)*abs(is_korr) where is_korr<>0
and a.date_vyp_sf between :begin_date and :end_date


select nom_dok,nom_sf,old_nom_sf,old_nom_dok,is_korr,to_korr,summa_dok from bills where is_korr<>0 or to_korr<>0
order by nom_sf
