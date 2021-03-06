-- ����������� ����
SELECT BILLS.DATE_KVIT,BILLS.DATE_MOS,BILLS.NOM_SF,BILLS.DOG_ID,BILLS.NOM_DOK,BILLS.LUK_SUMMA_DOK,A.* FROM 
(
SELECT 
AP.KOD_PROD AS NOM_DOK, SUM(AP.KOL) AS VES, MAX(AP.CENA) AS CENA, 
SUM(AP.allnds) AS summa_dok,ASF.SCHETF,MAX(AP.NUM_5) AS NUM_5 FROM SVETA.SF_POZ_PROD AP,SVETA.SF_SFAK_PROD ASF 
WHERE AP.DATE_OTGR>=TO_DATE('01.03.2003','dd.mm.yyyy')
  AND AP.KOD_PROD=ASF.KOD_PROD 
GROUP BY AP.KOD_PROD,ASF.SCHETF
) A, BILLS
WHERE BILLS.NOM_DOK=A.NOM_DOK(+)
  AND (ABS(NVL(A.summa_dok,0)-BILLS.luk_summa_dok)<>0 
       OR Get_Num_5(BILLS.DATE_MOS)<>NVL(A.NUM_5,0))
  AND BILLS.DATE_KVIT>=TO_DATE('01.03.2003','dd.mm.yyyy')
  AND BILLS.IS_AGENT IN (1,2)	   
ORDER BY BILLS.nom_dok

-- � ��������� ������ ���������� LINKSCHF
SELECT BILLS.DATE_KVIT,BILLS.NOM_SF,BILLS.DOG_ID,BILLS.NOM_DOK,BILLS.LUK_SUMMA_DOK,A.* FROM 
(SELECT 
AP.KOD_PROD AS NOM_DOK, SUM(AP.KOL) AS VES, MAX(AP.CENA) AS CENA, 
SUM(AP.allnds) AS summa_dok,ASF.SCHETF FROM SVETA.SF_POZ_PROD AP,SVETA.SF_SFAK_PROD ASF 
WHERE AP.DATE_OTGR>=TO_DATE('01.02.2003','dd.mm.yyyy')
  AND AP.KOD_PROD=ASF.KOD_PROD
  AND ASF.LINKSCHF||' '<>' ' 
GROUP BY AP.KOD_PROD,ASF.SCHETF
) A, BILLS
WHERE A.NOM_DOK=BILLS.NOM_DOK
  AND BILLS.SUMMA_DOK<0
ORDER BY A.nom_dok

-- �� ����������� ��� ������� DATE_OTSRPL 
SELECT DISTINCT 'UPDATE SF_SFAK_PROD SET DATE_OTSRPL=TO_DATE('''||TO_CHAR(BILLS.DATE_KVIT+BILLS.KOL_DN,'dd.mm.yyyy')||''',''dd.mm.yyyy'') WHERE kod_tu=6 AND kod_prod='||TO_CHAR(BILLS.nom_dok)||';' 
FROM SVETA.SF_POZ_PROD AP,BILLS,SVETA.SF_SFAK_PROD ASF 
WHERE AP.DATE_OTGR>=TO_DATE('01.02.2003','dd.mm.yyyy')
  AND (ASF.DATE_OTSRPL IS NULL OR ASF.DATE_OTSRPL<>BILLS.DATE_KVIT+BILLS.KOL_DN) 
  AND AP.KOD_PROD=BILLS.NOM_DOK
  AND AP.KOD_PROD=ASF.KOD_PROD

-- ������� NUM_5
SELECT 'UPDATE SF_POZ_PROD SET NUM_5='||TO_CHAR(Get_Num_5(NVL(BILLS.DATE_MOS,BILLS.DATE_KVIT)))||' WHERE kod_tu=6 AND kod_prod='||TO_CHAR(BILLS.nom_dok)||';' 
FROM SVETA.SF_POZ_PROD AP,BILLS,SVETA.SF_SFAK_PROD ASF 
WHERE AP.DATE_OTGR>=TO_DATE('01.03.2003','dd.mm.yyyy')
  AND (AP.NUM_5<>Get_Num_5(NVL(BILLS.DATE_MOS,BILLS.DATE_KVIT))) 
  AND AP.KOD_PROD=BILLS.NOM_DOK
  AND AP.KOD_PROD=ASF.KOD_PROD
ORDER BY ASF.kod_prod


-- ����������� ��� ������
SELECT A.SCHETF,A.DATA_VYP_SF,BILLS.DATE_VYP_SF AS NPO_DATE_SF FROM 
(SELECT 
AP.KOD_PROD AS NOM_DOK, ASF.SCHETF,ASF.DATA_VYP_SF FROM SVETA.SF_POZ_PROD AP,SVETA.SF_SFAK_PROD ASF 
WHERE AP.DATE_OTGR>=TO_DATE('01.01.2003','dd.mm.yyyy')
  AND AP.KOD_PROD=ASF.KOD_PROD 
GROUP BY AP.KOD_PROD,ASF.SCHETF,ASF.DATA_VYP_SF
) A, BILLS
WHERE BILLS.NOM_DOK=A.NOM_DOK
  AND BILLS.date_vyp_sf<>a.data_vyp_sf
ORDER BY A.DATA_VYP_SF,A.schetf


-- ����� ��� ������
SELECT A.SCHETF,A.DATA_VYP_SF,A.NO_AKCIZ,BILLS.NO_AKCIZ,BILLS.DATE_KVIT,A.FULL_NAME_PLAT,A.NAIM_TOV,A.CENA FROM 
(SELECT 
AP.KOD_PROD AS NOM_DOK, ASF.SCHETF,ASF.DATA_VYP_SF,AP.NO_AKCIZ,ASF.FULL_NAME_PLAT,AP.NAIM_TOV,AP.CENA FROM SVETA.SF_POZ_PROD AP,SVETA.SF_SFAK_PROD ASF 
WHERE AP.DATE_OTGR>=TO_DATE('01.10.2003','dd.mm.yyyy')
  AND AP.KOD_PROD=ASF.KOD_PROD 
  AND AP.BUHANAL=1
GROUP BY AP.KOD_PROD,ASF.SCHETF,ASF.DATA_VYP_SF,AP.NO_AKCIZ,ASF.FULL_NAME_PLAT,AP.NAIM_TOV,AP.CENA
) A, BILLS
WHERE BILLS.NOM_DOK=A.NOM_DOK
  AND BILLS.NO_AKCIZ<>DECODE(A.NO_AKCIZ,NULL,0,1)
ORDER BY A.DATA_VYP_SF,A.schetf
  


