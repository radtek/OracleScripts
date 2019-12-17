--
-- V_BITUM_UNP  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_BITUM_UNP
(NZ_VX, SH_VLAD, DATA_VX, LK, SH_NPR, 
 K_N, NAME, LK_POL, N_POL, STAN, 
 U_STAN, VES, KOL, DOR, PRIM, 
 KOD_DOR, KOD_POL, PRIZ, ADRESS, CODE_D, 
 DATA_DOG, GR4, VID_Z, VES_A, CENA, 
 KOD_OBL, N_PLAT, KOD_10, CENA_BN, OKPO, 
 DATE_PLAN, PRIZN_EXP, KOD_TEX_PD, NDS, ID_1, 
 NAIM_PR)
AS 
select
m.nom_zd as nz_vx,
1 as sh_vlad,
m.input_date as data_vx,
d.predpr_id as lk,
0 as sh_npr,
SUBSTR(p.abbr_npr,1,10) as k_n,
plat.predpr_name as name,
m.poluch_id as lk_pol,
pol.predpr_name as n_pol,
s.stan_name as stan,
s.stan_name as u_stan,
m.tonn_declared as ves,
m.cist_declared as kol,
gd.short_name as dor,
m.prim,
lpad(s.stan_kod,6,'0') as kod_dor,
pol.GD_KOD as kod_pol,
decode(m.is_exp,1,4,2) as priz,
Get_addr(pol.region_p_id,pol.POSTINDEX_P,pol.CITY_P,pol.ADDRESS_P) as adress,
d.short_number as code_d,
d.dog_date as data_dog,
m.gr4,
vo.load_type_id as vid_z,
m.tonn_declared as ves_a,
nvl(m.cena_otp,0) as cena,
reg.KOD_STATISTIC as kod_obl,
plat.predpr_name as n_plat,
p.kod_10,
nvl(m.cena,0) as cena_bn,
pol.okpo as okpo,
m.date_plan,
m.is_exp as prizn_exp,
m.tex_pd_id as kod_tex_pd,
nvl(m.cena_otp,0)-nvl(m.cena,0) as nds,
p.id as id_1,
p.name_npr as naim_pr
from month m, kls_dog d, kls_vid_otgr vo, kls_prod p, kls_predpr plat, kls_predpr pol, kls_stan s, kls_gdor gd,
kls_region reg
where m.dog_id=d.id(+)
and m.load_abbr=vo.load_abbr(+)
and m.prod_id_npr=p.id_npr(+)
and d.predpr_id=plat.id(+)
and m.poluch_id=pol.id(+)
and m.stan_id=s.id(+)
and s.gdor_id=gd.id(+)
and pol.region_p_id=reg.id(+)
and date_plan>=to_date('01.04.2008','dd.mm.yyyy')
and (/*vo.load_type_id=2 OR*/ substr(m.prod_id_npr,1,3) in ('130','131','242'))
--and m.nom_zd='3020107134'
;


