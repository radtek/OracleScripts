--
-- RENEW_BILL_POS  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Bill_Pos (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='', no_commit INTEGER DEFAULT 0) IS

CURSOR temp IS
 SELECT old_nom,nom_dok FROM load_buffer.TO_SS ORDER BY 1,2;
CURSOR temp2 IS
 SELECT nom_sf,nom_dok,k_dokum FROM load_buffer.sf_pr ORDER BY 1,2,3;
CURSOR temp3 IS
 SELECT DISTINCT A.nom_dok,B.prod_id_npr 
 FROM v_kvit_all B,load_buffer.out_plat A
 WHERE A.nom_dok=B.bill_id 
   AND A.kod_nfp='10080'
 ORDER BY 1,2;

 dest temp%ROWTYPE;
 dest2 temp2%ROWTYPE;
 dest3 temp3%ROWTYPE;
 num_pos NUMBER(1);
 IsFull NUMBER(1);
 last_old_nom NUMBER(7);
 last_nom_sf NUMBER(7);
 last_nom NUMBER;
  v_dat DATE;
 
BEGIN
  return;
  IF param1 || ' ' = ' ' THEN
    IsFull:=1;
  ELSE
    IsFull:=0;
  END IF;

    -- Определение архивной даты  
  BEGIN
    SELECT ARH_DATE.LAST_DATE INTO v_dat
	  FROM ARH_DATE WHERE ARH_DATE.TABLENAME='BILLS';
  EXCEPTION 
    WHEN OTHERS THEN
	  v_dat:=TO_DATE('31.12.1899','dd.mm.yyyy');
  END;	  	    

  UPDATE load_buffer.TO_SS a
      SET old_nom=(SELECT old_nom FROM load_buffer.TO_SS b WHERE a.old_nom=b.nom_dok)
      WHERE a.old_nom IN (SELECT nom_dok FROM load_buffer.TO_SS);
--  COMMIT;

  --- Нумеруем позиции счетов по продуктц в TO_SS
  OPEN temp;
  last_old_nom:=0;
  LOOP
    FETCH temp INTO dest;
    EXIT WHEN temp%NOTFOUND;
	IF last_old_nom<>dest.old_nom THEN
      num_pos:=2;
	ELSE
	  num_pos:=num_pos+1;
	END IF;
	UPDATE load_buffer.TO_SS SET BILL_POS=num_pos WHERE nom_dok=dest.nom_dok;
	last_old_nom:=dest.old_nom;
  END LOOP;
  CLOSE temp;
--  COMMIT;

  --- Нумеруем позиции счетов по продуктц в SF_PR
  OPEN temp2;
  last_nom_sf:=0;
  LOOP
    FETCH temp2 INTO dest2;
    EXIT WHEN temp2%NOTFOUND;
	IF last_nom_sf<>dest2.nom_sf THEN
      num_pos:=0;
	ELSE
	  num_pos:=num_pos+1;
	END IF;
	UPDATE load_buffer.sf_pr SET BILL_POS=num_pos+30 WHERE nom_dok=dest2.nom_dok AND k_dokum=dest2.k_dokum;
	last_nom_sf:=dest2.nom_sf;
  END LOOP;
  CLOSE temp2;
--  COMMIT;

  --- Нумеруем позиции в счетах по продаже ЛУКОЙЛу
  OPEN temp3;
  last_nom:=0;
  LOOP
    FETCH temp3 INTO dest3;
    EXIT WHEN temp3%NOTFOUND;
	IF last_nom<>dest3.nom_dok THEN
      num_pos:=1;
	ELSE
	  num_pos:=num_pos+1;
	END IF;
	UPDATE KVIT SET BILL_POS_ID=num_pos WHERE bill_id=dest3.nom_dok and prod_id_npr=dest3.prod_id_npr;
	UPDATE DOP_KVIT SET BILL_POS_ID=num_pos WHERE bill_id=dest3.nom_dok and prod_id_npr=dest3.prod_id_npr;
	last_nom:=dest3.nom_dok;
  END LOOP;
  CLOSE temp3;
