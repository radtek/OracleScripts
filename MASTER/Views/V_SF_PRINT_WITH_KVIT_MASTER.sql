--
-- V_SF_PRINT_WITH_KVIT_MASTER  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_SF_PRINT_WITH_KVIT_MASTER
(KOD_PROD, KOD_TU, SCHETF, SCHETUSL, SF_NO, 
 ORIG_SF_NO, ID_POZ_PROD, DATA_VYP_SF, FULL_NAME_NPOST, VYSTVAL, 
 FULL_ADDR_PRED_POST, ADDR_PRED_POST, PHONE_POST, INN_NPOST, PLRDOC, 
 DATA_PLRD, PLRDOC_AND_DATE, DOGOVOR, FULL_NAME_PLAT, FULL_ADDR_PRED_PLAT, 
 ADDR_PRED_PLAT, PHONE_PLAT, KORS_PRED_POST, RS_PRED_POST, BIK_PRED_POST, 
 BANK_PRED_POST, KORS_PRED_PLAT, RS_PRED_PLAT, BIK_PRED_PLAT, BANK_PRED_PLAT, 
 INN_PLAT, GROTPR, GROTPR_ADDR, GRPOL, GRPOL_ADDR, 
 DOPOLN1, DOPOLN2, NAIM_TOV, EDIZM, KOL, 
 CENA, AKCIZ1, SUMMA, AKCIZ2, STNDS, 
 SUMNDS, STGSM, SUMGSM, SUMNPR, ALLNDS, 
 PROISX, GTD, ALLNDS_PROPIS, NDS_PROPIS, NONDS_PROPIS, 
 WITH_STNDS, WITH_STNDS_TXT, BUHANAL, DATE_OTGR, DATE_DOG, 
 BOSS, GLAVBUH, NUM_PROTOKOL, PLAT_OKPO, NAKL_NUM, 
 VES_PROPIS, DOVER_NUM, KVIT_ID, NUM_CIST, AKCIZ_TXT, 
 DATE_MOS, KPP_PLAT, KPP_POST, DATE_PROPIS, NUM_AKT, 
 F_AKCIZ, POST_COMPANY, POST_DOLJ, POST_FIO, POST_DOVER, 
 POKUP_COMPANY, POKUP_DOLJ, POKUP_FIO, POKUP_DOVER, POST_DOLJ_SIGN, 
 POST_FIO_SIGN, POKUP_DOLJ_SIGN, POKUP_FIO_SIGN, POKUP_COMPANY_SIGN, SHORT_NAIM_TOV)
