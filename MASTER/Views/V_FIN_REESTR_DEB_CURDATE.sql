--
-- V_FIN_REESTR_DEB_CURDATE  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FIN_REESTR_DEB_CURDATE
(DOG_ID, SUMMA_DOK, PROSR, DATE_PROSR, SUM_TO_PAY_THIS_MONTH, 
 SUMMA_PAYED)
AS 
SELECT /*+ ORDERED */
  bills.dog_id,
  NVL(SUM(bills.luk_summa_dok),0) AS summa_dok,
  NVL(SUM(CASE
            WHEN bills.date_plat<=TRUNC(SYSDATE-1) THEN bills.LUK_SUMMA_DOK
            ELSE 0
          END),0) AS prosr,
  MIN(CASE
        WHEN bills.luk_summa_dok<=NVL(b.summa,0) THEN TO_DATE('01.01.2050','dd.mm.yyyy')
		ELSE bills.date_plat
	  END) AS date_prosr,
  NVL(SUM(CASE
            WHEN TRUNC(bills.date_plat,'Month')=TRUNC(SYSDATE-1,'Month') THEN bills.LUK_SUMMA_DOK
            ELSE 0
          END),0) AS sum_to_pay_this_month,
  NVL(SUM(NVL(b.summa,0)),0) AS summa_payed
  FROM
	bills,
	(SELECT nom_dok,SUM(payments_on_bills.summa) AS summa FROM payments_on_bills,payments
       WHERE payments_on_bills.payments_id=payments.id and
	     payments_on_bills.date_realiz<=TRUNC(SYSDATE-1) and  
	     payments.date_post<=TRUNC(SYSDATE-1)
		 GROUP BY nom_dok) b
    where
	  bills.nom_dok=b.nom_dok(+) and
	  bills.date_kvit>=TO_DATE('01.01.2005','dd.mm.yyyy') and
	  bills.date_kvit<=TRUNC(SYSDATE-1)
GROUP BY
  bills.dog_id;