--  COMMIT;

  --- Переводим ссылки из TO_SS -> OUT_PLAT
  UPDATE load_buffer.TO_SS a SET old_nom=
    (SELECT old_nom FROM load_buffer.TO_SS b WHERE b.nom_dok=a.old_nom)
	WHERE a.old_nom IN (SELECT nom_dok FROM load_buffer.TO_SS c);
--  COMMIT;



  UPDATE BILL_POS
    SET (IS_LUK, IS_AGENT, PROD_ID_NPR, VES, CENA_BN,
         CENA, SUMMA_BN, SUMMA_NDS20, SUMMA_AKCIZ,
         SUMMA_GSM25, SUMMA, CENA_POKUP, SUMMA_BN_POKUP,SUMMA_NDS20_POKUP,
		 SUMMA_GSM25_POKUP, OWNERSHIP_ID, DATE_REALIZ,ANALIT_ID,NACENKA,NUM_AKT,PROTO_NUM,PROTO_DATE,NO_AKCIZ) =
	(SELECT DECODE(SIGN(A.bill_pos_id-10),-1,
	     -- Если позиция - продукт
		 DECODE(NVL(BILLS.OLD_NOM_DOK,0),0,1,BILLS.KORR_PROD),
		 -- Если позиция - услуги
		 (CASE
		    WHEN BILLS.DATE_KVIT<TO_DATE('01.01.2005','dd.mm.yyyy') THEN
  		       DECODE(BILLS.IS_AGENT,1,1,3,1,2,a.IS_LUK_SNP,0)
			ELSE
			   a.IS_LUK_SNP
		  END)),
	     BILLS.IS_AGENT, a.PROD_ID_NPR, a.VES, a.CENA_BN,
         a.CENA, a.SUMMA_BN, a.SUMMA_NDS20, a.SUMMA_AKCIZ,
         a.SUMMA_GSM25, a.SUMMA, a.CENA_POKUP, a.SUMMA_BN_POKUP,a.SUMMA_NDS20_POKUP,
		 a.SUMMA_GSM25_POKUP, a.OWNERSHIP_ID, a.DATE_REALIZ,A.buhanal,a.NACENKA,a.NUM_AKT,a.PROTO_NUM,a.PROTO_DATE,a.NO_AKCIZ
		 FROM load_buffer.out_plat_pos A, BILLS 
		 WHERE A.bills_nom_dok=BILL_POS.nom_dok 
		   AND A.bills_nom_dok=BILLS.nom_dok
		   AND a.bill_pos_id=BILL_POS.BILL_POS_ID)
    WHERE EXISTS (SELECT NULL FROM load_buffer.out_plat_pos B
	  WHERE B.bills_nom_dok=BILL_POS.nom_dok AND b.bill_pos_id=BILL_POS.BILL_POS_ID)
	    AND IS_POKUP=0
	    AND BILL_POS.DATE_REALIZ BETWEEN date_beg AND date_end
		AND BILL_POS.DATE_REALIZ>v_dat
	    AND NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS_NO_UPDATE);
		
  UPDATE BILL_POS
    SET (IS_LUK,IS_AGENT,PROD_ID_NPR, VES, CENA_BN,
         CENA, SUMMA_BN, SUMMA_NDS20, SUMMA_AKCIZ,
         SUMMA_GSM25, SUMMA, CENA_POKUP, SUMMA_BN_POKUP,SUMMA_NDS20_POKUP,
		 SUMMA_GSM25_POKUP, OWNERSHIP_ID, DATE_REALIZ) =
	(SELECT 1,NVL(KLS_VIDDOG.IS_AGENT,3),a.PROD_ID_NPR, a.VES, a.CENA_BN,
         a.CENA, a.SUMMA_BN, a.SUMMA_NDS20, a.SUMMA_AKCIZ,
         a.SUMMA_GSM25, a.SUMMA, a.CENA_POKUP, a.SUMMA_BN_POKUP,a.SUMMA_NDS20_POKUP,
		 a.SUMMA_GSM25_POKUP, a.OWNERSHIP_ID, a.DATE_REALIZ
		 FROM load_buffer.sf_pr_pos A, KLS_DOG, KLS_DOG LUK_DOG, KLS_VIDDOG 
		 WHERE A.bills_nom_dok=BILL_POS.nom_dok 
		   AND a.bill_pos_id=BILL_POS.BILL_POS_ID
		   AND A.NOM_DOG = KLS_DOG.SHORT_NUMBER(+) 
		   AND KLS_DOG.MAINDOG_ID=LUK_DOG.ID(+)
		   AND LUK_DOG.VIDDOG_ID = KLS_VIDDOG.ID(+) )
    WHERE EXISTS (SELECT * FROM load_buffer.sf_pr_pos B
	  WHERE B.bills_nom_dok=BILL_POS.nom_dok AND b.bill_pos_id=BILL_POS.BILL_POS_ID)
	    AND IS_POKUP=0
	    AND BILL_POS.DATE_REALIZ BETWEEN date_beg AND date_end
		AND BILL_POS.DATE_REALIZ>v_dat
   	    AND NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS_NO_UPDATE);

