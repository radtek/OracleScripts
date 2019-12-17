--
-- V_GU12_REP_PLANFAKT  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GU12_REP_PLANFAKT
(PROD, PLAT, NOM_Z, STAN, DATE_O, 
 KOL_PLAN, VES_PLAN, KOL_FAKT, VES_FAKT)
AS 
SELECT PROD
       ,PLAT
	   ,NOM_Z
	   ,STAN
	   ,DATE_O
	   ,KOL_PLAN
	   ,VES_PLAN
	   ,KOL_FAKT
	   ,VES_FAKT
FROM
(
SELECT PROD
       ,PLAT
	   ,NOM_Z
	   ,STAN
	   ,DATE_O
	   ,SUM(KOL_PLAN) AS KOL_PLAN
	   ,SUM(VES_PLAN) AS VES_PLAN
	   ,SUM(KOL_FAKT) AS KOL_FAKT
	   ,SUM(VES_FAKT) AS VES_FAKT
FROM (
--KVIT
SELECT /*+ ORDERED USE_NL(K,M,A) */
  PGD.NAME AS PROD
  ,PL.FULLPLAT AS PLAT
  ,A.NOM_Z
  ,S.STAN_NAME AS STAN
  ,(CASE
	WHEN K.DATE_OFORML>=TO_DATE(TO_CHAR(TRUNC(K.DATE_OFORML),'DD.MM.YYYY')||' 17:00:00','DD.MM.YYYY HH24:MI:SS') THEN TRUNC(K.DATE_OFORML)+1
	ELSE TRUNC(K.DATE_OFORML)
    END) AS DATE_O
--  ,TRUNC(K.DATE_OFORML) AS DATE_O
  ,0 AS KOL_PLAN
  ,0 AS VES_PLAN
  ,1 AS KOL_FAKT
  ,K.VES_BRUTTO AS VES_FAKT
FROM
  KVIT K
  ,MONTH M
  ,KLS_VID_OTGR VO
  ,KLS_PROD P
  ,KLS_PROD_GU12 PGD
  ,GU12_A A
  ,V_GU12_STAN_NAZN S
  ,KLS_DOG D
  ,V_GU12_PLAT PL
WHERE
  K.NOM_ZD=M.NOM_ZD(+)
  AND M.LOAD_ABBR=VO.LOAD_ABBR(+)
  AND K.PROD_ID_NPR=P.ID_NPR(+)
  AND P.PROD_GU12_ID=PGD.ID(+)
  AND M.GU12_A_ID=A.ID(+)
  AND M.STAN_ID=S.ID(+)
  AND K.DATE_OFORML>=TO_DATE(SUBSTR(FOR_TEMP.GET_AS_CHAR('DBEG_MONTH','MASTER','GU12'),1,10)||' 17:00:00','DD.MM.YYYY HH24:MI:SS')-1
  AND K.DATE_OFORML<TO_DATE(SUBSTR(FOR_TEMP.GET_AS_CHAR('DEND_MONTH','MASTER','GU12'),1,10)||' 17:00:00','DD.MM.YYYY HH24:MI:SS')
--  AND K.DATE_KVIT>=FOR_TEMP.GET_AS_DATE('DBEG_MONTH','GU12','GU12_PLANFAKT.XLS')
--  AND K.DATE_KVIT<=FOR_TEMP.GET_AS_DATE('DEND_MONTH','GU12','GU12_PLANFAKT.XLS')
  AND VO.LOAD_TYPE_ID=1
  AND M.DOG_ID=D.ID
  AND D.PREDPR_ID=PL.PLAT_ID
  AND NOT A.SOGL_DATE IS NULL
  AND (CASE
          WHEN FOR_TEMP.GET_AS_NUM('USER_UNP','MASTER','GU12')=1 THEN 2641
		  ELSE PL.PLAT_ID
	   END)=2641
UNION ALL
-- GU12
SELECT
  P.NAME AS PROD
  ,PL.FULLPLAT AS PLAT
  ,A.NOM_Z
  ,S.STAN_NAME AS STAN
  ,BR.DATE_R AS DATE_O
  ,BR.KOL_VAG AS KOL_PLAN
  ,BR.VES AS VES_PLAN
  ,0 AS KOL_FAKT
  ,0 AS VES_FAKT
FROM
  GU12_BR BR
  ,GU12_B B
  ,GU12_A A
  ,KLS_PROD_GU12 P
  ,V_GU12_PLAT PL
  ,V_GU12_STAN_NAZN S
WHERE
  BR.ID_B=B.ID
  AND B.ID_A=A.ID
  AND A.PROD_ID=P.ID
  AND PL.PLAT_ID=B.PLAT_ID
  AND S.ID=B.STAN_ID
  AND BR.DATE_R BETWEEN FOR_TEMP.GET_AS_DATE('DBEG_MONTH','MASTER','GU12') AND FOR_TEMP.GET_AS_DATE('DEND_MONTH','MASTER','GU12')
  AND B.ISCOR<>2
  AND NOT A.SOGL_DATE IS NULL
  AND (CASE
          WHEN FOR_TEMP.GET_AS_NUM('USER_UNP','MASTER','GU12')=1 THEN 2641
		  ELSE B.PLAT_ID
	   END)=2641
)
GROUP BY PROD
         ,PLAT
	     ,NOM_Z
	     ,STAN
	     ,DATE_O
ORDER BY PROD
         ,PLAT
	     ,NOM_Z
	     ,STAN
	     ,DATE_O
)
WHERE NOT (KOL_PLAN=0 AND VES_PLAN=0 AND KOL_FAKT=0 AND VES_FAKT=0);


