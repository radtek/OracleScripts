--
-- RENEW_BILLS  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Bills (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') AS
  IsFull NUMBER(1);
  v_dat DATE;
BEGIN
  return;

  IF param1 || ' ' = ' ' THEN
    IsFull:=1;
  ELSE
    IsFull:=0;
	DELETE FROM load_buffer.to_ss_tmp;
	INSERT INTO load_buffer.to_ss_tmp
  	  SELECT * FROM load_buffer.TO_SS WHERE DATA_BUXG BETWEEN date_beg AND date_end;  
  END IF;

  -- Определение архивной даты  
  BEGIN
    SELECT ARH_DATE.LAST_DATE INTO v_dat
	  FROM ARH_DATE WHERE ARH_DATE.TABLENAME='BILLS';
  EXCEPTION 
    WHEN OTHERS THEN
	  v_dat:=TO_DATE('31.12.1899','dd.mm.yyyy');
  END;	  	    

  
  UPDATE load_buffer.out_plat  SET nom_zd='?' WHERE nom_zd IS NULL;
  DELETE FROM load_buffer.out_plat 
   WHERE (data_kvit>=TO_DATE('14.07.2006','dd.mm.yyyy') and (kod_nfp>='10100' or kod_nfp='10080'))  
	  OR nom_dok in (6142554,6142555,6142556);
  COMMIT;

-- Обновление № счетов
  UPDATE KTU_2_NPO_SF
    SET (NOM_SF,NPO_SF) =
	(SELECT a.NOM_SF,'02003К/'||TO_CHAR((a.NOM_SF-6009000)*2-1) FROM load_buffer.out_plat A, load_buffer.dog
	  WHERE A.NOM_DOG=dog.NUM_DOG AND dog.NUM_DOG2='0210218' AND A.nom_dok=KTU_2_NPO_SF.nom_dok AND A.DATA_KVIT>=TO_DATE('01.04.2002','dd.mm.yyyy') AND A.DATA_KVIT<=TO_DATE('10.04.2002','dd.mm.yyyy'))
    WHERE EXISTS (SELECT nom_dok FROM load_buffer.out_plat B, load_buffer.dog
	               WHERE B.NOM_DOG=dog.NUM_DOG AND dog.NUM_DOG2='0210218' AND B.nom_dok=KTU_2_NPO_SF.nom_dok AND B.DATA_KVIT>=TO_DATE('01.04.2002','dd.mm.yyyy') AND B.DATA_KVIT<=TO_DATE('10.04.2002','dd.mm.yyyy'));

  INSERT INTO KTU_2_NPO_SF
    (NOM_DOK,NOM_SF,NPO_SF)
	(SELECT a.nom_dok,a.NOM_SF,'02003К/'||TO_CHAR((a.NOM_SF-6009000)*2-1) FROM load_buffer.out_plat A, load_buffer.dog
  WHERE A.NOM_DOG=dog.NUM_DOG AND dog.NUM_DOG2='0210218' AND A.DATA_KVIT>=TO_DATE('01.04.2002','dd.mm.yyyy') AND A.DATA_KVIT<=TO_DATE('10.04.2002','dd.mm.yyyy') AND NOT EXISTS (SELECT nom_dok FROM KTU_2_NPO_SF C WHERE A.nom_dok=C.nom_dok));
  COMMIT;

-- Обновление счетов 
  UPDATE /*+ RULE */ BILLS 
    SET (IS_AGENT,NOM_SF,NPO_SF,DATE_VYP_SF,DATE_BUXG,DATE_KVIT,SUMMA_DOK,
         NDS_DOK,AKCIZ_DOK,GSM_DOK,PRIM,FIO_ISPOL,KOL_DN,OLD_NOM_DOK,
         NOM_ZD,OWNER_ID,DOG_ID,USL_NUMBER,PROD_ID_NPR,PROD_SUM,
         PROD_NDS,PROD_AKCIZ,PROD_GSM,DATE_MOS,OLD_NOM_SF,NUM_5_DAY,KORR_5_DAY,
		 LUK_DOG_ID,LUK_USL_NUMBER,LUK_KOL_DN,LUK_SUMMA_DOK,LUK_NDS_DOK,
		 SNP_DOG_ID,SNP_USL_NUMBER,SNP_KOL_DN,NAZN_OTG_ID,PROTO_NUM,PROTO_DATE,NO_AKCIZ,DATE_PLAT) =
	(SELECT 
	   IS_AGENT,NOM_SF,NPO_SF,DATE_VYP_SF,DATE_BUXG,DATE_KVIT,SUMMA_DOK,
       NDS_DOK,AKCIZ_DOK,GSM_DOK,PRIM,FIO_ISPOL,KOL_DN,OLD_NOM_DOK,
       NOM_ZD,OWNER_ID,DOG_ID,USL_NUMBER,PROD_ID_NPR,PROD_SUM,
	   PROD_NDS,PROD_AKCIZ,PROD_GSM,DATE_MOS,OLD_NOM_SF,NUM_5_DAY,KORR_5_DAY,
       LUK_DOG_ID,LUK_USL_NUMBER,LUK_KOL_DN,LUK_SUMMA_DOK,LUK_NDS_DOK,
  	   SNP_DOG_ID,SNP_USL_NUMBER,SNP_KOL_DN,KOD_OTGR,PROTO_NUM,PROTO_DATE,NO_AKCIZ,
	   GET_DATE_OTSRPLAT(A.DATE_KVIT,A.KOL_DN,/*(CASE WHEN A.PROD_ID_NPR<'10100' AND A.PROD_ID_NPR not IN ('10080','10093','10094') THEN 1 ELSE*/ 0/* END)*/)
     FROM v_renew_bills A 
    WHERE A.nom_dok=BILLS.nom_dok) 
   WHERE EXISTS (SELECT nom_dok FROM load_buffer.out_plat B WHERE B.nom_dok=BILLS.nom_dok)
     AND BILLS.DATE_BUXG BETWEEN date_beg AND date_end
	 AND BILLS.DATE_KVIT>v_dat
	 AND BILLS.NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS_NO_UPDATE);

  UPDATE /*+ RULE */ BILLS
    SET (IS_AGENT,NOM_SF,NPO_SF,DATE_VYP_SF,DATE_BUXG,DATE_KVIT,SUMMA_DOK,
         NDS_DOK,AKCIZ_DOK,GSM_DOK,KOL_DN,FIO_ISPOL,PRIM,OLD_NOM_DOK,
         NOM_ZD,USL_NUMBER,OWNER_ID,DOG_ID,PROD_ID_NPR,PROD_SUM,
         PROD_NDS,PROD_AKCIZ,PROD_GSM,DATE_MOS) =
	(SELECT NVL(KLS_VIDDOG.IS_AGENT,3),a.NOM_SF,'',a.DATA_DOK,a.DATA_BUXG,a.data_buxg,a.SUMMA_DOK,
      a.sum_nds,a.SUM_AKCIZ,a.sum_ndf,0,a.ISPOLN,'',a.OLD_NOM,
      'прочая',1,0,NVL(KLS_DOG.ID,0),'',a.SUMMA_DOK,
      a.sum_nds,a.SUM_AKCIZ,a.sum_ndf,a.DATA_BUXG
  FROM load_buffer.sf_pr_bills A,KLS_DOG, KLS_DOG LUK_DOG, KLS_VIDDOG
  WHERE A.nom_dok=BILLS.nom_dok AND A.NOM_DOG=KLS_DOG.SHORT_NUMBER(+)
  	    AND KLS_DOG.MAINDOG_ID=LUK_DOG.ID(+)
		AND LUK_DOG.VIDDOG_ID = KLS_VIDDOG.ID(+) )
    WHERE EXISTS (SELECT nom_dok FROM load_buffer.sf_pr_bills B WHERE B.nom_dok=BILLS.nom_dok)
     AND BILLS.DATE_BUXG BETWEEN date_beg AND date_end
	 AND BILLS.DATE_KVIT>v_dat
	 AND BILLS.NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS_NO_UPDATE);

