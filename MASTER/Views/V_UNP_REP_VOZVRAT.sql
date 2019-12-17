--
-- V_UNP_REP_VOZVRAT  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_UNP_REP_VOZVRAT
(NUM_AKT, SUM_VNR, KOL_VNR, SUM_EXP_N, KOL_EXP_N, 
 SUM_EXP_P, KOL_EXP_P)
AS 
select
	 t.num_akt
	 ,sum(case when m.is_exp=0 then v.summa else 0 end) as sum_vnr
	 ,sum(case when m.is_exp=0 then 1 else 0 end) as kol_vnr 
	 ,sum(case when m.is_exp=1 and p.id_group_npr=90099 then v.summa else 0 end) as sum_exp_n
	 ,sum(case when m.is_exp=1 and p.id_group_npr=90099 then 1 else 0 end) as kol_exp_n 
	 ,sum(case when m.is_exp=1 and p.id_group_npr<>90099 then v.summa else 0 end) as sum_exp_p
	 ,sum(case when m.is_exp=1 and p.id_group_npr<>90099 then 1 else 0 end) as kol_exp_p 
from kvit k
	 ,month m
	 ,vozvrat_temp t
	 ,vozvrat v
	 ,kls_prod p
where 
	 t.user_name=for_init.GetCurrUser()
	 and t.priznak=1
	 and t.num_akt=trim(v.num_akt)
	 and m.nom_zd=k.nom_zd
	 and v.num_cist=k.num_cist
	 and get_newkvit(v.date_kvit,v.num_cist)=k.num_kvit
	 and k.prod_id_npr=p.id_npr
group by t.num_akt
order by t.num_akt;


