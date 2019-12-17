--
-- V_LUKREP_SF_REES_NEW  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_LUKREP_SF_REES_NEW
(NUM_5_DAY, IS_KORR, IS_AGENT, SOBSTV, PLAT_ID, 
 PLAT_INN, PLAT_NAME, PLAT_ADDR, DOG_ID, DOG_NUMBER, 
 DOG_DATE, NOM_DOK, NOM_SF, ORIG_NOM_SF, OLD_NOM_SF, 
 NPO_SF, NOM_SCH, DATE_VYP_SF, NOM_AKT, DATE_AKT, 
 PROD_ID_NPR, PROD_NAME, VES, PROD_EDIZ, NUM_KVIT, 
 NUM_DOVER, NUM_KVIT_STR, DATE_KVIT, DATE_MOS, NUM_PASP, 
 NUM_STRAH, CENA_BN, CENA, SUMMA_PROD_BN, SUMMA_PROD_NDS, 
 SUMMA_PROD, SUMMA_AGEN, SUMMA_AGEN_NDS, SUMMA_VOZN_11, SUMMA_VOZN_11_NDS, 
 SUMMA_VOZN_12, SUMMA_VOZN_12_NDS, SUMMA_TARIF, SUMMA_TARIF_NDS, SUMMA_STRAH, 
 SUMMA_DOK, SUMMA_DOK_NDS, PRICE_PROTOKOL, HRAN_ID, HRAN_NAME, 
 KOL_DN, RAST, LUK_PLAT_ID, LUK_PLAT_NAME, LUK_DOG_ID, 
 LUK_DOG_NUMBER, LUK_DOG_DATE, TYPE_DOCUMENT)