-- Добавление оригинальных счетов   
  INSERT INTO BILLS
    (NOM_DOK,IS_AGENT,NOM_SF,NPO_SF,DATE_VYP_SF,DATE_BUXG,DATE_KVIT,SUMMA_DOK,
         NDS_DOK,AKCIZ_DOK,GSM_DOK,PRIM,FIO_ISPOL,KOL_DN,OLD_NOM_DOK,
         NOM_ZD,OWNER_ID,DOG_ID,USL_NUMBER,PROD_ID_NPR,PROD_SUM,
         PROD_NDS,PROD_AKCIZ,PROD_GSM,DATE_MOS,OLD_NOM_SF,NUM_5_DAY,KORR_5_DAY,
		 LUK_DOG_ID,LUK_USL_NUMBER,LUK_KOL_DN,LUK_SUMMA_DOK,LUK_NDS_DOK,
		 SNP_DOG_ID,SNP_USL_NUMBER,SNP_KOL_DN,NAZN_OTG_ID,PROTO_NUM,PROTO_DATE,NO_AKCIZ,DATE_PLAT)
	(SELECT NOM_DOK,IS_AGENT,NOM_SF,NPO_SF,DATE_VYP_SF,DATE_BUXG,DATE_KVIT,SUMMA_DOK,
         NDS_DOK,AKCIZ_DOK,GSM_DOK,PRIM,FIO_ISPOL,KOL_DN,OLD_NOM_DOK,
         NOM_ZD,OWNER_ID,DOG_ID,USL_NUMBER,PROD_ID_NPR,PROD_SUM,
         PROD_NDS,PROD_AKCIZ,PROD_GSM,DATE_MOS,OLD_NOM_SF,NUM_5_DAY,KORR_5_DAY,
		 LUK_DOG_ID,LUK_USL_NUMBER,LUK_KOL_DN,LUK_SUMMA_DOK,LUK_NDS_DOK,
		 SNP_DOG_ID,SNP_USL_NUMBER,SNP_KOL_DN,KOD_OTGR,PROTO_NUM,PROTO_DATE,NO_AKCIZ,
		 GET_DATE_OTSRPLAT(A.DATE_KVIT,A.KOL_DN,/*(CASE WHEN A.PROD_ID_NPR<'10100' AND A.PROD_ID_NPR not IN ('10080','10093','10094') THEN 1 ELSE*/ 0/* END)*/) 
     FROM v_renew_bills A
     WHERE NOT EXISTS (SELECT nom_dok FROM BILLS C WHERE A.nom_dok=C.nom_dok)
	   AND NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS_NO_UPDATE));

  INSERT INTO BILLS
    (NOM_DOK,IS_AGENT,NOM_SF,NPO_SF,DATE_VYP_SF,DATE_BUXG,DATE_KVIT,SUMMA_DOK,
         NDS_DOK,AKCIZ_DOK,GSM_DOK,KOL_DN,FIO_ISPOL,PRIM,OLD_NOM_DOK,
         NOM_ZD,USL_NUMBER,OWNER_ID,DOG_ID,PROD_ID_NPR,PROD_SUM,
         PROD_NDS,PROD_AKCIZ,PROD_GSM,DATE_MOS)
	(SELECT a.nom_dok,NVL(KLS_VIDDOG.IS_AGENT,3),a.NOM_SF,'',a.DATA_DOK,a.DATA_BUXG,a.data_buxg,a.SUMMA_DOK,
      a.sum_nds,a.SUM_AKCIZ,a.sum_ndf,0,a.ISPOLN,'',a.OLD_NOM,
      'прочая',1,0,NVL(KLS_DOG.ID,0),'',a.SUMMA_DOK,
      a.sum_nds,a.SUM_AKCIZ,a.sum_ndf,a.DATA_BUXG 
	  FROM load_buffer.sf_pr_bills A, KLS_DOG, KLS_DOG LUK_DOG, KLS_VIDDOG
     WHERE A.NOM_DOG=KLS_DOG.SHORT_NUMBER(+) 
	   AND KLS_DOG.MAINDOG_ID=LUK_DOG.ID(+)
	   AND LUK_DOG.VIDDOG_ID = KLS_VIDDOG.ID(+) 
	   AND NOT EXISTS (SELECT nom_dok FROM BILLS C WHERE A.nom_dok=C.nom_dok)
	   AND NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS_NO_UPDATE));
