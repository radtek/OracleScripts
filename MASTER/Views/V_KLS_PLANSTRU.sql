--
-- V_KLS_PLANSTRU  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_KLS_PLANSTRU
(ID, BEGIN_DATE, END_DATE, NAME, LEVEL_POS, 
 INPUT_DATE, KOD_SGR, KOD_SPG, KOD_RZD, KOD_PRZ, 
 KOD_GRP, KOD_PGR, PARENT_ID, NAZN_OTG_ID, VIEW_LEVEL, 
 REGION_ID, ORG_KIND_ID, TIP_REAL_ID, FOR_ID, FOR_NAME, 
 FOR_MOS_ID, SPF_GROUP_ORDER, SPF_GROUP_NAME, SPF_ORDER, SPF_NAME, 
 LUKOIL_ID, VIEW_PARENT_ID, IS_SNP, IS_EXP, IS_RESURS, 
 IS_TO_HRAN, POS_PREDPR_ID)
AS 
SELECT
  ID,
  BEGIN_DATE,
  END_DATE,
  NAME,
  LEVEL_POS,
  INPUT_DATE,
  KOD_SGR,
  KOD_SPG,
  KOD_RZD,
  KOD_PRZ,
  KOD_GRP,
  KOD_PGR,
  PARENT_ID,
  NAZN_OTG_ID,
  VIEW_LEVEL,
  REGION_ID,
  ORG_KIND_ID,
  TIP_REAL_ID,
  FOR_ID,
  FOR_NAME,
  FOR_MOS_ID,
  SPF_GROUP_ORDER, SPF_GROUP_NAME, SPF_ORDER, SPF_NAME, LUKOIL_ID,
  (
    SELECT B.ID FROM KLS_PLANSTRU B
	WHERE B.KOD_SGR=A.KOD_SGR
	  AND B.KOD_SPG=A.KOD_SPG*DECODE(SIGN(A.VIEW_LEVEL-1),1,1,0)
	  AND B.KOD_RZD=A.KOD_RZD*DECODE(SIGN(A.VIEW_LEVEL-2),1,1,0)
	  AND B.KOD_PRZ=A.KOD_PRZ*DECODE(SIGN(A.VIEW_LEVEL-3),1,1,0)
	  AND B.KOD_GRP=A.KOD_GRP*DECODE(SIGN(A.VIEW_LEVEL-4),1,1,0)
	  AND B.KOD_PGR=A.KOD_PGR*DECODE(SIGN(A.VIEW_LEVEL-5),1,1,0)
  ) as VIEW_PARENT_ID,
  DECODE(KOD_SGR,31,DECODE(KOD_SPG,10,DECODE(KOD_RZD,65,DECODE(KOD_PRZ,0,0,1),0),0),0) as IS_SNP,
  DECODE(KOD_SGR,21,1,0) as IS_EXP,
  IS_RESURS,
  IS_TO_HRAN,POS_PREDPR_ID
FROM KLS_PLANSTRU A;

