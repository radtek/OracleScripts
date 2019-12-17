--
-- V_FIN_OPER_INFO  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FIN_OPER_INFO
(END_DATE, PREDPR_NAME, SALDO_PREV_MONTHS, OTGR_PREV_DAY, PAYED_PREV_DAY, 
 PAYED_THIS_MONTH, OTGR_THIS_MONTH, OTGR_THIS_DAY)
AS 
SELECT 
  r.end_date,
  kls_predpr.PREDPR_NAME,
  SUM(saldo_prev_months) AS saldo_prev_months,
  SUM(otgr_prev_day) AS otgr_prev_day,
  SUM(payed_prev_day) AS payed_prev_day,
  SUM(payed_this_month) AS payed_this_month,
  SUM(otgr_this_month) AS otgr_this_month,
  SUM(otgr_this_day) AS otgr_this_day
  FROM ( 
	SELECT
	  kls_dog.ID AS dog_id,
	  SUM(NVL((CASE
	     WHEN payments.date_post<TRUNC(r.end_date,'Month') THEN payments.SUMMA
	    ELSE 0
	  END),0)) AS saldo_prev_months,
	  SUM(0) AS otgr_prev_day,
	  SUM(NVL((CASE
	     WHEN payments.date_post=r.end_date-1 THEN payments.SUMMA
	    ELSE 0
	  END),0)) AS payed_prev_day,
	  SUM(NVL((CASE
	     WHEN TRUNC(payments.date_post,'Month')=TRUNC(r.end_date,'Month') AND payments.date_post<r.end_date THEN payments.SUMMA
	    ELSE 0
	  END),0)) AS payed_this_month,
	  SUM(0) AS otgr_this_month,
	  SUM(0) AS otgr_this_day
	  FROM payments,kls_dog,(SELECT * FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='FINOPER_INFO.XLS') r
	  WHERE 
	    payments.DATE_POST<=r.end_date AND
		payments.DOG_ID=kls_dog.ID AND
		kls_dog.AGENT_ID in (8,4175)	
	  GROUP BY
	    kls_dog.ID 
	UNION ALL
	SELECT
	  kls_dog.ID AS dog_id,
	  SUM(NVL((CASE
	     WHEN bills.date_plat<TRUNC(r.end_date,'Month') THEN -bills.luk_summa_dok
	    ELSE 0
	  END),0)) AS saldo_prev_months,
	  SUM(NVL((CASE
	     WHEN bills.date_plat=r.end_date-1 THEN bills.luk_summa_dok
	    ELSE 0
	  END),0)) AS otgr_prev_day,
	  SUM(0) AS payed_prev_day,
	  SUM(0) AS payed_this_month,
	  SUM(NVL((CASE
	     WHEN TRUNC(bills.date_plat,'Month')=TRUNC(r.end_date,'Month') AND bills.date_plat<r.end_date THEN bills.luk_summa_dok
	    ELSE 0
	  END),0)) AS otgr_this_month,
	  SUM(NVL((CASE
	     WHEN bills.date_plat=r.end_date THEN bills.luk_summa_dok
	    ELSE 0
	  END),0)) AS otgr_this_day
	  FROM bills,kls_dog,(SELECT * FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='FINOPER_INFO.XLS') r
	  WHERE 
	    bills.DATE_PLAT<=r.end_date AND
		bills.DOG_ID=kls_dog.ID AND
		kls_dog.AGENT_ID in (8,4175)	
	  GROUP BY
	    kls_dog.ID) a,kls_dog,kls_predpr,(SELECT * FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='FINOPER_INFO.XLS') r
  WHERE a.dog_id=kls_dog.id AND
		kls_dog.predpr_id=kls_predpr.id
GROUP BY
  r.end_date,  
  kls_predpr.PREDPR_NAME
  order by kls_predpr.PREDPR_NAME;


