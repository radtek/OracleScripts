--
-- V_FIN_STRUCT_DEB  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FIN_STRUCT_DEB
(END_DATE, GROUP_ORDER, GROUP_ABBR, GROUP_NAME, SUMMA_DOK, 
 PROSR, PROSR45, PROSR90, PROSR365X3, SUMMA_DOK_LUK, 
 PROSR_LUK, PROSR45_LUK, PROSR90_LUK, PROSR365X3_LUK, SUMMA_PAYED, 
 SUMMA_PAYED_LUK)
AS 
SELECT /*+ RULE */ /* ORDERED INDEX(bill_pos BILL_POS_DATE_REALIZ) USE_NL(bill_pos,bills,b,KLS_PROD_GROUPS_DESC,KLS_PROD_GROUPS,KLS_DOG,KLS_PREDPR,c,r) */
  r.end_date,
  KLS_PROD_GROUPS.GROUP_ORDER,
  KLS_PROD_GROUPS.GROUP_ABBR,
  KLS_PROD_GROUPS.GROUP_NAME,
  NVL(SUM(bill_pos.SUMMA),0) AS summa_dok,
  NVL(SUM(DECODE(SIGN(bills.date_plat-r.end_date),1,0,bill_pos.SUMMA)),0) AS prosr,
  NVL(SUM(DECODE(SIGN(bills.date_plat-r.end_date+45),1,0,bill_pos.SUMMA)),0) AS prosr45,
  NVL(SUM(DECODE(SIGN(bills.date_plat-r.end_date+90),1,0,bill_pos.SUMMA)),0) AS prosr90,
  NVL(SUM(DECODE(SIGN(bills.date_plat-r.end_date+365*3),1,0,bill_pos.SUMMA)),0) AS prosr365x3,
  NVL(SUM(DECODE(c.holding_name,null,0,bill_pos.SUMMA)),0) AS summa_dok_luk,
  NVL(SUM(DECODE(c.holding_name,null,0,DECODE(SIGN(bills.date_plat-r.end_date),1,0,bill_pos.SUMMA))),0) AS prosr_luk,
  NVL(SUM(DECODE(c.holding_name,null,0,DECODE(SIGN(bills.date_plat-r.end_date+45),1,0,bill_pos.SUMMA))),0) AS prosr45_luk,
  NVL(SUM(DECODE(c.holding_name,null,0,DECODE(SIGN(bills.date_plat-r.end_date+90),1,0,bill_pos.SUMMA))),0) AS prosr90_luk,
  NVL(SUM(DECODE(c.holding_name,null,0,DECODE(SIGN(bills.date_plat-r.end_date+365*3),1,0,bill_pos.SUMMA))),0) AS prosr365x3_luk,
  NVL(SUM(NVL(b.summa,0)),0) AS summa_payed,
  NVL(SUM(DECODE(c.holding_name,null,0,NVL(b.summa,0))),0) AS summa_payed_luk
FROM bill_pos,bills,
	(SELECT nom_dok,payments_on_bills.BILL_POS_ID,SUM(payments_on_bills.summa) AS summa
	   FROM payments_on_bills,payments
       WHERE payments_on_bills.payments_id=payments.id and
	     payments.date_post<=(SELECT END_DATE FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='STRUCT_DEBZAD.XLS')
		 GROUP BY nom_dok,BILL_POS_ID) b,
    KLS_PROD_GROUPS_DESC,KLS_PROD_GROUPS,KLS_DOG,KLS_PREDPR,
	(select * FROM kls_holding c connect by prior id=boss start with c.id=40) c,
	(SELECT * FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='STRUCT_DEBZAD.XLS') r
where
	  bill_pos.DATE_REALIZ>=TO_DATE('01.01.2005','dd.mm.yyyy') and
	  bill_pos.is_luk=1 AND
	  bill_pos.nom_dok=b.nom_dok(+) and
	  bill_pos.bill_pos_id=b.bill_pos_id(+) and
	  bill_pos.PROD_ID_NPR=KLS_PROD_GROUPS_DESC.PROD_ID_NPR and
	  KLS_PROD_GROUPS_DESC.PROD_GROUPS_ID=KLS_PROD_GROUPS.ID and
	  KLS_PROD_GROUPS.PROD_TYPE_GRP_ID=10 and
	  bill_pos.NOM_DOK=bills.NOM_DOK and
	  bills.DOG_ID=kls_dog.id and
	  kls_dog.PREDPR_ID=kls_predpr.id and
	  kls_predpr.HOLDING_ID=c.id(+) and
	  bills.date_kvit<=r.end_date
GROUP BY
  r.end_date,
  KLS_PROD_GROUPS.GROUP_ORDER,
  KLS_PROD_GROUPS.GROUP_ABBR,
  KLS_PROD_GROUPS.GROUP_NAME;


