SELECT
'-- ќбновить BUHANAL в таблице SF_POZ_VYR - в позици€х с совпадающим весом' FROM dual
UNION ALL  
select 'UPDATE sveta.sf_poz_vyr SET buhanal=134 WHERE kod_prod='||TO_CHAR(list_134.kod_prod)||
       ' AND id_poz_prod='||TO_CHAR(sf_poz_vyr.id_poz_prod)||' AND kol='||TO_CHAR(list_134.kol)||' and kod_tu=6;'
from sveta.sf_poz_vyr,list_134 
where sf_poz_vyr.kod_prod=list_134.kod_prod
  and sf_poz_vyr.kol=list_134.kol
  and sveta.sf_poz_vyr.buhanal=1
UNION ALL
SELECT
'-- ќбновить BUHANAL в таблице SF_POZ_PROD - в позици€х с совпадающим весом' FROM dual
UNION ALL  
select 'UPDATE sveta.sf_poz_prod SET buhanal=134 WHERE kod_prod='||TO_CHAR(list_134.kod_prod)||
       ' AND id_poz_prod='||TO_CHAR(sf_poz_prod.id_poz_prod)||' AND kol='||TO_CHAR(list_134.kol)||' and kod_tu=6;'
from sveta.sf_poz_prod,list_134 
where sf_poz_prod.kod_prod=list_134.kod_prod
  and sf_poz_prod.kol=list_134.kol
  and sveta.sf_poz_prod.buhanal=1
UNION ALL
SELECT 
'--”далить позиции из SF_POZ_PROD, которые должны разделитьс€ в результате перепаспортизации' from dual
UNION ALL
select DISTINCT 'DELETE FROM sveta.sf_poz_prod WHERE kod_prod='||TO_CHAR(list_134.kod_prod)||
       ' AND id_poz_prod='||TO_CHAR(sf_poz_prod.id_poz_prod)||' and kod_tu=6;'
from sveta.sf_poz_prod,list_134,sveta.sf_poz_vyr 
where sf_poz_prod.kod_prod=list_134.kod_prod
  and sf_poz_prod.kol<>list_134.kol
  and sf_poz_prod.kod_prod=sf_poz_vyr.kod_prod
  and sf_poz_prod.id_poz_prod=sf_poz_vyr.id_poz_prod
  and sf_poz_vyr.buhanal=1
