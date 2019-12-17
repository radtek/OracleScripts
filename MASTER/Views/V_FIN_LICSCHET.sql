--
-- V_FIN_LICSCHET  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FIN_LICSCHET
(PREDPR_NAME, BEGIN_DATE, END_DATE, DOG_NUMBER, DOG_DATE, 
 PROD_NAME, IS_SALDO, NOM_DOK, NOM_SF, DATE_VYP_SF, 
 SUMMA_DOK, NUM_PLAT, DATE_PLAT, DATE_POST, SUMMA_PLAT, 
 DATE_ORDER)
AS 
SELECT 
  A.predpr_name, 
  A.begin_date, 
  A.end_date, 
  A.dog_number, 
  A.dog_date, 
  DECODE(A.IS_SALDO,1,'Сальдо на начало периода',A.PROD_NAME) AS PROD_NAME, 
  A.IS_SALDO, 
  DECODE(A.IS_SALDO,1,0,A.nom_dok) AS NOM_DOK, 
  DECODE(A.IS_SALDO,1,0,A.nom_sf) AS NOM_SF, 
  DECODE(A.IS_SALDO,1,a.begin_date-1,A.date_vyp_sf) AS date_vyp_sf, 
  SUM(A.summa_dok) AS summa_dok, 
  DECODE(A.IS_SALDO,1,'0',A.num_plat) AS num_plat, 
  DECODE(A.IS_SALDO,1,a.begin_date-1,A.date_plat) AS date_plat, 
  DECODE(A.IS_SALDO,1,a.begin_date-1,A.date_post) AS date_post, 
  SUM(A.summa_plat) AS summa_plat, 
  DECODE(A.IS_SALDO,1,A.begin_date-1,A.date_order) AS DATE_ORDER 
FROM 
( 
SELECT /*+ ORDERED */ 
  KLS_PREDPR.predpr_name, 
  r.begin_date, 
  r.end_date, 
  KLS_DOG.dog_number, 
  KLS_DOG.dog_date, 
  KLS_PROD.long_name_npr AS PROD_NAME, 
  b1.nom_dok, 
  b1.nom_sf, 
  b1.date_vyp_sf, 
  b1.luk_summa_dok AS summa_dok, 
  p1.num_plat, 
  p1.date_plat, 
  p1.date_post, 
  p1.summa_plat, 
  b1.date_kvit AS DATE_ORDER, 
  DECODE(SIGN(b1.date_kvit-r.begin_date),-1,1,0) AS IS_SALDO 
  FROM BILLS b1,KLS_DOG,KLS_PROD,KLS_PREDPR,v_master_reports r, 
  (SELECT 
     PAYMENTS_ON_BILLS.nom_dok, 
     PAYMENTS_ON_BILLS.payments_id, 
     PAYMENTS.num_plat, 
     PAYMENTS.date_plat, 
     PAYMENTS.date_post, 
     SUM(PAYMENTS_ON_BILLS.SUMMA) AS summa_plat 
     FROM PAYMENTS_ON_BILLS,PAYMENTS,v_master_reports r 
     WHERE NLS_UPPER(TRIM(r.report_file))='LIC_SCHET.XLS' AND 
       PAYMENTS_ON_BILLS.payments_id=PAYMENTS.id AND 
	   PAYMENTS.date_post<=r.end_date 
     GROUP BY 
       PAYMENTS_ON_BILLS.nom_dok, 
       PAYMENTS_ON_BILLS.payments_id, 
       PAYMENTS.num_plat, 
       PAYMENTS.date_plat, 
       PAYMENTS.date_post) p1 
  WHERE NLS_UPPER(TRIM(r.report_file))='LIC_SCHET.XLS' AND 
    b1.nom_dok=p1.nom_dok(+) AND 
	b1.dog_id=KLS_DOG.id AND 
	KLS_DOG.predpr_id=KLS_PREDPR.id AND 
	KLS_DOG.AGENT_ID in (8,4175) AND 
	b1.prod_id_npr=KLS_PROD.id_npr AND 
    b1.dog_id IN (SELECT id FROM KLS_DOG WHERE predpr_id=NVL(For_Temp.GET_AS_NUM('LC_PLAT','MASTER','LIC_SCHET.XLS'),0)) AND 
	b1.date_kvit>=TO_DATE('01.01.2005','dd.mm.yyyy') AND 
	b1.date_kvit<=r.end_date 
    AND KLS_PROD.ID_GROUP_NPR>=DECODE(r.GRP_ID_NPR,'*','00000',r.GRP_ID_NPR) 
    AND KLS_PROD.ID_GROUP_NPR<=DECODE(r.GRP_ID_NPR,'10100','99999','*','99999',r.GRP_ID_NPR) 
	AND b1.is_korr<>2 AND b1.to_korr<>-2 -- Без сторнированного и сторнирующего 
UNION ALL 
  SELECT * 
  FROM V_FIN_LICSCHET_UNUSEDPAY WHERE SUMMA_PLAT<>0 
) a 
GROUP BY 
  A.predpr_name, 
  A.begin_date, 
  A.end_date, 
  A.dog_number, 
  A.dog_date, 
  A.IS_SALDO, 
  DECODE(A.IS_SALDO,1,'Сальдо на начало периода',A.PROD_NAME), 
  DECODE(A.IS_SALDO,1,0,A.nom_dok), 
  DECODE(A.IS_SALDO,1,0,A.nom_sf), 
  DECODE(A.IS_SALDO,1,a.begin_date-1,A.date_vyp_sf), 
  DECODE(A.IS_SALDO,1,a.begin_date-1,A.date_plat), 
  DECODE(A.IS_SALDO,1,'0',A.num_plat), 
  DECODE(A.IS_SALDO,1,a.begin_date-1,A.date_post), 
  DECODE(A.IS_SALDO,1,A.begin_date-1,A.date_order);


