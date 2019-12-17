--
-- V_SF_PRINT_WITH_KVIT_OLD  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_SF_PRINT_WITH_KVIT_OLD
(KOD_PROD, KOD_TU, SCHETF, SCHETUSL, SF_NO, 
 ORIG_SF_NO, ID_POZ_PROD, DATA_VYP_SF, FULL_NAME_NPOST, VYSTVAL, 
 ADDR_PRED_POST, PHONE_POST, INN_NPOST, PLRDOC, DATA_PLRD, 
 PLRDOC_AND_DATE, DOGOVOR, FULL_NAME_PLAT, ADDR_PRED_PLAT, PHONE_PLAT, 
 KORS_PRED_POST, RS_PRED_POST, BIK_PRED_POST, BANK_PRED_POST, KORS_PRED_PLAT, 
 RS_PRED_PLAT, BIK_PRED_PLAT, BANK_PRED_PLAT, INN_PLAT, GROTPR, 
 GROTPR_ADDR, GRPOL, GRPOL_ADDR, DOPOLN1, DOPOLN2, 
 NAIM_TOV, EDIZM, KOL, CENA, AKCIZ1, 
 SUMMA, AKCIZ2, STNDS, SUMNDS, STGSM, 
 SUMGSM, SUMNPR, ALLNDS, PROISX, GTD, 
 ALLNDS_PROPIS, NDS_PROPIS, NONDS_PROPIS, WITH_STNDS, WITH_STNDS_TXT, 
 BUHANAL, DATE_OTGR, DATE_DOG, BOSS, GLAVBUH, 
 NUM_PROTOKOL, PLAT_OKPO, NAKL_NUM, VES_PROPIS, DOVER_NUM, 
 KVIT_ID, NUM_CIST, AKCIZ_TXT, DATE_MOS, KPP_PLAT, 
 KPP_POST, DATE_PROPIS, NUM_AKT, F_AKCIZ, POST_COMPANY, 
 POST_DOLJ, POST_FIO, POST_DOVER, POKUP_COMPANY, POKUP_DOLJ, 
 POKUP_FIO, POKUP_DOVER, POST_DOLJ_SIGN, POST_FIO_SIGN, POKUP_DOLJ_SIGN, 
 POKUP_FIO_SIGN, POKUP_COMPANY_SIGN, SHORT_NAIM_TOV)
AS 
SELECT /*+ */
  b.nom_dok AS KOD_PROD
  ,6 AS KOD_TU
  ,DECODE(NVL(b.old_nom_sf,0), 0, TO_CHAR(b.nom_sf),DECODE(SIGN(b.summa_dok),-1,TO_CHAR(b.nom_sf),TO_CHAR(b.nom_sf) || '/' || LTRIM(TO_CHAR(b.old_nom_sf)))) || '     от  ' || TO_CHAR(DECODE(SIGN(b.date_vyp_sf-b.date_kvit),-1,b.date_kvit,b.date_vyp_sf), 'DD.MM.RRRR') AS SCHETF
  ,TRIM(b.nom_sf) || ' от ' ||  TO_CHAR(b.date_vyp_sf, 'DD.MM.YYYY') || 'г.' AS SCHETUSL
  ,TO_CHAR(b.nom_sf) AS SF_NO
  ,b.nom_sf AS ORIG_SF_NO
  ,DECODE(bp.BILL_POS_ID,12,11,13,10,bp.BILL_POS_ID) AS id_poz_prod
  ,b.date_vyp_sf AS data_vyp_sf
  ,DECODE(d.PREDPR_ID,1,'ОАО "ЛУКОЙЛ-УНП"',p0.sf_name) AS full_name_npost
  ,'РУБ' AS vystval
  ,GET_ADDR(r0.id,p0.postindex_j,p0.city_j,p0.address_j,r0.region_name) AS addr_pred_post
  ,p0.phone AS phone_post
  ,p0.inn AS inn_npost
  ,'' AS plrdoc
  ,TO_DATE(NULL) AS DATA_PLRD
  ,'' AS PLRDOC_AND_DATE
