select /*+ rule */
month.is_exp,
kls_prod.abbr_npr,
min(kvit.date_kvit) as from_date_cena,
max(kvit.date_kvit) as to_date_cena,
kvit.cena,
kvit.cena_otp,
sum(kvit.ves_brutto) as ves
from kvit,month,kls_prod
where kvit.date_kvit>=to_date('01.01.2006','dd.mm.yyyy')
and kvit.nom_zd=month.nom_zd
and kvit.prod_id_npr=kls_prod.ID_NPR
and substr(kvit.prod_id_npr,1,3)='104'
and kvit.cena>10
group by 
month.is_exp,
kls_prod.abbr_npr,
kvit.cena,
kvit.cena_otp
order by 
from_date_cena