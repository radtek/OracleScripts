SELECT KLS_PROD.LONG_NAME_NPR, poluch.PREDPR_NAME AS poluch_name, KLS_STAN.STAN_NAME, SUM(KVIT.ves_brutto) AS ves
FROM KVIT, MONTH,KLS_PREDPR poluch, KLS_STAN, KLS_PROD
WHERE KVIT.nom_zd=MONTH.nom_zd
AND KVIT.PROD_ID_NPR=KLS_PROD.id_npr 
AND MONTH.poluch_id=poluch.ID
AND MONTH.STAN_ID=KLS_STAN.ID
AND KVIT.date_oforml>=TO_DATE('01.04.2003 07:00','dd.mm.yyyy hh24:mi')
AND KVIT.date_oforml<TO_DATE('29.04.2003 16:00','dd.mm.yyyy hh24:mi')
AND MONTH.planstru_id IN (95)
GROUP BY KLS_PROD.LONG_NAME_NPR, poluch.PREDPR_NAME, KLS_STAN.STAN_NAME