AS 
SELECT /*+ ALL_ROWS */
  TO_NUMBER(TO_CHAR(v_bills.date_mos,'MM'))*100+v_bills.NUM_5_DAY,
  DECODE(TRUNC(v_bills.DATE_KVIT,'MONTH'),TRUNC(v_bills.DATE_MOS,'MONTH'),0,TO_NUMBER(TO_CHAR(v_bills.date_kvit,'MM'))*100+v_bills.KORR_5_DAY) AS IS_KORR,
  V_BILLS.IS_AGENT,
  DECODE(KLS_DOG.DOG_NUMBER,'01М1254',2,
     DECODE(v_bills.PROD_ID_NPR,'10001',DECODE(SIGN(v_bills.DATE_KVIT-TO_DATE('01.01.2004','dd.mm.yyyy')),-1,NVL(b_p.SOBSTV,1),5),
	                            '10009',5,'10003',5,'10006',5,'10041',5,'10042',5,NVL(b_p.SOBSTV,1)
		   )
		) AS SOBSTV,
  DECODE(KLS_DOG.DOG_NUMBER,'0210218',SNP_DOG.PREDPR_ID,KLS_DOG.PREDPR_ID) AS PLAT_ID,
  DECODE(KLS_DOG.DOG_NUMBER,'0210218',SNP_PLAT.INN,PLAT.INN) AS PLAT_INN,
  DECODE(KLS_DOG.DOG_NUMBER,'0210218',SNP_PLAT.PREDPR_NAME,PLAT.PREDPR_NAME) AS PLAT_NAME,
  DECODE(KLS_DOG.DOG_NUMBER,'0210218',SNP_PLAT.CITY_J || ',' || SNP_PLAT.ADDRESS_J,PLAT.CITY_J || ',' || PLAT.ADDRESS_J) AS PLAT_ADDR,
  DECODE(KLS_DOG.DOG_NUMBER,'0210218',v_bills.SNP_DOG_ID,v_bills.DOG_ID),
  DECODE(KLS_DOG.DOG_NUMBER,'0210218',SNP_DOG.DOG_NUMBER,KLS_DOG.DOG_NUMBER),
  DECODE(KLS_DOG.DOG_NUMBER,'0210218',SNP_DOG.DOG_DATE,KLS_DOG.DOG_DATE),
  v_bills.NOM_DOK,
  v_bills.NOM_SF,
  v_bills.ORIG_NOM_SF,
  DECODE(SIGN(v_bills.SUMMA_DOK),-1,'',v_bills.OLD_NOM_SF),
  v_bills.NPO_SF,
  TO_CHAR(v_bills.ORIG_NOM_SF-6000000) AS NOM_SCH,
  v_bills.DATE_VYP_SF AS DATE_VYP_SF,
  DECODE(v_bills.IS_AGENT,2,TO_CHAR(v_bills.ORIG_NOM_SF-6000000),'') AS NOM_AKT,
  DECODE(v_bills.IS_AGENT,2,TO_CHAR(v_bills.DATE_KVIT,'dd.mm.yyyy'),'') AS DATE_AKT,
  v_bills.PROD_ID_NPR,
  DECODE(v_bills.PROD_ID_NPR,'10001','Вознаграждение за выполнение поручения по организации транспортировки продукции',
                             '10006','Расходы по организации транспортировки продукции',
                             '10003','Вознаграждение за выполнение поручения по организации транспортировки продукции',
							 '10009','Стоимость услуг по предоставлению жд цистерн',
							 '10042','Вознаграждение за выполнение поручения по страхованию отгруженной продукции',
							 KLS_PROD.NAME_NPR) AS PROD_NAME,
  NVL(KV.ves,0) AS VES,
  KLS_PROD.ED_IZ AS PROD_EDIZ,
  NVL(KV.NUM_KVIT,0),
  NVL(KV.NUM_DOVER,' '),
  NVL(DECODE(KV.LOAD_ABBR,'САМ',TO_CHAR(KV.NUM_KVIT)||' (Дов.N_'||KV.NUM_DOVER||')',TO_CHAR(KV.NUM_KVIT)),' ') AS NUM_KVIT_STR,
  v_bills.DATE_KVIT,
  v_bills.DATE_MOS,
  NVL(KV.PASP_NUM,'               '),
  DECODE(NVL(b_p.summa_strah,0),0,' ',TO_CHAR(v_bills.ORIG_NOM_SF-6000000)),
  NVL(b_p.cena_bn,0),
  NVL(b_p.cena,0),
  NVL(b_p.summa_prod_bn,0),
  NVL(b_p.summa_prod_nds,0),
  NVL(b_p.summa_prod,0),
  NVL(b_p.summa_agen,0),
  NVL(b_p.summa_agen_nds,0),
  NVL(b_p.summa_vozn_11,0),
  NVL(b_p.summa_vozn_11_nds,0),
  NVL(b_p.summa_vozn_12,0),
  NVL(b_p.summa_vozn_12_nds,0),
  NVL(b_p.summa_tarif,0),
  NVL(b_p.summa_tarif_nds,0),
  NVL(b_p.summa_strah,0),
  NVL(b_p.summa_dok,0),
  NVL(b_p.summa_dok_nds,0),
  DECODE(v_bills.PROTO_NUM,NULL,Get_Price_Protokol_Fast(v_bills.nom_dok,v_bills.PROD_ID_NPR,v_bills.date_kvit,v_bills.orig_dog_id,v_bills.orig_usl_number,v_bills.date_vyp_sf,v_bills.nom_sf,v_bills.old_nom_sf),v_bills.PROTO_NUM || ' от ' || TO_CHAR(v_bills.PROTO_DATE,'dd.mm.yy') || 'г.'),
  DECODE(KV.LOAD_ABBR,'РЕЗ',DECODE(v_bills.NAZN_OTG_ID,9,DECODE(KLS_DOG.DOG_NUMBER,'0210218',SNP_DOG.PREDPR_ID,KLS_DOG.PREDPR_ID),99999),99999) AS HRAN_ID,
  DECODE(KV.LOAD_ABBR,'РЕЗ',DECODE(v_bills.NAZN_OTG_ID,9,DECODE(KLS_DOG.DOG_NUMBER,'0210218',SNP_PLAT.PREDPR_NAME,PLAT.PREDPR_NAME),' '),' ') AS HRAN_NAME,
  v_bills.KOL_DN,
  NVL(KV.RAST,0),
  LUK_PLAT.ID AS LUK_PLAT_ID,
  LUK_PLAT.PREDPR_NAME AS LUK_PLAT_NAME,
  LUK_DOG.ID AS LUK_DOG_ID,
  LUK_DOG.DOG_NUMBER AS LUK_DOG_NUMBER,
  LUK_DOG.DOG_DATE AS LUK_DOG_DATE,
  DECODE(NVL(KV.ves,0),0,'',DECODE(v_bills.IS_AGENT,2,'АКТ','Ж/Д КВИТАНЦИЯ')) AS TYPE_DOCUMENT
