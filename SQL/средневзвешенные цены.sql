select
  CASE   
    WHEN kls_prod.prod_plan_id BETWEEN 10300 AND 10379 THEN 'Автобензины'
    WHEN kls_prod.prod_plan_id = 10385 THEN 'Сырье УГВ'
    WHEN kls_prod.prod_plan_id BETWEEN 10400 AND 10499 THEN 'Дизтопливо'
    WHEN kls_prod.prod_plan_id BETWEEN 10500 AND 10599 THEN 'РТ'
    WHEN kls_prod.prod_plan_id BETWEEN 11500 AND 11599 THEN 'Мазут'
    WHEN kls_prod.prod_plan_id BETWEEN 11900 AND 11999 THEN 'Масла'
    WHEN kls_prod.prod_plan_id=23200 THEN 'Масла'
    WHEN kls_prod.prod_plan_id BETWEEN 13000 AND 13199 THEN 'Битумы'
    WHEN kls_prod.prod_plan_id=23600 THEN 'Вакуумный газойль'
    WHEN kls_prod.prod_plan_id=23950 THEN 'Прочие'
    WHEN kls_prod.prod_plan_id=23960 THEN 'Прочие'
    WHEN kls_prod.prod_plan_id=23970 THEN 'Прочие'
    WHEN kls_prod.prod_plan_id=24210 THEN 'Прочие'
	ELSE kls_prod_plan.name_npr
  END as name_npr,	
  ROUND(SUM(kvit.ves_brutto*kvit.cena)/SUM(kvit.ves_brutto),2) as cena,
  ROUND(SUM(kvit.ves_brutto*kvit.cena_otp)/SUM(kvit.ves_brutto),2) as cena_otp,
  COUNT(*) as kol,
  SUM(ves_brutto) as ves
from kvit,kls_prod,kls_prod_plan,month
where kvit.prod_id_npr=kls_prod.id_npr
and kls_prod.prod_plan_id=kls_prod_plan.id 
and date_otgr between to_date('01.01.2004','dd.mm.yyyy') and to_date('30.06.2004','dd.mm.yyyy')
and kvit.nom_zd=month.nom_zd and month.is_exp=0
and  kvit.bill_id is not null
and kvit.bill_id<>0
and kvit.cena<>0
group by 
    CASE   
    WHEN kls_prod.prod_plan_id BETWEEN 10300 AND 10379 THEN 'Автобензины'
    WHEN kls_prod.prod_plan_id = 10385 THEN 'Сырье УГВ'
    WHEN kls_prod.prod_plan_id BETWEEN 10400 AND 10499 THEN 'Дизтопливо'
    WHEN kls_prod.prod_plan_id BETWEEN 10500 AND 10599 THEN 'РТ'
    WHEN kls_prod.prod_plan_id BETWEEN 11500 AND 11599 THEN 'Мазут'
    WHEN kls_prod.prod_plan_id BETWEEN 11900 AND 11999 THEN 'Масла'
    WHEN kls_prod.prod_plan_id=23200 THEN 'Масла'
    WHEN kls_prod.prod_plan_id BETWEEN 13000 AND 13199 THEN 'Битумы'
    WHEN kls_prod.prod_plan_id=23600 THEN 'Вакуумный газойль'
    WHEN kls_prod.prod_plan_id=23950 THEN 'Прочие'
    WHEN kls_prod.prod_plan_id=23960 THEN 'Прочие'
    WHEN kls_prod.prod_plan_id=23970 THEN 'Прочие'
    WHEN kls_prod.prod_plan_id=24210 THEN 'Прочие'
	ELSE kls_prod_plan.name_npr
  END	

  
  