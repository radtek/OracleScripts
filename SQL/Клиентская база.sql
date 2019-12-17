SELECT 
  KLS_PREDPR.predpr_name AS PLAT,
  KLS_DOG.DOG_NUMBER, 
  KLS_PROD.name_npr,
  poluch.PREDPR_NAME AS poluch,
  KLS_STAN.STAN_NAME,
  SUM(DECODE(TO_CHAR(KVIT.date_kvit,'MM'),'01',KVIT.ves_brutto,0)) AS ves01,
  SUM(DECODE(TO_CHAR(KVIT.date_kvit,'MM'),'02',KVIT.ves_brutto,0)) AS ves02,
  SUM(DECODE(TO_CHAR(KVIT.date_kvit,'MM'),'03',KVIT.ves_brutto,0)) AS ves03,
  SUM(DECODE(TO_CHAR(KVIT.date_kvit,'MM'),'04',KVIT.ves_brutto,0)) AS ves04,
  SUM(DECODE(TO_CHAR(KVIT.date_kvit,'MM'),'05',KVIT.ves_brutto,0)) AS ves05,
  SUM(DECODE(TO_CHAR(KVIT.date_kvit,'MM'),'06',KVIT.ves_brutto,0)) AS ves06,
  SUM(DECODE(TO_CHAR(KVIT.date_kvit,'MM'),'07',KVIT.ves_brutto,0)) AS ves07,
  SUM(DECODE(TO_CHAR(KVIT.date_kvit,'MM'),'08',KVIT.ves_brutto,0)) AS ves08,
  SUM(DECODE(TO_CHAR(KVIT.date_kvit,'MM'),'09',KVIT.ves_brutto,0)) AS ves09,
  SUM(DECODE(TO_CHAR(KVIT.date_kvit,'MM'),'10',KVIT.ves_brutto,0)) AS ves10,
  SUM(DECODE(TO_CHAR(KVIT.date_kvit,'MM'),'11',KVIT.ves_brutto,0)) AS ves11,
  SUM(DECODE(TO_CHAR(KVIT.date_kvit,'MM'),'12',KVIT.ves_brutto,0)) AS ves12,
  SUM(KVIT.ves_brutto) AS all_ves
FROM KVIT,MONTH,KLS_PREDPR,KLS_DOG,KLS_PROD,KLS_PREDPR poluch,KLS_STAN
WHERE KVIT.nom_zd=MONTH.nom_zd
AND DECODE(MONTH.NPODOG_ID,NULL,MONTH.dog_id,MONTH.NPODOG_ID)=KLS_DOG.ID 
AND KLS_DOG.predpr_id=KLS_PREDPR.ID
AND KVIT.prod_id_npr=KLS_PROD.id_npr
AND KVIT.date_kvit BETWEEN TO_DATE('01.01.2002','dd.mm.yyyy') AND TO_DATE('31.12.2002','dd.mm.yyyy')
AND KLS_PROD.id_group_npr='13000'
AND MONTH.POLUCH_ID=poluch.ID
AND MONTH.STAN_ID=KLS_STAN.ID 
GROUP BY KLS_PREDPR.predpr_name,  KLS_DOG.DOG_NUMBER, KLS_PROD.name_npr, poluch.PREDPR_NAME, KLS_STAN.STAN_NAME