--  ,DECODE(SIGN(b.nom_sf-6000000),-1,'',b.nom_sf-6000000) AS plrdoc
--  ,b.date_vyp_sf AS dataplrd
--  ,DECODE(SIGN(b.nom_sf-6000000),-1,'',TO_CHAR(b.nom_sf-6000000) || ' от ' || TO_CHAR(b.date_vyp_sf)) AS PLRDOC_AND_DATE
  ,d.dog_number AS dogovor
  ,p1.sf_name AS FULL_NAME_PLAT
  ,GET_ADDR(r1.id,p1.postindex_j,p1.city_j,p1.address_j,r1.region_name) AS ADDR_PRED_PLAT
  ,p1.phone AS phone_plat
--
  ,p0.BANK_KORS AS kors_pred_post
  ,(CASE
      WHEN d.dog_number IN ('0411498/721/13/2004','0411565/737/13/2004') THEN '40702810700000000335'
	  ELSE p0.RS
	END) AS rs_pred_post
  ,bk0.BIK AS bik_pred_post
  ,bk0.BANK_NAME AS bank_pred_post
--
  ,p1.BANK_KORS AS kors_pred_plat
  ,p1.RS AS rs_pred_plat
  ,bk1.BIK AS bik_pred_plat
  ,bk1.BANK_NAME AS bank_pred_plat
