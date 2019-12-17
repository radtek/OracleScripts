--
-- RENEW_OBOROT_KONS  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Oborot_Kons (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

UPDATE load_buffer.oborot SET st_prich=NULL WHERE st_prich=99;
UPDATE load_buffer.oborot SET st_ras=NULL WHERE st_ras=99;
UPDATE load_buffer.oborot SET tip_real=NULL WHERE tip_real=99;
UPDATE load_buffer.oborot SET vid_post=NULL WHERE vid_post=99;
UPDATE load_buffer.oborot SET vid_real=NULL WHERE vid_real=99;
UPDATE load_buffer.oborot SET otgr_post=NULL WHERE otgr_post=0;
UPDATE load_buffer.oborot SET nom_ob=(TO_NUMBER(TO_CHAR(DA,'YYYY'))*100000000+nom_ob);

UPDATE load_buffer.oborot SET kod_ob=44 WHERE kod_ob=2033;
UPDATE load_buffer.oborot SET kod_ob=7001 WHERE kod_ob=12001;
UPDATE load_buffer.oborot SET kod_ob=7002 WHERE kod_ob=12002;
UPDATE load_buffer.oborot SET kod_ob=2007 WHERE kod_ob=12007;
UPDATE load_buffer.oborot SET kod_ob=2008 WHERE kod_ob=12008;
UPDATE load_buffer.oborot SET kod_ob=1024 WHERE kod_ob=1091;
UPDATE load_buffer.oborot SET kod_ob=1035 WHERE kod_ob=1092;
UPDATE load_buffer.oborot SET kod_ob=9020 WHERE kod_ob=9071;
UPDATE load_buffer.oborot SET kod_ob=9021 WHERE kod_ob=9072;
UPDATE load_buffer.oborot SET kod_ob=9022 WHERE kod_ob=9073;
UPDATE load_buffer.oborot SET kod_ob=9023 WHERE kod_ob=9074;
UPDATE load_buffer.oborot SET kod_ob=9004 WHERE kod_ob=9075;
UPDATE load_buffer.oborot SET kod_ob=1022 WHERE kod_ob=11022;
UPDATE load_buffer.oborot SET kod_ob=1029 WHERE kod_ob=11029;
UPDATE load_buffer.oborot SET kod_ob=1034 WHERE kod_ob=11034;
UPDATE load_buffer.oborot SET kod_ob=1036 WHERE kod_ob=11036;
UPDATE load_buffer.oborot SET kod_ob=1044 WHERE kod_ob=11044;
UPDATE load_buffer.oborot SET kod_ob=1046 WHERE kod_ob=11046;
UPDATE load_buffer.oborot SET kod_ob=1083 WHERE kod_ob=11083;
UPDATE load_buffer.oborot SET kod_ob=1080 WHERE kod_ob=11084;
UPDATE load_buffer.oborot SET kod_ob=9021 WHERE kod_ob=9080;
UPDATE load_buffer.oborot SET kod_ob=9080 WHERE kod_ob=13002;
UPDATE load_buffer.oborot SET kod_ob=9076 WHERE kod_ob=13001;

UPDATE load_buffer.oborot SET ob_pp=44 WHERE ob_pp=2033;
UPDATE load_buffer.oborot SET ob_pp=7001 WHERE ob_pp=12001;
UPDATE load_buffer.oborot SET ob_pp=7002 WHERE ob_pp=12002;
UPDATE load_buffer.oborot SET ob_pp=2007 WHERE ob_pp=12007;
UPDATE load_buffer.oborot SET ob_pp=2008 WHERE ob_pp=12008;
UPDATE load_buffer.oborot SET ob_pp=1024 WHERE ob_pp=1091;
UPDATE load_buffer.oborot SET ob_pp=1035 WHERE ob_pp=1092;
UPDATE load_buffer.oborot SET ob_pp=9020 WHERE ob_pp=9071;
UPDATE load_buffer.oborot SET ob_pp=9021 WHERE ob_pp=9072;
UPDATE load_buffer.oborot SET ob_pp=9022 WHERE ob_pp=9073;
UPDATE load_buffer.oborot SET ob_pp=9023 WHERE ob_pp=9074;
UPDATE load_buffer.oborot SET ob_pp=9004 WHERE ob_pp=9075;
UPDATE load_buffer.oborot SET ob_pp=1022 WHERE ob_pp=11022;
UPDATE load_buffer.oborot SET ob_pp=1029 WHERE ob_pp=11029;
UPDATE load_buffer.oborot SET ob_pp=1034 WHERE ob_pp=11034;
UPDATE load_buffer.oborot SET ob_pp=1036 WHERE ob_pp=11036;
UPDATE load_buffer.oborot SET ob_pp=1044 WHERE ob_pp=11044;
UPDATE load_buffer.oborot SET ob_pp=1046 WHERE ob_pp=11046;
UPDATE load_buffer.oborot SET ob_pp=1083 WHERE ob_pp=11083;
UPDATE load_buffer.oborot SET ob_pp=1080 WHERE ob_pp=11084;
UPDATE load_buffer.oborot SET ob_pp=9021 WHERE ob_pp=9080;
UPDATE load_buffer.oborot SET ob_pp=9080 WHERE ob_pp=13002;
UPDATE load_buffer.oborot SET ob_pp=9076 WHERE ob_pp=13001;

COMMIT;
  
UPDATE OBOROT_KONS SET
  (DATE_OPER, KOL, KG, LIT, 
   SUMMA_POKUP_BN, SUMMA_POKUP_NDS, SUMMA_POKUP_AKCIZ, SUMMA_POKUP, 
   SUMMA_REALIZ_BN,SUMMA_REALIZ_NDS, SUMMA_REALIZ_AKCIZ, SUMMA_REALIZ, 
   SUMMA_UCHET, UPDATE_USER, UPDATE_DATE, AKCIZ_SVED, 
   ORG_STRU_ID, PREDPR_KONS_ID, PROD_KONS_ID,  PREDPR_CLASS_ID, 
   TIP_OP_ID, ST_PRIH_ID, ST_RASH_ID, TIP_REAL_ID, VID_REAL_ID, 
   VID_POST_ID, OTGR_POST_ID, LOAD_TYPE_ID, REGION_ID,ORG_POLUCH_ID)
 = (
  SELECT A.DA, NVL(A.KOL,0), NVL(A.KG,0), NVL(A.LIT,0), 
      NVL(A.S_POK_BN,0), NVL(A.S_POK,0)-NVL(A.S_POK_BN,0),0,NVL(A.S_POK,0),
      NVL(A.S_REAL_BN,0), NVL(A.S_REAL,0)-NVL(A.S_REAL_BN,0),0,NVL(A.S_REAL,0),
	  NVL(A.S_UCH,0),N_USER, NVL(A.DT,A.DA),NVL(A.SVID,0),
	  A.KOD_OB,TO_NUMBER(A.POST_INN),A.KOD_PROD,TO_NUMBER(A.GR_POT),
	  A.TIP_OP,A.ST_PRICH,A.ST_RAS,A.TIP_REAL,A.VID_REAL,
  	  A.VID_POST,A.OTGR_POST,Get_Tip_Otgr(NVL(A.VID_TR,0)),Get_Region(NVL(A.Kod_ter,0)),C.ID
    FROM load_buffer.Oborot A, ORG_STRUCTURE B, ORG_STRUCTURE C
    WHERE A.nom_ob=OBOROT_KONS.ID_OPER AND A.kod_fil=B.FILIAL AND A.fil_pp=C.FILIAL AND B.ID=OBOROT_KONS.FILIAL_ID 
		)
WHERE EXISTS (SELECT NULL FROM load_buffer.Oborot A, ORG_STRUCTURE B, ORG_STRUCTURE C
    WHERE A.nom_ob=OBOROT_KONS.ID_OPER AND A.kod_fil=B.FILIAL AND A.fil_pp=C.FILIAL AND B.ID=OBOROT_KONS.FILIAL_ID);

COMMIT;


INSERT INTO OBOROT_KONS
  (FILIAL_ID,ID_OPER,DATE_OPER, KOL, KG, LIT, 
   SUMMA_POKUP_BN, SUMMA_POKUP_NDS, SUMMA_POKUP_AKCIZ, SUMMA_POKUP, 
   SUMMA_REALIZ_BN,SUMMA_REALIZ_NDS, SUMMA_REALIZ_AKCIZ, SUMMA_REALIZ, 
   SUMMA_UCHET, UPDATE_USER, UPDATE_DATE, AKCIZ_SVED, 
   ORG_STRU_ID, PREDPR_KONS_ID, PROD_KONS_ID,  PREDPR_CLASS_ID, 
   TIP_OP_ID, ST_PRIH_ID, ST_RASH_ID, TIP_REAL_ID, VID_REAL_ID, 
   VID_POST_ID, OTGR_POST_ID, LOAD_TYPE_ID, REGION_ID, ORG_POLUCH_ID)
 (SELECT B.ID,A.nom_ob,A.DA, NVL(A.KOL,0), NVL(A.KG,0), NVL(A.LIT,0), 
      NVL(A.S_POK_BN,0), NVL(A.S_POK,0)-NVL(A.S_POK_BN,0),0,NVL(A.S_POK,0),
      NVL(A.S_REAL_BN,0), NVL(A.S_REAL,0)-NVL(A.S_REAL_BN,0),0,NVL(A.S_REAL,0),
	  NVL(A.S_UCH,0),N_USER, NVL(A.DT,A.DA),NVL(A.SVID,0),
	  A.KOD_OB,TO_NUMBER(A.POST_INN),A.KOD_PROD,TO_NUMBER(A.GR_POT),
	  A.TIP_OP,A.ST_PRICH,A.ST_RAS,A.TIP_REAL,A.VID_REAL,
  	  A.VID_POST,A.OTGR_POST,Get_Tip_Otgr(NVL(A.VID_TR,0)),Get_Region(NVL(A.Kod_ter,0)),C.ID
    FROM load_buffer.Oborot A, ORG_STRUCTURE B, ORG_STRUCTURE C
    WHERE A.kod_fil=B.FILIAL AND A.fil_pp=C.FILIAL
	  AND NOT EXISTS (SELECT NULL FROM OBOROT_KONS E WHERE E.ID_OPER=A.nom_ob AND E.FILIAL_ID=B.ID));

COMMIT;

DELETE FROM OBOROT_KONS A WHERE  
    NOT EXISTS (SELECT NULL FROM load_buffer.oborot k,ORG_STRUCTURE B WHERE k.nom_ob = A.ID_OPER AND k.kod_fil=B.FILIAL AND B.ID=A.FILIAL_ID)
    AND A.DATE_OPER BETWEEN date_beg AND date_end;

COMMIT;

END Renew_Oborot_Kons; 
/

