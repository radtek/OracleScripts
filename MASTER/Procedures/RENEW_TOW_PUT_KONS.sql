--
-- RENEW_TOW_PUT_KONS  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Tow_Put_Kons (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

UPDATE load_buffer.tow_put SET kod_ob=44 WHERE kod_ob=2033;
UPDATE load_buffer.tow_put SET kod_ob=7001 WHERE kod_ob=12001;
UPDATE load_buffer.tow_put SET kod_ob=7002 WHERE kod_ob=12002;
UPDATE load_buffer.tow_put SET kod_ob=2007 WHERE kod_ob=12007;
UPDATE load_buffer.tow_put SET kod_ob=2008 WHERE kod_ob=12008;
UPDATE load_buffer.tow_put SET kod_ob=1024 WHERE kod_ob=1091;
UPDATE load_buffer.tow_put SET kod_ob=1035 WHERE kod_ob=1092;
UPDATE load_buffer.tow_put SET kod_ob=9020 WHERE kod_ob=9071;
UPDATE load_buffer.tow_put SET kod_ob=9021 WHERE kod_ob=9072;
UPDATE load_buffer.tow_put SET kod_ob=9022 WHERE kod_ob=9073;
UPDATE load_buffer.tow_put SET kod_ob=9023 WHERE kod_ob=9074;
UPDATE load_buffer.tow_put SET kod_ob=9004 WHERE kod_ob=9075;
UPDATE load_buffer.tow_put SET kod_ob=1022 WHERE kod_ob=11022;
UPDATE load_buffer.tow_put SET kod_ob=1029 WHERE kod_ob=11029;
UPDATE load_buffer.tow_put SET kod_ob=1034 WHERE kod_ob=11034;
UPDATE load_buffer.tow_put SET kod_ob=1036 WHERE kod_ob=11036;
UPDATE load_buffer.tow_put SET kod_ob=1044 WHERE kod_ob=11044;
UPDATE load_buffer.tow_put SET kod_ob=1046 WHERE kod_ob=11046;
UPDATE load_buffer.tow_put SET kod_ob=1083 WHERE kod_ob=11083;
UPDATE load_buffer.tow_put SET kod_ob=1080 WHERE kod_ob=11084;
UPDATE load_buffer.tow_put SET kod_ob=9021 WHERE kod_ob=9080;
UPDATE load_buffer.tow_put SET kod_ob=9080 WHERE kod_ob=13002;
UPDATE load_buffer.tow_put SET kod_ob=9076 WHERE kod_ob=13001;


UPDATE TOW_PUT_KONS TP SET
  (DATE_OPER, KOL_1, KG_1, SUMMA_POK_BN_1, SUMMA_POK_NDS_1, 
   SUMMA_POK_AKCIZ_1, SUMMA_POK_1, KOL_2, KG_2, SUMMA_POK_BN_2, 
   SUMMA_POK_NDS_2, SUMMA_POK_AKCIZ_2, SUMMA_POK_2, ORG_STRU_ID, PREDPR_KONS_ID, 
   PROD_KONS_ID, LOAD_TYPE_ID, ORG_POLUCH_ID)
 = (
  SELECT A.DA, NVL(A.KOL1,0), NVL(A.KG1,0),  
      NVL(A.S_POK_BN1,0), NVL(A.S_POK1,0)-NVL(A.S_POK_BN1,0),0,NVL(A.S_POK1,0),
      NVL(A.KOL2,0), NVL(A.KG2,0),
      NVL(A.S_POK_BN2,0), NVL(A.S_POK2,0)-NVL(A.S_POK_BN2,0),0,NVL(A.S_POK2,0),
  	  A.KOD_OB,TO_NUMBER(A.POST_INN),A.KOD_PROD,Get_Tip_Otgr(NVL(A.VID_TR,0)),C.ID
    FROM load_buffer.Tow_Put A, ORG_STRUCTURE B, ORG_STRUCTURE C
    WHERE A.KOD_FIL=B.FILIAL AND A.FIL_PP=C.FILIAL 
	  AND A.nom_tw=TP.ID_OPER 
	  AND B.ID=TP.FILIAL_ID 
		)
WHERE EXISTS (SELECT NULL FROM load_buffer.Tow_Put A, ORG_STRUCTURE B, ORG_STRUCTURE C
    WHERE A.KOD_FIL=B.FILIAL AND A.FIL_PP=C.FILIAL 
	  AND A.nom_tw=TP.ID_OPER AND B.ID=TP.FILIAL_ID);

COMMIT;

INSERT  INTO TOW_PUT_KONS
  (FILIAL_ID,ID_OPER,DATE_OPER, KOL_1, KG_1, SUMMA_POK_BN_1, SUMMA_POK_NDS_1, 
   SUMMA_POK_AKCIZ_1, SUMMA_POK_1, KOL_2, KG_2, SUMMA_POK_BN_2, 
   SUMMA_POK_NDS_2, SUMMA_POK_AKCIZ_2, SUMMA_POK_2, ORG_STRU_ID, PREDPR_KONS_ID, 
   PROD_KONS_ID, LOAD_TYPE_ID, ORG_POLUCH_ID)
 (SELECT B.ID,A.nom_tw,A.DA, NVL(A.KOL1,0), NVL(A.KG1,0),  
      NVL(A.S_POK_BN1,0), NVL(A.S_POK1,0)-NVL(A.S_POK_BN1,0),0,NVL(A.S_POK1,0),
      NVL(A.KOL2,0), NVL(A.KG2,0),
      NVL(A.S_POK_BN2,0), NVL(A.S_POK2,0)-NVL(A.S_POK_BN2,0),0,NVL(A.S_POK2,0),
  	  A.KOD_OB,TO_NUMBER(A.POST_INN),A.KOD_PROD,Get_Tip_Otgr(NVL(A.VID_TR,0)), C.ID
    FROM load_buffer.Tow_Put A, ORG_STRUCTURE B, ORG_STRUCTURE C
    WHERE A.KOD_FIL=B.FILIAL AND A.FIL_PP=C.FILIAL 
	  AND NOT EXISTS (SELECT NULL FROM TOW_PUT_KONS E WHERE E.ID_OPER=A.nom_tw AND E.FILIAL_ID=B.ID));

COMMIT;

DELETE FROM TOW_PUT_KONS A WHERE 
    NOT EXISTS (SELECT NULL FROM load_buffer.tow_put k, ORG_STRUCTURE B WHERE k.nom_tw = A.ID_OPER AND k.kod_fil=B.filial AND B.ID = A.FILIAL_ID)
    AND A.DATE_OPER BETWEEN date_beg AND date_end;

COMMIT;

END Renew_Tow_Put_Kons; 
/