UNION ALL
SELECT
'-- ƒобавл€ем позиции в SF_POZ_PROD которые разделились в результате перепаспортизации' from dual
UNION ALL  
select DISTINCT 
 'INSERT INTO sveta.sf_poz_prod (ID_POZ_PROD, EDIZM, STUSL, KOD_PROD, KOD_TU, NAIM_TOV, KOL, CENA, AKCIZ1, SUMMA, AKCIZ2, STNDS, '||
       'SUMNDS, STGSM, SUMGSM, ALLNDS, BUHDT, BUHKT, BUHANAL, KOMMENT, LOADATE, STNPR, SUMNPR, STATUS, CENA_PRIOBR_RUB, KURS_TO_DATE, '||
	   'SUMOTG_RUB, KORRDATE, SUM_PRIOBR_RUB, N_DOPOLN, DATE_DOPOLN, PROISX, GTD, ID_POZ_POKUP, DATE_OTGR, DATE_SHOW, CUSDTY25, '||
	   'NOTFINREZ, ID_NPZ, ID_POZ_PROD_VOZNAGR, MAIN_DATE, ID_POZ_STORN, ID_NFPROD, NUM_5, SVERENR3, KOD_NDS, R3_ACCOUNT, NO_AKCIZ) '||
  'VALUES('||
    TO_CHAR(sf_poz_prod.ID_POZ_PROD*10+DECODE(sf_poz_vyr.kol,list_134.kol,1,0))||','||
	''''||TO_CHAR(sf_poz_prod.EDIZM)||''','|| 
	TO_CHAR(sf_poz_prod.STUSL)||','|| 
	TO_CHAR(sf_poz_prod.KOD_PROD)||','|| 
	TO_CHAR(sf_poz_prod.KOD_TU)||','|| 
	''''||TO_CHAR(sf_poz_prod.NAIM_TOV)||''','|| 
	TO_CHAR(sf_poz_vyr.KOL)||','|| 
	TO_CHAR(sf_poz_prod.CENA)||','|| 
	TO_CHAR(sf_poz_vyr.AKCIZ1)||','|| 
	TO_CHAR(sf_poz_vyr.SUMMA)||','|| 
	TO_CHAR(sf_poz_vyr.AKCIZ2)||','|| 
	TO_CHAR(sf_poz_prod.STNDS)||','|| 
	TO_CHAR(sf_poz_vyr.SUMNDS)||','|| 
	TO_CHAR(sf_poz_prod.STGSM)||','|| 
	TO_CHAR(sf_poz_vyr.SUMGSM)||','||
    TO_CHAR(sf_poz_vyr.ALLNDS)||','|| 
	''''||TO_CHAR(sf_poz_prod.BUHDT)||''','|| 
	''''||TO_CHAR(sf_poz_prod.BUHKT)||''','|| 
	TO_CHAR(DECODE(sf_poz_vyr.kol,list_134.kol,134,sf_poz_vyr.BUHANAL))||','|| 
	''''||TO_CHAR(sf_poz_prod.KOMMENT)||''','||
	'TO_DATE('''||TO_CHAR(sf_poz_prod.LOADATE,'DD.MM.YYYY')||''',''DD.MM.YYYY''),'|| 
	TO_CHAR(sf_poz_prod.STNPR)||','|| 
	TO_CHAR(sf_poz_prod.SUMNPR)||','|| 
	TO_CHAR(sf_poz_prod.STATUS)||','|| 
	NVL(TO_CHAR(sf_poz_prod.CENA_PRIOBR_RUB),'NULL')||','|| 
	NVL(TO_CHAR(sf_poz_prod.KURS_TO_DATE),'NULL')||','|| 
	NVL(TO_CHAR(sf_poz_prod.SUMOTG_RUB),'NULL')||','|| 
	DECODE(sf_poz_prod.KORRDATE,NULL,'NULL','TO_DATE('''||TO_CHAR(sf_poz_prod.KORRDATE,'DD.MM.YYYY')||''',''DD.MM.YYYY'')')||','|| 
    NVL(TO_CHAR(sf_poz_prod.SUM_PRIOBR_RUB),'NULL')||','|| 
	NVL(TO_CHAR(sf_poz_prod.N_DOPOLN),'NULL')||','|| 
	DECODE(sf_poz_prod.DATE_DOPOLN,NULL,'NULL','TO_DATE('''||TO_CHAR(sf_poz_prod.DATE_DOPOLN,'DD.MM.YYYY')||''',''DD.MM.YYYY'')')||','|| 
	''''||TO_CHAR(sf_poz_prod.PROISX)||''','|| 
	''''||TO_CHAR(sf_poz_prod.GTD)||''','|| 
	NVL(TO_CHAR(sf_poz_prod.ID_POZ_POKUP),'NULL')||','|| 
	DECODE(sf_poz_prod.DATE_OTGR,NULL,'NULL','TO_DATE('''||TO_CHAR(sf_poz_prod.DATE_OTGR,'DD.MM.YYYY')||''',''DD.MM.YYYY'')')||','||
	DECODE(sf_poz_prod.DATE_SHOW,NULL,'NULL','TO_DATE('''||TO_CHAR(sf_poz_prod.DATE_SHOW,'DD.MM.YYYY')||''',''DD.MM.YYYY'')')||','||
	NVL(TO_CHAR(sf_poz_prod.CUSDTY25),'NULL')||','|| 
	NVL(TO_CHAR(sf_poz_prod.NOTFINREZ),'NULL')||','|| 
	NVL(TO_CHAR(sf_poz_prod.ID_NPZ),'NULL')||','||
    NVL(TO_CHAR(sf_poz_prod.ID_POZ_PROD_VOZNAGR),'NULL')||','|| 
	DECODE(sf_poz_prod.MAIN_DATE,NULL,'NULL','TO_DATE('''||TO_CHAR(sf_poz_prod.MAIN_DATE,'DD.MM.YYYY')||''',''DD.MM.YYYY'')')||','||
	NVL(TO_CHAR(sf_poz_prod.ID_POZ_STORN),'NULL')||','|| 
	''''||TO_CHAR(sf_poz_prod.ID_NFPROD)||''','|| 
	NVL(TO_CHAR(sf_poz_prod.NUM_5),'NULL')||','|| 
	''''||TO_CHAR(sf_poz_prod.SVERENR3)||''','|| 
	''''||TO_CHAR(sf_poz_prod.KOD_NDS)||''','|| 
	''''||TO_CHAR(sf_poz_prod.R3_ACCOUNT)||''','|| 
	''''||TO_CHAR(sf_poz_prod.NO_AKCIZ)||''');'
from sveta.sf_poz_prod,list_134,sveta.sf_poz_vyr 
where sf_poz_prod.kod_prod=list_134.kod_prod
  and sf_poz_prod.kol<>list_134.kol
  and sf_poz_prod.buhanal=1
  and sf_poz_prod.kod_prod=sf_poz_vyr.kod_prod
  and sf_poz_prod.id_poz_prod=sf_poz_vyr.id_poz_prod
  

