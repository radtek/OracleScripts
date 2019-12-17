--
-- RENEW_OSTAT_KONS  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Ostat_Kons (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

UPDATE load_buffer.ostat SET kod_ob=44 WHERE kod_ob=2033;
UPDATE load_buffer.ostat SET kod_ob=7001 WHERE kod_ob=12001;
UPDATE load_buffer.ostat SET kod_ob=7002 WHERE kod_ob=12002;
UPDATE load_buffer.ostat SET kod_ob=2007 WHERE kod_ob=12007;
UPDATE load_buffer.ostat SET kod_ob=2008 WHERE kod_ob=12008;
UPDATE load_buffer.ostat SET kod_ob=1024 WHERE kod_ob=1091;
UPDATE load_buffer.ostat SET kod_ob=1035 WHERE kod_ob=1092;
UPDATE load_buffer.ostat SET kod_ob=9020 WHERE kod_ob=9071;
UPDATE load_buffer.ostat SET kod_ob=9021 WHERE kod_ob=9072;
UPDATE load_buffer.ostat SET kod_ob=9022 WHERE kod_ob=9073;
UPDATE load_buffer.ostat SET kod_ob=9023 WHERE kod_ob=9074;
UPDATE load_buffer.ostat SET kod_ob=9004 WHERE kod_ob=9075;
UPDATE load_buffer.ostat SET kod_ob=1022 WHERE kod_ob=11022;
UPDATE load_buffer.ostat SET kod_ob=1029 WHERE kod_ob=11029;
UPDATE load_buffer.ostat SET kod_ob=1034 WHERE kod_ob=11034;
UPDATE load_buffer.ostat SET kod_ob=1036 WHERE kod_ob=11036;
UPDATE load_buffer.ostat SET kod_ob=1044 WHERE kod_ob=11044;
UPDATE load_buffer.ostat SET kod_ob=1046 WHERE kod_ob=11046;
UPDATE load_buffer.ostat SET kod_ob=1083 WHERE kod_ob=11083;
UPDATE load_buffer.ostat SET kod_ob=1080 WHERE kod_ob=11084;
UPDATE load_buffer.ostat SET kod_ob=9021 WHERE kod_ob=9080;
UPDATE load_buffer.ostat SET kod_ob=9080 WHERE kod_ob=13002;
UPDATE load_buffer.ostat SET kod_ob=9076 WHERE kod_ob=13001;

UPDATE OSTAT_KONS SET
  (DATE_OST, KOL, KG, LIT, SUMMA_POKUP_BN, SUMMA_POKUP_NDS, SUMMA_POKUP_AKCIZ, SUMMA_POKUP, 
   SUMMA_UCHET, ORG_STRU_ID, PREDPR_KONS_ID, PROD_KONS_ID)
 = (
  SELECT A.DA, NVL(A.KOL,0), NVL(A.KG,0), 0, 
      NVL(A.S_POK_BN,0), NVL(A.S_POK,0)-NVL(A.S_POK_BN,0),0,NVL(A.S_POK,0),
   NVL(A.S_UCH,0),
   A.KOD_OB,TO_NUMBER(A.POST_INN),A.KOD_PROD
    FROM load_buffer.Ostat A, ORG_STRUCTURE B
    WHERE A.nom_ost=OSTAT_KONS.ID_OST AND A.KOD_FIL=B.FILIAL AND B.ID=OSTAT_KONS.FILIAL_ID
  )
WHERE EXISTS (SELECT NULL FROM load_buffer.Ostat A, ORG_STRUCTURE B
    WHERE A.nom_ost=OSTAT_KONS.ID_OST AND A.KOD_FIL=B.FILIAL AND B.ID=OSTAT_KONS.FILIAL_ID);

COMMIT;

INSERT  INTO OSTAT_KONS
  (FILIAL_ID, ID_OST, DATE_OST, KOL, KG, LIT, SUMMA_POKUP_BN, SUMMA_POKUP_NDS, 
   SUMMA_POKUP_AKCIZ, SUMMA_POKUP, SUMMA_UCHET, ORG_STRU_ID, PREDPR_KONS_ID, PROD_KONS_ID)
 (SELECT B.ID,A.nom_ost,A.DA, NVL(A.KOL,0), NVL(A.KG,0), 0, 
      NVL(A.S_POK_BN,0), NVL(A.S_POK,0)-NVL(A.S_POK_BN,0),0,NVL(A.S_POK,0),
   NVL(A.S_UCH,0),
   A.KOD_OB,TO_NUMBER(A.POST_INN),A.KOD_PROD
    FROM load_buffer.Ostat A, ORG_STRUCTURE B
    WHERE A.kod_fil=B.FILIAL 
   AND NOT EXISTS (SELECT NULL FROM OSTAT_KONS C WHERE C.ID_OST=A.nom_ost AND C.FILIAL_ID=B.ID));

COMMIT;

DELETE FROM OSTAT_KONS A WHERE 
    NOT EXISTS (SELECT NULL FROM load_buffer.ostat k,ORG_STRUCTURE B WHERE k.nom_ost = A.ID_OST AND k.kod_fil=B.FILIAL AND b.ID=A.FILIAL_ID)
    AND A.DATE_OST BETWEEN date_beg AND date_end;

COMMIT;

END Renew_Ostat_Kons; 
/