-- Добавляем позиции счетов  
  INSERT INTO BILL_POS
    (IS_LUK,IS_AGENT,NOM_DOK,BILL_POS_ID, PROD_ID_NPR, VES, CENA_BN,
     CENA, SUMMA_BN, SUMMA_NDS20, SUMMA_AKCIZ,SUMMA_GSM25,
	 SUMMA, CENA_POKUP, SUMMA_BN_POKUP,SUMMA_NDS20_POKUP, SUMMA_GSM25_POKUP,
	 OWNERSHIP_ID, DATE_REALIZ,ANALIT_ID,NACENKA,NUM_AKT,PROTO_NUM,PROTO_DATE,NO_AKCIZ)
	(SELECT /*+ ORDERED USE_NL(A,BILLS) */ DECODE(SIGN(A.bill_pos_id-10),-1,
	     -- Если позиция - продукт
		 DECODE(NVL(BILLS.OLD_NOM_DOK,0),0,1,BILLS.KORR_PROD),
		 -- Если позиция - услуги
		 (CASE
		    WHEN BILLS.DATE_KVIT<TO_DATE('01.01.2005','dd.mm.yyyy') THEN
  		       DECODE(BILLS.IS_AGENT,1,1,3,1,2,a.IS_LUK_SNP,0)
			ELSE
			   a.IS_LUK_SNP
		  END)),
	 BILLS.IS_AGENT,a.BILLS_NOM_DOK,a.BILL_POS_ID, a.PROD_ID_NPR, a.VES, a.CENA_BN,
     a.CENA, a.SUMMA_BN, a.SUMMA_NDS20, a.SUMMA_AKCIZ,a.SUMMA_GSM25,
	 a.SUMMA, a.CENA_POKUP, a.SUMMA_BN_POKUP,a.SUMMA_NDS20_POKUP, a.SUMMA_GSM25_POKUP,
	 a.OWNERSHIP_ID, a.DATE_REALIZ,a.buhanal,a.NACENKA,a.NUM_AKT,a.PROTO_NUM,a.PROTO_DATE,a.NO_AKCIZ 
	 FROM load_buffer.out_plat_pos A,BILLS
     WHERE NOT EXISTS (SELECT * FROM BILL_POS C WHERE A.bills_nom_dok=C.nom_dok AND a.bill_pos_id=c.BILL_POS_ID)
	   AND A.BILLS_NOM_DOK=BILLS.NOM_DOK
	   AND A.BILLS_NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS_NO_UPDATE));