AS 
SELECT /*+ */
  b.nom_dok AS KOD_PROD
  ,6 AS KOD_TU
  ,SUBSTR(Get_Nom_Sf(0,b.nom_dok,b.nom_sf,b.old_nom_dok,b.old_nom_sf,b.summa_dok,b.date_vyp_sf,b.date_kvit),1,100) AS  SCHETF -- номер СФ + номер корректируемого счета (через дробь) + дата СФ
  ,SUBSTR(Get_Nom_Sf(3,b.nom_dok,b.nom_sf,b.old_nom_dok,b.old_nom_sf,b.summa_dok,b.date_vyp_sf,b.date_kvit),1,100) AS  SCHETUSL -- номер СФ + дата СФ + г.
  ,TO_CHAR(b.nom_sf) AS  SF_NO -- номер СФ
  ,b.nom_sf AS ORIG_SF_NO
  ,DECODE(bp.BILL_POS_ID,12,11,13,10,bp.BILL_POS_ID)*(CASE WHEN bp.npp<>0 THEN 100 ELSE 1 END)+bp.npp AS id_poz_prod
  ,b.date_vyp_sf AS data_vyp_sf
  ,p0.sf_name AS full_name_npost
  ,'РУБ' AS vystval
  ,(case
  when b.date_vyp_sf>=to_date('01.06.2006','dd.mm.yyyy') and p0.full_address_j is NULL then Get_Addr(r0.id,p0.postindex_j,p0.city_j,p0.address_j,r0.region_name)  
  when b.date_vyp_sf>=to_date('01.06.2006','dd.mm.yyyy') and p0.full_address_j is not NULL then p0.full_address_j  
  else Get_Addr(r0.id,p0.postindex_j,p0.city_j,p0.address_j,r0.region_name)
    end) AS full_addr_pred_post 
  ,Get_Addr(r0.id,p0.postindex_j,p0.city_j,p0.address_j,r0.region_name) AS addr_pred_post
  ,p0.phone AS phone_post
  ,p0.inn AS inn_npost
  ,'' AS plrdoc
  ,TO_DATE(NULL) AS DATA_PLRD
  ,'' AS PLRDOC_AND_DATE
  ,d.dog_number AS dogovor
  ,p1.sf_name AS FULL_NAME_PLAT
  ,(case
  when b.date_vyp_sf>=to_date('01.06.2006','dd.mm.yyyy') and p1.full_address_j is NULL then Get_Addr(r1.id,p1.postindex_j,p1.city_j,p1.address_j,r1.region_name)  
  when b.date_vyp_sf>=to_date('01.06.2006','dd.mm.yyyy') and p1.full_address_j is not NULL then p1.full_address_j  
  else Get_Addr(r1.id,p1.postindex_j,p1.city_j,p1.address_j,r1.region_name)
    end) AS full_addr_pred_plat 
  ,Get_Addr(r1.id,p1.postindex_j,p1.city_j,p1.address_j,r1.region_name) AS ADDR_PRED_PLAT
  ,p1.phone AS phone_plat
  ,p0.BANK_KORS AS kors_pred_post
  ,Get_Sf_Post_Rs(p0.ID,p0.RS,d.dog_number) AS rs_pred_post
  ,bk0.BIK AS bik_pred_post
  ,bk0.BANK_NAME AS bank_pred_post
  ,p1.BANK_KORS AS kors_pred_plat
  ,p1.RS AS rs_pred_plat
  ,bk1.BIK AS bik_pred_plat
  ,bk1.BANK_NAME AS bank_pred_plat
  ,TRIM(p1.inn) AS inn_plat
  ,(CASE
      WHEN b_pr.SF_GROTP_VIEW=0 THEN '-'
      ELSE p4.sf_name
 END) AS grotpr
  ,(CASE
      WHEN b_pr.SF_GROTP_VIEW=0 THEN '-'
      WHEN p4.full_address_j is NULL THEN Get_Addr(r4.id,p4.postindex_p,p4.city_p,p4.address_p,r4.region_name)
   ELSE p4.full_address_j
 END) AS grotpr_addr
  ,(CASE
      WHEN b_pr.SF_POLUCH_VIEW=0 THEN '-'
      ELSE p2.sf_name
 END) AS grpol
  ,(CASE
      WHEN b_pr.SF_POLUCH_VIEW=0 THEN '-'
   WHEN p2.full_address_j IS NULL THEN Get_Addr(r2.id,p2.postindex_p,p2.city_p,p2.address_p,r2.region_name)
   ELSE p2.full_address_j
 END) AS GRPOL_ADDR
  ,'' AS dopoln1
  ,Get_Sf_Dopoln2(b.PROD_ID_NPR,b_pr.SF_NAME,bp.PROD_ID_NPR,bp_pr.SF_NAME,d.DOG_NUMBER,d.DOG_DATE,b.nom_dok,b.date_kvit,b.date_mos,DECODE(b.PROD_ID_NPR,'10080',bp.NUM_AKT,b.NOM_SF-100000),NVL(m.NAZN_OTG_ID,0)) AS dopoln2
  ,Get_Sf_Prodname(b.PROD_ID_NPR,b_pr.SF_NAME,bp.PROD_ID_NPR,bp_pr.SF_NAME,b.date_kvit) AS naim_tov
  ,(CASE
      WHEN b.PROD_ID_NPR<'10100' THEN DECODE(NVL(bp.ves,0),0,'-',NLS_LOWER(TRIM(bp_pr.ED_IZ)))
   ELSE DECODE(NVL(kv.ves_brutto,0),0,'-',NLS_LOWER(TRIM(bp_pr.ED_IZ)))
 END) AS edizm
  ,(CASE
      WHEN b.PROD_ID_NPR<'10100' THEN NVL(bp.ves,0)
   ELSE NVL(kv.ves_brutto,0)
 END) AS kol
  ,(CASE
      WHEN b.PROD_ID_NPR<'10100' THEN DECODE(NVL(BP.CENA_BN,0),0,'-',TO_CHAR(bp.cena_bn,'999999.99'))
   ELSE DECODE(NVL(KV.CENA,0),0,'-',TO_CHAR(kv.cena,'999999.99'))
 END) AS cena
  ,(CASE
      WHEN b.PROD_ID_NPR<'10100' THEN bp.summa_akciz
   ELSE kv.sum_akciz
 END) AS akciz1
  ,(CASE
      WHEN b.PROD_ID_NPR<'10100' AND b.PROD_ID_NPR<>'10080' THEN bp.summa_bn
      WHEN b.PROD_ID_NPR='10080' THEN bp.summa_bn
   ELSE kv.sum_prod
 END) AS summa
  ,0 AS akciz2
  ,(CASE WHEN bp_pr.SF_NDS_VIEW=0 THEN 0 ELSE For_Bills.GetNDSValue(b.date_kvit) END) AS stnds
  ,(CASE
      WHEN b.PROD_ID_NPR<'10100' AND b.PROD_ID_NPR<>'10080' THEN bp.summa_nds20
      WHEN b.PROD_ID_NPR='10080' THEN bp.summa_nds20
   ELSE kv.sum_prod_nds
 END) AS sumnds
  ,0 AS stgsm
  ,0 AS sumgsm
  ,0 AS sumnpr
  ,(CASE
      WHEN b.PROD_ID_NPR<'10100' AND b.PROD_ID_NPR<>'10080' THEN bp.summa
      WHEN b.PROD_ID_NPR='10080' THEN bp.summa
   ELSE kv.sum_prod+kv.sum_prod_nds
 END) AS allnds
  ,'-' AS proisx
  ,'-' AS gtd
  ,master.Sf_F_Get_Propisi_Sfprod_Kvit(b.LUK_SUMMA_DOK) AS ALLNDS_PROPIS
  ,master.Sf_F_Get_Propisi_Sfprod_Kvit(b.LUK_NDS_DOK) AS NDS_PROPIS
  ,master.Sf_F_Get_Propisi_Sfprod_Kvit(b.LUK_SUMMA_DOK-b.LUK_NDS_DOK) AS NONDS_PROPIS
  ,'+' AS with_stnds
  ,'Y' AS with_stnds_txt
  ,bp_pr.analit AS buhanal
  ,b.date_kvit AS DATE_OTGR
  ,(CASE
      WHEN d.PREDPR_ID=1 AND d.PLAT_DOG_NUMBER<>'' THEN 'от ' || TO_CHAR(d.dog_date,'dd.mm.yyyy') ||' г. '|| ' ('||d.PLAT_DOG_NUMBER||')'
   ELSE 'от ' || TO_CHAR(d.dog_date,'dd.mm.yyyy') ||' г. '
 END) AS DATE_DOG
  ,s.boss
  ,s.blavbuh AS glavbuh
  ,(CASE
      WHEN b.PROD_ID_NPR<'10100' AND b.PROD_ID_NPR<>'10080' THEN ''
      WHEN b.PROD_ID_NPR='10080' THEN bp.PROTO_NUM || ' от ' || TO_CHAR(bp.PROTO_DATE,'dd.mm.yy') || 'г.'
   ELSE b.PROTO_NUM || ' от ' || TO_CHAR(b.PROTO_DATE,'dd.mm.yy') || 'г.'
 END) AS NUM_PROTOKOL
  ,Get_Plat_Okpo(b.nom_dok) AS PLAT_OKPO
  ,Get_Nakl_Num(b.nom_dok) AS NAKL_NUM
  ,master.Sf_F_Get_Propisi_Ves(b.nom_dok) AS VES_PROPIS
  ,Get_Dover_Num(b.nom_dok) AS dover_num
  ,kv.ID AS kvit_id
  ,kv.NUM_CIST
  ,(CASE
      WHEN b.PROD_ID_NPR<'10100' AND b.PROD_ID_NPR<>'10080' THEN '-'
      WHEN b.PROD_ID_NPR='10080' THEN (CASE WHEN bp_pr.akciz=1 THEN 'БЕЗ АКЦИЗА' ELSE '-' END)
      WHEN bp_pr.akciz=1 THEN 'БЕЗ АКЦИЗА'
     ELSE '-'
 END) AS akciz_txt
  ,B.DATE_MOS
  ,TRIM(p1.KPP) AS KPP_PLAT
  ,p0.kpp AS kpp_post
  ,SUBSTR(Rusdate(b.date_kvit),1,30) AS date_propis
  ,DECODE(b.PROD_ID_NPR,'10080',bp.NUM_AKT,b.NOM_SF-100000) as NUM_AKT
  ,bp_pr.akciz AS f_akciz
  ,p0.sf_name AS POST_COMPANY,
   sd.POST_DOLJ, sd.POST_FIO, sd.POST_DOVER,
   p1.sf_name AS POKUP_COMPANY,
   sd.POKUP_DOLJ, sd.POKUP_FIO, sd.POKUP_DOVER
  ,sd.POST_DOLJ_SIGN,sd.POST_FIO_SIGN,sd.POKUP_DOLJ_SIGN, sd.POKUP_FIO_SIGN, sd.POKUP_COMPANY_SIGN
  ,bp_pr.NAME_NPR AS short_naim_tov
