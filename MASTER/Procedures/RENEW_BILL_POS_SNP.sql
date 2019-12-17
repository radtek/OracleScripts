--
-- RENEW_BILL_POS_SNP  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_BILL_POS_SNP (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') AS
 IsFull NUMBER(1);
BEGIN

  IF param1 || ' ' = ' ' THEN
    IsFull:=1;
  ELSE
    IsFull:=0;
  END IF;

--- Обновление позиций счетов
  UPDATE bill_pos_snp
    set (IS_AGENT, PROD_ID_NPR, VES, CENA_BN,
         CENA, SUMMA_BN, SUMMA_NDS20, SUMMA_AKCIZ,
         SUMMA_GSM25, SUMMA, CENA_POKUP, SUMMA_BN_POKUP,SUMMA_NDS20_POKUP,
		 SUMMA_GSM25_POKUP, OWNERSHIP_ID, DATE_REALIZ,ID_OLD,NPR_PRICES_ID) =
	(SELECT IS_AGENT, PROD_ID_NPR, VES, CENA_BN,
            CENA, SUMMA_BN, SUMMA_NDS20, SUMMA_AKCIZ,
            SUMMA_GSM25, SUMMA, CENA_POKUP, SUMMA_BN_POKUP,SUMMA_NDS20_POKUP,
		    SUMMA_GSM25_POKUP, OWNERSHIP_ID, DATE_REALIZ,ID_OLD,0
		 FROM master.bill_pos A 
		 WHERE A.nom_dok=bill_pos_snp.nom_dok 
		   AND a.bill_pos_id=bill_pos_snp.BILL_POS_SNP_ID)
    where exists (SELECT nom_dok FROM master.bill_pos B
	  WHERE B.nom_dok=bill_pos_snp.nom_dok AND b.bill_pos_id=bill_pos_snp.BILL_POS_SNP_ID);
--  COMMIT;

-- Добавляем позиции счетов  
  INSERT INTO bill_pos_snp
    (NOM_DOK,BILL_POS_SNP_ID, IS_AGENT, PROD_ID_NPR, KVIT_VES, VES, CENA_BN,
         CENA, SUMMA_BN, SUMMA_NDS20, SUMMA_AKCIZ,
         SUMMA_GSM25, SUMMA, CENA_POKUP, SUMMA_BN_POKUP,SUMMA_NDS20_POKUP,
		 SUMMA_GSM25_POKUP, OWNERSHIP_ID, DATE_REALIZ,ID_OLD,NPR_PRICES_ID)
	(SELECT NOM_DOK,BILL_POS_ID, IS_AGENT, PROD_ID_NPR, 0, VES, CENA_BN,
         CENA, SUMMA_BN, SUMMA_NDS20, SUMMA_AKCIZ,
         SUMMA_GSM25, SUMMA, CENA_POKUP, SUMMA_BN_POKUP,SUMMA_NDS20_POKUP,
		 SUMMA_GSM25_POKUP, OWNERSHIP_ID, DATE_REALIZ,ID_OLD,0
	 FROM master.bill_pos A
     WHERE not exists (SELECT nom_dok FROM bill_pos_snp C WHERE A.nom_dok=C.nom_dok AND a.bill_pos_id=c.BILL_POS_SNP_ID) );

  -- Обновление позиций - отгрузка
  -- Проставление сумм и цен 
  FOR_BILLS.FIELDS$BILL_POS_SNP(DATE_BEG,DATE_END,param1,param2,param3);  

  -- Обновление сумм счетов 
  UPDATE bills_snp
    set (SUMMA_DOK,NDS_DOK,AKCIZ_DOK,GSM_DOK) =
	(SELECT SUM(A.SUMMA),SUM(SUMMA_NDS20),SUM(SUMMA_AKCIZ),SUM(A.SUMMA_GSM25)
       FROM master.bill_pos_snp A 
	  WHERE A.nom_dok=bills_snp.nom_dok
	  GROUP BY A.nom_dok)
    where exists (SELECT nom_dok FROM master.bill_pos_snp B WHERE B.nom_dok=bills_snp.nom_dok);
  COMMIT;
  
  -- Удаление позиций  
  IF IsFull=1 THEN
    DELETE FROM bill_pos_snp WHERE not exists
      (SELECT nom_dok FROM master.bills a WHERE a.nom_dok=bill_pos_snp.nom_dok);
	COMMIT;
    DELETE FROM bill_pos_snp WHERE not exists
      (SELECT nom_dok FROM master.bill_pos a WHERE a.NOM_DOK=bill_pos_snp.nom_dok AND a.bill_pos_id=bill_pos_snp.BILL_POS_SNP_ID);
	COMMIT;
  ELSE
    DELETE FROM bill_pos_snp WHERE not exists
      (SELECT nom_dok FROM master.bills a WHERE a.nom_dok=bill_pos_snp.nom_dok)
	  AND bill_pos_snp.DATE_REALIZ BETWEEN date_beg AND date_end;
	COMMIT;
    DELETE FROM bill_pos_snp WHERE not exists
      (SELECT nom_dok FROM master.bill_pos a WHERE a.NOM_DOK=bill_pos_snp.nom_dok AND a.bill_pos_id=bill_pos_snp.BILL_POS_SNP_ID)
	  AND bill_pos_snp.DATE_REALIZ BETWEEN date_beg AND date_end;
	COMMIT;
  END IF;

  COMMIT;

END RENEW_BILL_POS_SNP;

/