--  COMMIT;

  INSERT INTO BILL_POS
    (IS_LUK,IS_AGENT,NOM_DOK,BILL_POS_ID, PROD_ID_NPR, VES, CENA_BN,
     CENA, SUMMA_BN, SUMMA_NDS20, SUMMA_AKCIZ,SUMMA_GSM25,
	 SUMMA, CENA_POKUP, SUMMA_BN_POKUP,SUMMA_NDS20_POKUP, SUMMA_GSM25_POKUP,
	 OWNERSHIP_ID, DATE_REALIZ)
	(SELECT 1,NVL(KLS_VIDDOG.IS_AGENT,3),a.BILLS_NOM_DOK,a.BILL_POS_ID, a.PROD_ID_NPR, a.VES, a.CENA_BN,
     a.CENA, a.SUMMA_BN, a.SUMMA_NDS20, a.SUMMA_AKCIZ,a.SUMMA_GSM25,
	 a.SUMMA, a.CENA_POKUP, a.SUMMA_BN_POKUP,a.SUMMA_NDS20_POKUP, a.SUMMA_GSM25_POKUP,
	 a.OWNERSHIP_ID, a.DATE_REALIZ FROM load_buffer.sf_pr_pos A, KLS_DOG, KLS_DOG LUK_DOG, KLS_VIDDOG
  WHERE NOT EXISTS (SELECT * FROM BILL_POS C WHERE A.bills_nom_dok=C.nom_dok AND a.bill_pos_id=c.BILL_POS_ID)
	   AND A.NOM_DOG = KLS_DOG.SHORT_NUMBER(+) 
	   AND KLS_DOG.MAINDOG_ID=LUK_DOG.ID(+)
	   AND LUK_DOG.VIDDOG_ID = KLS_VIDDOG.ID(+) 
	   AND A.BILLS_NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS_NO_UPDATE) );
 
  IF IsFull=1 THEN
    DELETE FROM BILL_POS WHERE IS_POKUP=0 AND NOT EXISTS
      (SELECT nom_dok FROM load_buffer.out_plat a WHERE a.nom_dok=BILL_POS.nom_dok
      UNION ALL
      SELECT nom_dok FROM load_buffer.sf_pr_bills b WHERE b.nom_dok=BILL_POS.nom_dok)
	  AND NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS_NO_UPDATE)
	  AND NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS WHERE
          (date_kvit>=TO_DATE('14.07.2006','dd.mm.yyyy') and (prod_id_npr>='10100' or prod_id_npr='10080')));
    DELETE FROM BILL_POS WHERE IS_POKUP=0 AND NOT EXISTS
      (SELECT nom_dok FROM load_buffer.out_plat_pos a WHERE a.BILLS_NOM_DOK=BILL_POS.nom_dok AND a.bill_pos_id=BILL_POS.BILL_POS_ID
      UNION ALL
      SELECT nom_dok FROM load_buffer.sf_pr_pos b WHERE b.BILLS_NOM_DOK=BILL_POS.nom_dok AND b.bill_pos_id=BILL_POS.BILL_POS_ID)
 	  AND NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS_NO_UPDATE)
	  AND NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS WHERE
          (date_kvit>=TO_DATE('14.07.2006','dd.mm.yyyy') and (prod_id_npr>='10100' or prod_id_npr='10080')));
  ELSE
    DELETE FROM BILL_POS WHERE IS_POKUP=0 AND NOT EXISTS
      (SELECT nom_dok FROM load_buffer.out_plat a WHERE a.nom_dok=BILL_POS.nom_dok
	  UNION ALL
      SELECT nom_dok FROM load_buffer.sf_pr_bills b WHERE b.nom_dok=BILL_POS.nom_dok)
	  AND BILL_POS.DATE_REALIZ BETWEEN date_beg AND date_end
      AND BILL_POS.DATE_REALIZ>v_dat
	  AND NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS_NO_UPDATE)
	  AND NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS WHERE
          (date_kvit>=TO_DATE('14.07.2006','dd.mm.yyyy') and (prod_id_npr>='10100' or prod_id_npr='10080')));
    DELETE  FROM BILL_POS WHERE IS_POKUP=0 AND NOT EXISTS
      (SELECT nom_dok FROM load_buffer.out_plat_pos a WHERE a.BILLS_NOM_DOK=BILL_POS.nom_dok AND a.bill_pos_id=BILL_POS.BILL_POS_ID
	  UNION ALL
      SELECT nom_dok FROM load_buffer.sf_pr_pos b WHERE b.BILLS_NOM_DOK=BILL_POS.nom_dok AND b.bill_pos_id=BILL_POS.BILL_POS_ID)
	  AND BILL_POS.DATE_REALIZ BETWEEN date_beg AND date_end
	  AND BILL_POS.DATE_REALIZ>v_dat
	  AND NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS_NO_UPDATE)
	  AND NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS WHERE
          (date_kvit>=TO_DATE('14.07.2006','dd.mm.yyyy') and (prod_id_npr>='10100' or prod_id_npr='10080')));
  END IF;

  IF no_commit=0 THEN
    COMMIT; 
  END IF;	

END Renew_Bill_Pos; 
/