FROM
  MASTER.BILLS b
  ,(
  SELECT 
      bp.NOM_DOK, 
   bp.BILL_POS_ID,
   NVL(bpr.npp,0) as NPP, 
   NVL(bpr.VES,bp.VES) as VES,
   NVL(bpr.CENA_BN,bp.CENA_BN) as CENA_BN,
   NVL(bpr.CENA,bp.CENA) as CENA, 
   NVL(bpr.SUMMA_BN,bp.SUMMA_BN) as SUMMA_BN, 
   NVL(bpr.SUMMA_AKCIZ,bp.SUMMA_AKCIZ) as SUMMA_AKCIZ, 
   NVL(bpr.SUMMA_NDS20,bp.SUMMA_NDS20) as SUMMA_NDS20,
   NVL(bpr.SUMMA,bp.SUMMA) as SUMMA,
   bp.DATE_REALIZ,
   NVL(bpr.PROD_ID_NPR,bp.PROD_ID_NPR) as PROD_ID_NPR,
   bp.OWNERSHIP_ID, 
   bp.ANALIT_ID, 
   bp.IS_AGENT, 
   bp.IS_LUK, 
   bp.NACENKA, 
   bp.NUM_AKT, 
   bp.PROTO_NUM, 
   bp.PROTO_DATE, 
   bp.NO_AKCIZ, 
   bp.SUPPLIER_ID
    FROM MASTER.BILL_POS bp, MASTER.BILLS b, MASTER.BILL_POS_ROW bpr
  WHERE bp.nom_dok=b.nom_dok
    AND bp.is_luk+0=1
    AND bp.is_pokup<>1
    AND (bp.bill_pos_id<10 OR b.prod_id_npr<'10100')
 AND bp.nom_dok=bpr.nom_dok(+)
 AND bp.bill_pos_id=bpr.bill_pos_id(+)
 ) bp
  ,MASTER.KLS_DOG d
  ,MASTER.KLS_PREDPR p0 --продавец
  ,MASTER.KLS_PREDPR p1 --плательщик
  ,MASTER.KLS_PREDPR p2 --получатель
  ,MASTER.KLS_PREDPR p4 --отправитель
  ,MASTER.KLS_REGION r0 --продавец
  ,MASTER.KLS_REGION r1 --плательщик
  ,MASTER.KLS_REGION r2 --получатель
  ,MASTER.KLS_REGION r4 --отправитель
  ,MASTER.KLS_BANKS bk0 --продавец
  ,MASTER.KLS_BANKS bk1 --плательщик
  ,MASTER.KLS_PROD b_pr -- нефтепродукт в СФ
  ,MASTER.KLS_PROD bp_pr -- нефтепродукт в позиции СФ
  ,(SELECT  /*+ INDEX(BILLS BILLS_PK) */ KVIT.*
      FROM MASTER.KVIT,MASTER.BILLS
     WHERE KVIT.bill_id=BILLS.nom_dok
    AND BILLS.prod_id_npr<>'10080'
 UNION ALL
    SELECT /*+ INDEX(BILLS BILLS_PK) */ DOP_KVIT.*
      FROM MASTER.DOP_KVIT,MASTER.BILLS
     WHERE DOP_KVIT.bill_id=BILLS.nom_dok
    AND BILLS.prod_id_npr<>'10080' ) kv
  ,V_SF_SIGNS s
  ,V_SF_DOVER sd
  ,MASTER.MONTH m
WHERE b.dog_id=d.id
  AND b.nom_dok=bp.nom_dok
  AND bp.nom_dok=kv.bill_id(+)
  AND bp.bill_pos_id=kv.bill_pos_id(+)
  AND d.predpr_id=p1.id
  AND b.nom_zd=m.nom_zd(+)
  AND b.owner_id = p0.id
  AND (CASE
         WHEN NVL(m.potreb_id,0)>0 THEN m.potreb_id
   ELSE p1.id
    END) = p2.id
  AND (CASE
         WHEN NVL(m.grotp_id,0)>0 THEN m.grotp_id
   ELSE 8
    END) = p4.id
  AND p0.region_id=r0.id(+)
  AND p1.region_id=r1.id(+)
  AND p2.region_p_id=r2.id(+)
  AND p4.region_p_id=r4.id(+)
  AND p0.BANKS_ID=bk0.ID(+)
  AND p1.BANKS_ID=bk1.ID(+)
  AND b.prod_id_npr=b_pr.id_npr
  AND bp.PROD_ID_NPR=bp_pr.id_npr
--  AND( b.nom_dok in (6142554,6142555,6142556)  )
;


