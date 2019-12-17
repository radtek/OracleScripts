--
-- RENEW_BILLS_SNP  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_BILLS_SNP (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') AS
  IsFull NUMBER(1);
  v_new kls_dog%ROWTYPE;
BEGIN

  IF param1 || ' ' = ' ' THEN
    IsFull:=1;
  ELSE
    IsFull:=0;
  END IF;

-- Обновление счетов 
  UPDATE bills_snp
    set (IS_AGENT,NOM_SF,NPO_SF,DATE_VYP_SF,DATE_BUXG,DATE_KVIT,SUMMA_DOK,
         NDS_DOK,AKCIZ_DOK,GSM_DOK,KOL_DN,FIO_ISPOL,PRIM,OLD_NOM_DOK,
         NOM_ZD,USL_NUMBER,OWNER_ID,DOG_ID,PROD_ID_NPR,DATE_MOS,OLD_NOM_SF,CAT_CEN_ID) =
	(SELECT A.IS_AGENT,A.NOM_SF,A.NPO_SF,A.DATE_VYP_SF,A.DATE_BUXG,A.DATE_KVIT,A.SUMMA_DOK,
            A.NDS_DOK,A.AKCIZ_DOK,A.GSM_DOK,A.KOL_DN,A.FIO_ISPOL,A.PRIM,A.OLD_NOM_DOK,
            A.NOM_ZD,A.USL_NUMBER,A.OWNER_ID,A.DOG_ID,A.PROD_ID_NPR,A.DATE_MOS,A.OLD_NOM_SF,NVL(B.CAT_CEN_ID,0)
       FROM master.bills A, master.USL_DOG B 
	  WHERE A.nom_dok=bills_snp.nom_dok
	    AND A.DOG_ID = B.DOG_ID (+)
		AND A.USL_NUMBER = B.USL_NUMBER (+))
    where exists (SELECT nom_dok FROM master.bills B WHERE B.nom_dok=bills_snp.nom_dok);
  COMMIT;

-- Добавление счетов   
  INSERT INTO bills_snp
    (NOM_DOK,IS_AGENT,NOM_SF,NPO_SF,DATE_VYP_SF,DATE_BUXG,DATE_KVIT,SUMMA_DOK,
         NDS_DOK,AKCIZ_DOK,GSM_DOK,KOL_DN,FIO_ISPOL,PRIM,OLD_NOM_DOK,
         NOM_ZD,USL_NUMBER,OWNER_ID,DOG_ID,PROD_ID_NPR,DATE_MOS,OLD_NOM_SF,CAT_CEN_ID)
	SELECT A.nom_dok,A.IS_AGENT,A.NOM_SF,A.NPO_SF,A.DATE_VYP_SF,A.DATE_BUXG,A.DATE_KVIT,A.SUMMA_DOK,
           A.NDS_DOK,A.AKCIZ_DOK,A.GSM_DOK,A.KOL_DN,A.FIO_ISPOL,A.PRIM,A.OLD_NOM_DOK,
           A.NOM_ZD,A.USL_NUMBER,A.OWNER_ID,A.DOG_ID,A.PROD_ID_NPR,A.DATE_MOS,A.OLD_NOM_SF,NVL(B.CAT_CEN_ID,0) 
     FROM master.bills A, master.USL_DOG B
	WHERE A.DOG_ID = B.DOG_ID (+)
  	  AND A.USL_NUMBER = B.USL_NUMBER (+)
      AND not exists (SELECT nom_dok FROM bills_snp C WHERE A.nom_dok=C.nom_dok);
	  
  COMMIT;

  -- Обновление реквизитов из заявок
  FOR_BILLS.FIELDS$BILLS_SNP(DATE_BEG,DATE_END,param1,param2,param3);  
  
-- Обновление позиций счетов  
  RENEW_BILL_POS_SNP(DATE_BEG,DATE_END,PARAM1,PARAM2,PARAM3);

-- Удаление счетов  
  IF IsFull=1 THEN
    DELETE FROM bills_snp WHERE not exists
      (SELECT nom_dok FROM master.bills a WHERE a.nom_dok=bills_snp.nom_dok);
  ELSE
    DELETE FROM bills_snp WHERE not exists
      (SELECT nom_dok FROM master.bills a WHERE a.nom_dok=bills_snp.nom_dok)
	  AND bills_snp.DATE_BUXG BETWEEN date_beg AND date_end;
  END IF;

  COMMIT;

END RENEW_BILLS_SNP;

/

