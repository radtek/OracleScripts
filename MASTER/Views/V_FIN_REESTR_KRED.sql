--
-- V_FIN_REESTR_KRED  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FIN_REESTR_KRED
(DOG_ID, SUMMA_KRED, SUM_PAYED_THIS_MONTH)
AS 
SELECT
  b.dog_id,
  sum(a.summa) as summa_kred,
  sum(sum_payed_this_month) AS sum_payed_this_month
  FROM
(
SELECT
  payments.ID,
  payments.SUMMA,
  NVL((CASE
     WHEN TRUNC(payments.date_post,'Month')=TRUNC(r.end_date,'Month') THEN payments.SUMMA
    ELSE 0
  END),0) AS sum_payed_this_month
  FROM payments,(SELECT * FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='REESTR_DEBKRED.XLS') r
  WHERE payments.DATE_POST<=r.end_date
UNION ALL
SELECT
  pb.PAYMENTS_ID,
  -pb.SUMMA,
  0
  FROM payments_on_bills pb, (SELECT * FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='REESTR_DEBKRED.XLS') r
  where pb.date_realiz<=r.end_date
) a,payments b, (SELECT * FROM V_MASTER_REPORTS WHERE NLS_UPPER(REPORT_FILE)='REESTR_DEBKRED.XLS') r
  WHERE a.id=b.id AND
    b.date_post<=r.END_DATE
  GROUP BY b.dog_id
--  HAVING sum(a.summa)>0;;
;