--  COMMIT;

-- Обновление № счетов
  UPDATE /*+ RULE */ BILLS
    SET (NPO_SF) =
	(SELECT '02003К/'||TO_CHAR((a.NOM_SF-6009000)*2-1) FROM load_buffer.out_plat A, load_buffer.dog
	  WHERE A.NOM_DOG=dog.NUM_DOG AND dog.NUM_DOG2='0210218' AND A.nom_dok=BILLS.nom_dok AND A.DATA_KVIT>=TO_DATE('01.04.2002','dd.mm.yyyy') AND A.DATA_KVIT<=TO_DATE('10.04.2002','dd.mm.yyyy'))
    WHERE EXISTS (SELECT nom_dok FROM load_buffer.out_plat B, load_buffer.dog
	               WHERE B.NOM_DOG=dog.NUM_DOG AND dog.NUM_DOG2='0210218' AND B.nom_dok=BILLS.nom_dok AND B.DATA_KVIT>=TO_DATE('01.04.2002','dd.mm.yyyy') AND B.DATA_KVIT<=TO_DATE('10.04.2002','dd.mm.yyyy'))
     AND BILLS.DATE_BUXG BETWEEN date_beg AND date_end
	 AND BILLS.DATE_KVIT>v_dat
     AND BILLS.NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS_NO_UPDATE);
  
