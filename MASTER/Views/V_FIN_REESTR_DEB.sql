--
-- V_FIN_REESTR_DEB  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FIN_REESTR_DEB
(DOG_ID, SUMMA_DOK, PROSR, DATE_PROSR, SUM_TO_PAY_THIS_MONTH, 
 SUMMA_PAYED)
AS 
SELECT /*+ ORDERED */
  bills.dog_id,
  NVL(SUM(bills.luk_summa_dok),0) AS summa_dok,
  NVL(SUM(CASE
            WHEN bills.date_plat<=r.end_date THEN bills.LUK_SUMMA_DOK
            ELSE 0
          END),0) AS prosr,
  MIN(CASE
        WHEN bills.luk_summa_dok<=NVL(b.summa,0) THEN TO_DATE('01.01.2050','dd.mm.yyyy')
		ELSE bills.date_plat
	  END) AS date_prosr,
  NVL(SUM(CASE
            WHEN TRUNC(bills.date_plat,'Month')=TRUNC(r.end_date,'Month') THEN bills.LUK_SUMMA_DOK
            ELSE 0
          END),0) AS sum_to_pay_this_month,
  NVL(SUM(NVL(b.summa,0)),0) AS summa_payed
  FROM
	(SELECT * FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='REESTR_DEBKRED.XLS') r,
	bills,
	(SELECT nom_dok,SUM(payments_on_bills.summa) AS summa FROM payments_on_bills,payments
       WHERE payments_on_bills.payments_id=payments.id and
	     payments_on_bills.date_realiz<=NVL(For_Temp.GET_AS_DATE('DATE_END','MASTER','REESTR_DEBKRED.XLS'),TRUNC(SYSDATE)) and  
	     payments.date_post<=NVL(For_Temp.GET_AS_DATE('DATE_END','MASTER','REESTR_DEBKRED.XLS'),TRUNC(SYSDATE))
		 GROUP BY nom_dok) b
    where
	  bills.nom_dok=b.nom_dok(+) and
	  bills.date_kvit>=TO_DATE('01.01.2005','dd.mm.yyyy') and
	  bills.date_kvit<=r.end_date
GROUP BY
  bills.dog_id;


