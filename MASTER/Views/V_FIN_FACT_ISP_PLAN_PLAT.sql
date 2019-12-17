--
-- V_FIN_FACT_ISP_PLAN_PLAT  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FIN_FACT_ISP_PLAN_PLAT
(PER_TYPE, PREDPR_NAME, END_DATE, PAYED, OTGR)
AS 
SELECT
  DECODE(kls_predpr.PERTYPE_ID,
    3,'1. Лукойл-НПО (Договоры поставки)',
    1,'2. Предприятия нефтедобычи',
	  '3. Прочие покупатели') AS per_type,
  kls_predpr.PREDPR_NAME,
  MAX(c.end_date) AS end_date,
  SUM(payed) AS payed,
  SUM(otgr) AS otgr
  FROM kls_predpr,kls_dog, 
	(SELECT
	  payments.DOG_ID,
	  SUM(payments.SUMMA) AS payed
	  FROM payments,(SELECT * FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='FACT_ISP_PLAN_PLAT.XLS') r
	  WHERE payments.DATE_POST BETWEEN TRUNC(r.end_date,'Month') AND r.end_date
	  GROUP BY payments.DOG_ID) a,	  
	(SELECT
	  bills.DOG_ID,
	  SUM(bills.LUK_SUMMA_DOK) AS otgr
	  FROM bills,(SELECT * FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='FACT_ISP_PLAN_PLAT.XLS') r
	  WHERE bills.DATE_VYP_SF BETWEEN TRUNC(r.end_date,'Month') AND r.end_date
	  GROUP BY bills.DOG_ID) b,
    (SELECT * FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='FACT_ISP_PLAN_PLAT.XLS') c
  WHERE 
    kls_predpr.ID=kls_dog.PREDPR_ID AND
	kls_dog.AGENT_ID in (8,4175) AND
	kls_dog.ID=a.dog_id(+) AND
	kls_dog.ID=b.dog_id(+)
 GROUP BY
   DECODE(kls_predpr.PERTYPE_ID,
    3,'1. Лукойл-НПО (Договоры поставки)',
    1,'2. Предприятия нефтедобычи',
	  '3. Прочие покупатели'), 
   kls_predpr.PREDPR_NAME
 HAVING (SUM(payed) is not null) or (SUM(otgr) is not null)
 ORDER BY 1,2;