-- Обновление признака корректировки продукта
  UPDATE /*+ RULE */ BILLS SET KORR_PROD=0 WHERE (OLD_NOM_DOK IS NULL OR OLD_NOM_DOK=0)
     AND BILLS.DATE_BUXG BETWEEN date_beg AND date_end
	 AND BILLS.DATE_KVIT>v_dat;
  
  FOR lcur IN (SELECT old_nom_dok, DOG_ID, SUM(A.PROD_SUM) as PROD_SUM 
               FROM BILLS A 
			   WHERE A.old_nom_dok IS NOT NULL AND A.OLD_NOM_DOK<>0
			     AND A.DATE_KVIT>=TO_DATE('01.01.2004','dd.mm.yyyy')
                 AND A.DATE_BUXG BETWEEN date_beg AND date_end
	             AND A.DATE_KVIT>v_dat
			   GROUP BY A.OLD_NOM_DOK, DOG_ID) LOOP
    UPDATE BILLS SET korr_prod=DECODE(lcur.PROD_SUM,0,0,1) WHERE BILLS.old_nom_dok=lcur.old_nom_dok;
  END LOOP;

-- Обновление позиций счетов  
  Renew_Bill_Pos(DATE_BEG,DATE_END,PARAM1,PARAM2,PARAM3,1);

-- Обновление сумм LUK_*
  UPDATE /*+ RULE */ BILLS A SET (LUK_SUMMA_DOK, LUK_NDS_DOK)=
     (SELECT SUM(SUMMA), SUM(SUMMA_NDS20)
	    FROM BILL_POS B
       WHERE IS_LUK=1 AND B.NOM_DOK=A.NOM_DOK)
  WHERE EXISTS	   
     (SELECT NULL
	    FROM BILL_POS B
       WHERE IS_LUK=1 AND B.NOM_DOK=A.NOM_DOK)
	AND EXISTS   
     (SELECT NULL 
        FROM load_buffer.out_plat B WHERE B.nom_dok=A.nom_dok)
     AND a.DATE_BUXG BETWEEN date_beg AND date_end
	 AND a.DATE_KVIT>v_dat
	 AND NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS_NO_UPDATE);
  
