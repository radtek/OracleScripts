SELECT 'UPDATE sf_sfak_prod set date_otsrpl=to_date('''||TO_CHAR(BILLS.date_kvit+BILLS.kol_dn,'dd.mm.yyyy')||''',''dd.mm.yyyy'') where kod_prod='||TO_CHAR(BILLS.nom_dok)||';'
FROM SVETA.SF_SFAK_PROD A,BILLS WHERE A.DATE_OTSRPL IS NULL AND A.data_vyp_sf>=TO_DATE('01.02.2003','dd.mm.yyyy')
AND BILLS.nom_dok=a.kod_prod