FROM v_bills,
  (
   SELECT
     V_KVIT_ALL.BILL_ID,
     V_KVIT_ALL.NUM_KVIT,
	 V_KVIT_ALL.DATE_KVIT,
     V_KVIT_ALL.NUM_DOVER,
     MONTH.LOAD_ABBR,
	 MAX(KLS_PASP.PASP_NUM) AS PASP_NUM,
     MONTH.POTREB_ID,
     STANOTP.STAN_KOD AS STAN_OTP_KOD,
	 MAX(STAN.RAST) AS RAST,
	 POTREB.PREDPR_NAME AS POTREB_NAME,
	 SUM(V_KVIT_ALL.VES_BRUTTO) AS VES
   FROM V_KVIT_ALL, MONTH, KLS_PASP, KLS_STAN STANOTP, KLS_PREDPR POTREB, KLS_STAN STAN
   WHERE V_KVIT_ALL.NOM_ZD = MONTH.NOM_ZD
  	 AND V_KVIT_ALL.DATE_KVIT>=TO_DATE('01.01.2003','dd.mm.yyyy')
	 AND V_KVIT_ALL.BILL_ID<>0
     AND V_KVIT_ALL.PASP_ID = KLS_PASP.ID (+)
	 AND MONTH.POTREB_ID = POTREB.ID(+)
	 AND MONTH.STANOTP_ID = STANOTP.ID
	 AND MONTH.STAN_ID = STAN.ID
   GROUP BY
	 V_KVIT_ALL.BILL_ID,
	 V_KVIT_ALL.NUM_KVIT,
	 V_KVIT_ALL.DATE_KVIT,
	 V_KVIT_ALL.NUM_DOVER,
	 MONTH.LOAD_ABBR,
--	 KLS_PASP.PASP_NUM,
	 MONTH.POTREB_ID,
     STANOTP.STAN_KOD,
     POTREB.PREDPR_NAME
	  ) KV,
  (SELECT
     v_bill_pos.NOM_DOK,
	 DECODE(SIGN(v_bill_pos.BILL_POS_ID-10),-1,DECODE(v_bill_pos.OWNERSHIP_ID,1,1,3),1) AS SOBSTV,
--     1 AS SOBSTV,
	 MAX(DECODE(SIGN(v_bill_pos.BILL_POS_ID-10),-1,v_bill_pos.CENA_BN,0)) AS cena_bn,
	 MAX(DECODE(SIGN(v_bill_pos.BILL_POS_ID-10),-1,ROUND(NVL(v_bill_pos.CENA_BN,0)*(100+FOR_BILLS.GetNDSValue(v_bill_pos.DATE_REALIZ))/100,2),0)) AS cena,
	 SUM(DECODE(SIGN(v_bill_pos.BILL_POS_ID-10),-1,v_bill_pos.SUMMA-v_bill_pos.SUMMA_NDS20,0)) AS summa_prod_bn,
	 SUM(DECODE(SIGN(v_bill_pos.BILL_POS_ID-10),-1,v_bill_pos.SUMMA_NDS20,0)) AS summa_prod_nds,
	 SUM(DECODE(SIGN(v_bill_pos.BILL_POS_ID-10),-1,v_bill_pos.SUMMA,0)) AS summa_prod,
	 SUM(DECODE(SIGN(v_bill_pos.BILL_POS_ID-10),-1,v_bill_pos.VES,0)) AS ves,
	 SUM(DECODE(v_bill_pos.BILL_POS_ID,11,v_bill_pos.SUMMA,12,v_bill_pos.SUMMA,0)) AS summa_agen,
	 SUM(DECODE(v_bill_pos.BILL_POS_ID,11,v_bill_pos.SUMMA_NDS20,12,v_bill_pos.SUMMA_NDS20,0)) AS summa_agen_nds,
	 SUM(DECODE(v_bill_pos.BILL_POS_ID,11,v_bill_pos.SUMMA,0)) AS summa_vozn_11,
	 SUM(DECODE(v_bill_pos.BILL_POS_ID,11,v_bill_pos.SUMMA_NDS20,0)) AS summa_vozn_11_nds,
	 SUM(DECODE(v_bill_pos.BILL_POS_ID,12,v_bill_pos.SUMMA,0)) AS summa_vozn_12,
	 SUM(DECODE(v_bill_pos.BILL_POS_ID,12,v_bill_pos.SUMMA_NDS20,0)) AS summa_vozn_12_nds,
	 SUM(DECODE(v_bill_pos.BILL_POS_ID,10,v_bill_pos.SUMMA,13,v_bill_pos.SUMMA,0)) AS summa_tarif,
	 SUM(DECODE(v_bill_pos.BILL_POS_ID,10,v_bill_pos.SUMMA_NDS20,13,v_bill_pos.SUMMA_NDS20,0)) AS summa_tarif_nds,
	 SUM(DECODE(v_bill_pos.BILL_POS_ID,20,v_bill_pos.SUMMA,0)) AS summa_strah,
	 SUM(v_bill_pos.SUMMA_NDS20) AS summa_dok_nds,
	 SUM(v_bill_pos.SUMMA) AS summa_dok
    FROM v_bill_pos
	WHERE v_bill_pos.SUMMA<>0
	GROUP BY
	  v_bill_pos.NOM_DOK
	  ,DECODE(SIGN(v_bill_pos.BILL_POS_ID-10),-1,DECODE(v_bill_pos.OWNERSHIP_ID,1,1,3),1)
    ) b_p,
	KLS_PREDPR PLAT, KLS_PREDPR SNP_PLAT, KLS_DOG, KLS_DOG SNP_DOG, KLS_PROD, KLS_PREDPR LUK_PLAT, KLS_DOG LUK_DOG, kls_dog_main
WHERE v_BILLS.NOM_DOK = KV.BILL_ID(+)
  AND v_BILLS.DOG_ID = KLS_DOG.ID
  AND KLS_DOG.PREDPR_ID = PLAT.ID
  AND V_BILLS.SNP_DOG_ID = SNP_DOG.ID
  AND SNP_DOG.PREDPR_ID = SNP_PLAT.ID
  AND v_BILLS.PROD_ID_NPR = KLS_PROD.ID_NPR
  AND v_BILLS.DATE_KVIT>=TO_DATE('01.01.2003','dd.mm.yyyy')
  AND v_BILLS.NOM_DOK = b_p.NOM_DOK(+)
  and v_bills.is_agent=kls_dog_main.is_agent
  and v_bills.date_kvit between kls_dog_main.from_date and kls_dog_main.to_date
  AND KLS_DOG_MAIN.DOG_ID=LUK_DOG.ID
  AND LUK_DOG.PREDPR_ID=LUK_PLAT.ID
--  AND (v_BILLS.PROD_ID_NPR<>'10001' OR v_BILLS.DATE_KVIT<=TO_DATE('31.12.2003','dd.mm.yyyy'))
  AND v_BILLS.PROD_ID_NPR<>'10041';


