--
-- V_DOG  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_DOG
(DOG_ID, DOG_NUMBER, PLAT_ID, PLAT_NAME, GOSPROG_ID, 
 USL_OPL_ID, KOL_DN, MAIN_IS_AGENT, MAIN_DOG_ID, MAIN_DOG_NUMBER, 
 LUK_DOG_ID, LUK_DOG_NUMBER)
AS 
SELECT /*+ ORDERED USE_NL (KLS_PREDPR) */
  KLS_DOG.ID AS DOG_ID,
  KLS_DOG.DOG_NUMBER,
  KLS_DOG.PREDPR_ID AS PLAT_ID,
  KLS_PREDPR.PREDPR_NAME AS PLAT_NAME,
  NVL(KLS_DOG.GOSPROG_ID,0) AS GOSPROG_ID,
  NVL(KLS_DOG.USL_OPL_ID,0) AS USL_OPL_ID,
  NVL(KLS_USL_OPL.KOL_DN,0) AS KOL_DN,
  NVL(MAIN_DOG.IS_AGENT,3) AS MAIN_IS_AGENT,
  NVL(KLS_DOG.MAINDOG_ID,0) AS MAIN_DOG_ID,
  NVL(MAIN_DOG.DOG_NUMBER,'') AS MAIN_DOG_NUMBER,
  NVL(KLS_DOG.LUKDOG_ID,0) AS LUK_DOG_ID,
  NVL(LUK_DOG.DOG_NUMBER,'') AS LUK_DOG_NUMBER
FROM KLS_DOG,KLS_DOG LUK_DOG,KLS_DOG MAIN_DOG,KLS_USL_OPL,KLS_PREDPR
WHERE KLS_DOG.PREDPR_ID=KLS_PREDPR.ID
  AND KLS_DOG.USL_OPL_ID=KLS_USL_OPL.ID(+)
  AND KLS_DOG.MAINDOG_ID=MAIN_DOG.ID(+)
  AND KLS_DOG.LUKDOG_ID=LUK_DOG.ID(+);