-- Удаление счетов  
  IF IsFull=1 THEN
    DELETE /*+ RULE */ FROM BILLS WHERE NOT EXISTS
      (SELECT nom_dok FROM load_buffer.out_plat a WHERE a.nom_dok=BILLS.nom_dok
	  UNION ALL
      SELECT nom_dok FROM load_buffer.sf_pr_bills b WHERE b.nom_dok=BILLS.nom_dok)
	 AND BILLS.NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS_NO_UPDATE)
	 AND NOT (date_kvit>=TO_DATE('14.07.2006','dd.mm.yyyy') and (prod_id_npr>='10100' or prod_id_npr='10080'));
  ELSE
    DELETE /*+ RULE */ FROM BILLS WHERE NOT EXISTS
      (SELECT nom_dok FROM load_buffer.out_plat a WHERE a.nom_dok=BILLS.nom_dok
	  UNION ALL
      SELECT nom_dok FROM load_buffer.sf_pr_bills b WHERE b.nom_dok=BILLS.nom_dok)
     AND BILLS.DATE_BUXG BETWEEN date_beg AND date_end
	 AND BILLS.DATE_KVIT>v_dat
	 AND BILLS.NOM_DOK NOT IN (SELECT NOM_DOK FROM BILLS_NO_UPDATE)
	 AND NOT (date_kvit>=TO_DATE('14.07.2006','dd.mm.yyyy') and (prod_id_npr>='10100' or prod_id_npr='10080'));
  END IF;

  IF IsFull=0 THEN
    -- Проставим IS_KORR и TO_KORR
    --Оригинальные счета
    update /*+ RULE */ bills a set is_korr=0, to_korr=0 
     where a.DATE_BUXG BETWEEN date_beg AND date_end
	 AND a.DATE_KVIT>v_dat;

    --Счета которые корректируют другие
    update /*+ RULE */ bills a set to_korr=1 where a.old_nom_dok in ( 
      select /*+ RULE */ nom_dok from bills
      )
     and a.DATE_BUXG BETWEEN date_beg AND date_end
	 AND a.DATE_KVIT>v_dat;

    --Счета которые были откорректированы другими
    update /*+ RULE */ bills a set is_korr=1 where a.nom_dok in ( 
      select /*+ RULE */ old_nom_dok from bills
      )
     and a.DATE_BUXG BETWEEN date_beg AND date_end
	 AND a.DATE_KVIT>v_dat;

    -- Счета которые были сторнированы
    update /*+ RULE */ bills a set is_korr=2 where a.is_korr=1 and a.nom_dok not in ( 
      select b.old_nom_dok from bills b where b.to_korr=1 and b.summa_dok>0
      )
     and a.DATE_BUXG BETWEEN date_beg AND date_end
	 AND a.DATE_KVIT>v_dat;

    -- Счета которые сторнируют
    update /*+ RULE */ bills a set to_korr=2 where a.to_korr=1 and a.old_nom_dok in ( 
      select b.nom_dok from bills b where b.is_korr=2 and b.summa_dok>0
      )
     and a.DATE_BUXG BETWEEN date_beg AND date_end
	 AND a.DATE_KVIT>v_dat;

    -- Выделение "минусовых"
    update /*+ RULE */ bills a set to_korr=sign(summa_dok)*abs(to_korr) where to_korr<>0
     and a.DATE_BUXG BETWEEN date_beg AND date_end
	 AND a.DATE_KVIT>v_dat;

    update /*+ RULE */ bills a set is_korr=sign(summa_dok)*abs(is_korr) where is_korr<>0
     and a.DATE_BUXG BETWEEN date_beg AND date_end
	 AND a.DATE_KVIT>v_dat;
  END IF;
  
  COMMIT;

END Renew_Bills; 
/

