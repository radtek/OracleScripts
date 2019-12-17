SELECT KVIT.sved_num,KVIT.date_otgr,KVIT.num_cist,KLS_STAN.stan_kod,KLS_STAN.stan_name,KLS_STAN.rast,
KVIT.ves_brutto, KLS_PROD.name_npr,KLS_DOG.dog_number 
FROM KVIT,MONTH,KLS_STAN,KLS_PROD,KLS_DOG 
WHERE KVIT.prod_id_npr=KLS_PROD.id_npr 
AND KVIT.nom_zd=MONTH.nom_zd AND MONTH.stan_id=KLS_STAN.id AND KLS_STAN.rast>3000
AND MONTH.dog_id=KLS_DOG.id
AND KLS_DOG.maindog_id=795
AND KVIT.date_otgr>=TO_DATE('01.07.2003','dd.mm.yyyy')