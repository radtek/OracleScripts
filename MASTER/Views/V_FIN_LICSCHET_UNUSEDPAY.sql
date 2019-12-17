--
-- V_FIN_LICSCHET_UNUSEDPAY  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FIN_LICSCHET_UNUSEDPAY
(PREDPR_NAME, BEGIN_DATE, END_DATE, DOG_NUMBER, DOG_DATE, 
 PROD_NAME, NOM_DOK, NOM_SF, DATE_VYP_SF, SUMMA_DOK, 
 NUM_PLAT, DATE_PLAT, DATE_POST, SUMMA_PLAT, DATE_ORDER, 
 IS_SALDO)
AS 
SELECT
  d.predpr_name,
  r.begin_date,
  r.end_date,
  c.dog_number,
  c.dog_date,
  null as prod_name,
  null as nom_dok,
  null as nom_sf,
  null as date_vyp_sf,
  null as summa_dok,
  b.num_plat,
  b.date_plat,
  b.date_post,
  sum(a.summa) as summa_plat,
  TO_DATE(b.date_post) as date_order,
  DECODE(SIGN(b.date_post-r.begin_date),-1,1,0) as IS_SALDO
FROM
(
 SELECT
   payments.ID,
   payments.SUMMA
 FROM payments
 UNION ALL
 SELECT
   payments_on_bills.PAYMENTS_ID,
   -payments_on_bills.SUMMA
 FROM payments_on_bills
) a,payments b,kls_dog c,kls_predpr d, v_master_reports r
WHERE NLS_UPPER(TRIM(r.report_file))='LIC_SCHET.XLS' and
  a.id=b.id and
  b.dog_id=c.id and
  d.ID=c.PREDPR_ID and
  c.predpr_id=NVL(For_Temp.GET_AS_NUM('LC_PLAT','MASTER','LIC_SCHET.XLS'),0) and
  b.date_post<=r.end_date
GROUP BY
  c.dog_number,
  c.dog_date,
  b.num_plat,
  b.date_plat,
  b.date_post,
  d.predpr_name,
  r.begin_date,
  r.end_date;