--
  ,TRIM(p1.inn) AS inn_plat
  ,(CASE
      WHEN b.PROD_ID_NPR IN ('10090','10091','10092','10093','10094') THEN '-'
      ELSE DECODE(d.PREDPR_ID,1,'ОАО "ЛУКОЙЛ-УНП"',p4.sf_name)
	END) AS grotpr
  ,(CASE
      WHEN b.PROD_ID_NPR IN ('10090','10091','10092','10093','10094') THEN ' '
      ELSE GET_ADDR(r4.id,p4.postindex_p,p4.city_p,p4.address_p,r4.region_name)
	END) AS grotpr_addr
  ,(CASE
      WHEN b.PROD_ID_NPR IN ('10090','10091','10092','10093','10094') THEN '-'
      ELSE p2.sf_name
	END) AS grpol
  ,(CASE
      WHEN b.PROD_ID_NPR IN ('10090','10091','10092','10093','10094') THEN ' '
      ELSE GET_ADDR(r2.id,p2.postindex_p,p2.city_p,p2.address_p,r2.region_name)
	END) AS GRPOL_ADDR
  ,'' AS dopoln1
  ,(CASE
      WHEN b.PROD_ID_NPR IN ('10090','10091','10092') THEN 'Согласно договору '|| d.dog_number || ' от ' || TO_CHAR(d.dog_date,'dd.mm.yyyy') ||'г. '
      WHEN b.PROD_ID_NPR IN ('10093','10094') THEN bp.PROD_NAME || ' за '||NLS_LOWER(RUSMONTH(b.DATE_KVIT)) || ' согласно договору '|| d.dog_number || ' от ' || TO_CHAR(d.dog_date,'dd.mm.yyyy') ||'г. '
      WHEN b.PROD_ID_NPR='10080' THEN 'Акт приема-передачи № ' || bp.NUM_AKT || ' от ' || TO_CHAR(b.date_kvit,'dd.mm.yyyy') ||'г. '
      WHEN b.PROD_ID_NPR<'10100' AND b.PROD_ID_NPR<>'10080' THEN 'Согласно отчета агента от ' || TO_CHAR(b.date_kvit,'dd.mm.yyyy') ||'г. '
	  ELSE 'Квит. № ' || GET_LIST_NAKL_NUM(b.nom_dok) || ' от ' || TO_CHAR(b.date_kvit,'dd.mm.yyyy') ||' г. '
	END) AS dopoln2
  ,(CASE
      WHEN b.PROD_ID_NPR IN ('10090','10091','10092') THEN bp.PROD_NAME || ' за '||NLS_LOWER(RUSMONTH(b.DATE_KVIT)) || ' (ДЗ)'
      WHEN b.PROD_ID_NPR IN ('10093','10094') THEN bp.PROD_NAME || ' за '||NLS_LOWER(RUSMONTH(b.DATE_KVIT))
      WHEN b.PROD_ID_NPR<'10100' THEN bp.PROD_NAME
	  ELSE pr.sf_name
	END) AS naim_tov
  ,(CASE
      WHEN b.PROD_ID_NPR<'10100' THEN DECODE(NVL(bp.ves,0),0,'-',NLS_LOWER(TRIM(pr.ED_IZ)))
	  ELSE DECODE(NVL(kv.ves_brutto,0),0,'-',NLS_LOWER(TRIM(pr.ED_IZ)))
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
  ,(CASE WHEN b.PROD_ID_NPR IN ('10060','10061') THEN 0 ELSE 18 END) AS stnds
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
  ,master.Sf_F_Get_Propisi_Sfprod_kvit(b.LUK_SUMMA_DOK) AS ALLNDS_PROPIS
  ,master.Sf_F_Get_Propisi_Sfprod_kvit(b.LUK_NDS_DOK) AS NDS_PROPIS
  ,master.Sf_F_Get_Propisi_Sfprod_kvit(b.LUK_SUMMA_DOK-b.LUK_NDS_DOK) AS NONDS_PROPIS
  ,'+' AS with_stnds
  ,'Y' AS with_stnds_txt
  ,pr.analit AS buhanal
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
  ,master.sf_f_get_propisi_ves(b.nom_dok) AS VES_PROPIS
  ,Get_Dover_Num(b.nom_dok) AS dover_num
  ,kv.ID AS kvit_id
  ,kv.NUM_CIST
  ,(CASE
      WHEN b.PROD_ID_NPR<'10100' AND b.PROD_ID_NPR<>'10080' THEN '-'
      WHEN b.PROD_ID_NPR='10080' THEN (CASE WHEN bp.akciz=1 THEN 'БЕЗ АКЦИЗА' ELSE '-' END)
      WHEN pr.akciz=1 THEN 'БЕЗ АКЦИЗА'
  	  ELSE '-'
	END) AS akciz_txt
  ,B.DATE_MOS
  ,TRIM(p1.KPP) AS KPP_PLAT
  ,p0.kpp AS kpp_post
  ,SUBSTR(rusdate(b.date_kvit),1,30) AS date_propis
  ,bp.NUM_AKT
  ,bp.akciz AS f_akciz
  ,DECODE(d.PREDPR_ID,1,'ОАО "ЛУКОЙЛ-УНП"',p0.sf_name) AS POST_COMPANY,
   sd.POST_DOLJ, sd.POST_FIO, sd.POST_DOVER,
   p1.sf_name AS POKUP_COMPANY,
   sd.POKUP_DOLJ, sd.POKUP_FIO, sd.POKUP_DOVER
  ,sd.POST_DOLJ_SIGN,sd.POST_FIO_SIGN,sd.POKUP_DOLJ_SIGN, sd.POKUP_FIO_SIGN, sd.POKUP_COMPANY_SIGN
  ,pr.NAME_NPR AS short_naim_tov
FROM
  MASTER.BILLS b
  ,(SELECT BILL_POS.*,KLS_PROD.SF_NAME AS PROD_NAME,KLS_PROD.AKCIZ
      FROM MASTER.BILL_POS, MASTER.BILLS,MASTER.KLS_PROD
	 WHERE BILL_POS.nom_dok=BILLS.nom_dok
--	   AND bills.prod_id_npr='10080'
	   AND BILL_POS.PROD_ID_NPR=KLS_PROD.ID_NPR
	   AND BILL_POS.is_luk=1
	   AND BILL_POS.is_pokup<>1
	   AND (BILL_POS.bill_pos_id<10 OR BILLS.prod_id_npr<'10100')) bp
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
  ,MASTER.KLS_PROD pr
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
WHERE /*b.DATE_KVIT>=TO_DATE('01.10.2004','dd.mm.yyyy')
  and*/ b.dog_id=d.id
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
  AND b.prod_id_npr=pr.id_npr(+)
--  and( b.nom_DOK in (6128908) )
;


