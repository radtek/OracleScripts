--
-- V_TRIADA_RAZNAR  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_TRIADA_RAZNAR
(VID_DOC, GRPROD, PROD, PLAT, DATE_O, 
 TRIADA, NORMA, KOL_PLAN, VES_PLAN, KOL_FAKT, 
 VES_FAKT)
AS 
SELECT vid_doc
	   ,GRPROD
       ,PROD
       ,PLAT
	   ,DATE_O
	   ,(case 
	   		  when to_number(to_char(DATE_O,'dd')) in (1,2,3) then 1
			  when to_number(to_char(DATE_O,'dd')) in (4,5,6) then 2
			  when to_number(to_char(DATE_O,'dd')) in (7,8,9,10) then 3
			  when to_number(to_char(DATE_O,'dd')) in (11,12,13) then 4
			  when to_number(to_char(DATE_O,'dd')) in (14,15,16) then 5
			  when to_number(to_char(DATE_O,'dd')) in (17,18,19,20) then 6
			  when to_number(to_char(DATE_O,'dd')) in (21,22,23) then 7
			  when to_number(to_char(DATE_O,'dd')) in (24,25,26) then 8
			  else 9
		  end) as triada	   
	   ,NORMA
	   ,KOL_PLAN
	   ,VES_PLAN
	   ,KOL_FAKT
	   ,VES_FAKT
FROM
(SELECT vid_doc 
	   ,GRPROD
       ,PROD
       ,PLAT
	   ,DATE_O
	   ,MAX(NORMA) AS NORMA
	   ,SUM(KOL_PLAN) AS KOL_PLAN
	   ,SUM(VES_PLAN) AS VES_PLAN
	   ,SUM(KOL_FAKT) AS KOL_FAKT
	   ,SUM(VES_FAKT) AS VES_FAKT
FROM (
--KVIT
SELECT /*+ ORDERED USE_NL(K,M,A) */
  'fact' as vid_doc
  ,GR_NP.NAME_NPR AS GRPROD
  ,NP.NAME_NPR AS PROD
  ,PL.FULLPLAT AS PLAT
  ,(CASE
	WHEN K.DATE_OFORML>=TO_DATE(TO_CHAR(TRUNC(K.DATE_OFORML),'DD.MM.YYYY')||' 17:00:00','DD.MM.YYYY HH24:MI:SS') THEN TRUNC(K.DATE_OFORML)+1
	ELSE TRUNC(K.DATE_OFORML)
    END) AS DATE_O
  ,0 AS NORMA
  ,0 AS KOL_PLAN
  ,0 AS VES_PLAN
  ,1 AS KOL_FAKT
  ,K.VES_BRUTTO AS VES_FAKT
FROM
  KVIT K
  ,MONTH M
  ,KLS_VID_OTGR VO
  ,KLS_PROD_GU12 P
  ,KLS_PROD NP
  ,KLS_PROD GR_NP
  ,GU12_A A
  ,KLS_DOG D
  ,V_GU12_PLAT PL
WHERE
  K.NOM_ZD=M.NOM_ZD(+)
  AND M.LOAD_ABBR=VO.LOAD_ABBR(+)
  AND K.PROD_ID_NPR=NP.ID_NPR(+)
  AND NP.PROD_GU12_ID=P.ID(+)
  AND NP.ID_GROUP_NPR=GR_NP.ID_NPR(+)
  AND M.GU12_A_ID=A.ID(+)
  AND K.DATE_OFORML>=TO_DATE(SUBSTR(FOR_TEMP.GET_AS_CHAR('BEGIN_DATE','MASTER','RAZNAR_TRIADA.XLS'),1,10)||' 17:00:00','DD.MM.YYYY HH24:MI:SS')-1
  AND K.DATE_OFORML<TO_DATE(SUBSTR(FOR_TEMP.GET_AS_CHAR('END_DATE','MASTER','RAZNAR_TRIADA.XLS'),1,10)||' 17:00:00','DD.MM.YYYY HH24:MI:SS')
  AND VO.LOAD_TYPE_ID=1
  AND M.DOG_ID=D.ID
  AND D.PREDPR_ID=PL.PLAT_ID
  AND NOT A.SOGL_DATE IS NULL
--  AND m.is_exp=0	   
UNION ALL
-- GU12
SELECT
  'gu12' as vid_doc  
  ,GR_NP.NAME_NPR AS GRPROD
  ,NVL(NP.NAME_NPR,'   ') AS PROD
  ,PL.FULLPLAT AS PLAT
  ,BR.DATE_R AS DATE_O
  ,NP.NORMOTGR AS NORMA
  ,BR.KOL_VAG AS KOL_PLAN
  ,BR.VES AS VES_PLAN
  ,0 AS KOL_FAKT
  ,0 AS VES_FAKT
FROM
  GU12_BR BR
  ,GU12_B B
  ,GU12_A A
  ,KLS_PROD_GU12 P
  ,KLS_PROD NP
  ,KLS_PROD GR_NP
  ,V_GU12_PLAT PL
WHERE
  BR.ID_B=B.ID
  AND B.ID_A=A.ID
  AND A.PROD_ID=P.ID
  AND BR.ID_NPR=NP.ID_NPR(+)
  AND NP.ID_GROUP_NPR=GR_NP.ID_NPR(+)
  AND PL.PLAT_ID=B.PLAT_ID
  AND BR.DATE_R BETWEEN FOR_TEMP.GET_AS_DATE('BEGIN_DATE','MASTER','RAZNAR_TRIADA.XLS') AND FOR_TEMP.GET_AS_DATE('END_DATE','MASTER','RAZNAR_TRIADA.XLS')
  AND B.ISCOR<>2
  AND NOT A.SOGL_DATE IS NULL
--  AND NVL(A.EXPED_ID,0)=0  
)
GROUP BY GRPROD
	  	 ,vid_doc
         ,PROD
         ,PLAT
		 ,(case 
	   		  when to_number(to_char(DATE_O,'dd')) in (1,2,3) then 1
			  when to_number(to_char(DATE_O,'dd')) in (4,5,6) then 2
			  when to_number(to_char(DATE_O,'dd')) in (7,8,9,10) then 3
			  when to_number(to_char(DATE_O,'dd')) in (11,12,13) then 4
			  when to_number(to_char(DATE_O,'dd')) in (14,15,16) then 5
			  when to_number(to_char(DATE_O,'dd')) in (17,18,19,20) then 6
			  when to_number(to_char(DATE_O,'dd')) in (21,22,23) then 7
			  when to_number(to_char(DATE_O,'dd')) in (24,25,26) then 8
			  else 9
		  end)		 
	     ,DATE_O
ORDER BY GRPROD
         ,PROD
         ,PLAT
	     ,DATE_O)
WHERE NOT (KOL_PLAN=0 AND VES_PLAN=0 AND KOL_FAKT=0 AND VES_FAKT=0);


