--
-- V_AGENT_REPORT_2004  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_AGENT_REPORT_2004
(DATE_AGENT, DOG_NUMBER, DOG_DATE, PREDPR_NAME, VES, 
 SUM_TARIF_AREND_BN, SUM_TARIF_AREND_NDS, SUM_TARIF_AREND, SUM_TARIF_BN, SUM_TARIF_NDS, 
 SUM_TARIF, SUM_VOZN_10001_BN, SUM_VOZN_10001_NDS, SUM_VOZN_10001, SUM_VOZN_BN, 
 SUM_VOZN_NDS, SUM_VOZN, SUM_USL_AREND_BN, SUM_USL_AREND_NDS, SUM_USL_AREND, 
 SUM_USL_BN, SUM_USL_NDS, SUM_USL, SUM_VOZN_GD_BN, SUM_VOZN_GD_NDS, 
 SUM_VOZN_GD, SUM_STRAH)
AS 
SELECT
  LAST_DAY(v_bills.DATE_VYP_SF) AS date_agent,
  kls_dog.DOG_NUMBER,
  kls_dog.dog_date,
  kls_predpr.PREDPR_NAME,
  SUM(v_bill_pos_flat.VES) AS ves,
  -- Тариф по транспортировке в аренд.вагонах
  SUM(CASE
	     WHEN usl_dog.vid_usl_id=7 AND NVL(v_bill_pos_flat.VOZN12_BN,0)<>0 AND kls_dog.DOG_NUMBER='0311176' THEN v_bill_pos_flat.TARIF_BN+v_bill_pos_flat.TARIF_GUARD_BN
		 ELSE 0
	  END) AS sum_tarif_arend_bn,
  SUM(CASE
	     WHEN usl_dog.vid_usl_id=7 AND NVL(v_bill_pos_flat.VOZN12_BN,0)<>0 AND kls_dog.DOG_NUMBER='0311176' THEN v_bill_pos_flat.TARIF_NDS+v_bill_pos_flat.TARIF_GUARD_NDS
		 ELSE 0
	  END) AS sum_tarif_arend_nds,
  SUM(CASE
	     WHEN usl_dog.vid_usl_id=7 AND NVL(v_bill_pos_flat.VOZN12_BN,0)<>0 AND kls_dog.DOG_NUMBER='0311176' THEN v_bill_pos_flat.TARIF+v_bill_pos_flat.TARIF_GUARD
		 ELSE 0
	  END) AS sum_tarif_arend,
  -- Тариф
  SUM(CASE
	     WHEN usl_dog.vid_usl_id=7 AND NVL(v_bill_pos_flat.VOZN12_BN,0)<>0 AND kls_dog.DOG_NUMBER='0311176' THEN 0
		 ELSE v_bill_pos_flat.TARIF_BN+v_bill_pos_flat.TARIF_GUARD_BN
	  END) AS sum_tarif_bn,
  SUM(CASE
	     WHEN usl_dog.vid_usl_id=7 AND NVL(v_bill_pos_flat.VOZN12_BN,0)<>0 AND kls_dog.DOG_NUMBER='0311176' THEN 0
		 ELSE v_bill_pos_flat.TARIF_NDS+v_bill_pos_flat.TARIF_GUARD_NDS
	  END) AS sum_tarif_nds,
  SUM(CASE
	     WHEN usl_dog.vid_usl_id=7 AND NVL(v_bill_pos_flat.VOZN12_BN,0)<>0 AND kls_dog.DOG_NUMBER='0311176' THEN 0
		 ELSE v_bill_pos_flat.TARIF+v_bill_pos_flat.TARIF_GUARD
	  END) AS sum_tarif,
  -- Вознаграждение по ИВР
  SUM(CASE
	     WHEN v_bills.IS_AGENT<>2 AND v_bills.PROD_ID_NPR='10001' THEN v_bill_pos_flat.VOZN11_BN+v_bill_pos_flat.VOZN12_BN
		 ELSE 0
	  END) AS sum_vozn_10001_bn,
  SUM(CASE
	     WHEN v_bills.IS_AGENT<>2 AND v_bills.PROD_ID_NPR='10001' THEN v_bill_pos_flat.VOZN11_NDS+v_bill_pos_flat.VOZN12_NDS
		 ELSE 0
	  END) AS sum_vozn_10001_NDS,
  SUM(CASE
	     WHEN v_bills.IS_AGENT<>2 AND v_bills.PROD_ID_NPR='10001' THEN v_bill_pos_flat.VOZN11+v_bill_pos_flat.VOZN12
		 ELSE 0
	  END) AS sum_vozn_10001,
  -- Вознаграждение
  SUM(CASE
	     WHEN NOT(usl_dog.vid_usl_id=7 AND kls_dog.DOG_NUMBER='0311176') AND v_bills.IS_AGENT<>2 AND v_bills.PROD_ID_NPR<>'10001' THEN v_bill_pos_flat.VOZN11_BN+v_bill_pos_flat.VOZN12_BN
		 ELSE 0
	  END) AS sum_vozn_bn,
  SUM(CASE
	     WHEN NOT(usl_dog.vid_usl_id=7 AND kls_dog.DOG_NUMBER='0311176') AND v_bills.IS_AGENT<>2 AND v_bills.PROD_ID_NPR<>'10001' THEN v_bill_pos_flat.VOZN11_NDS+v_bill_pos_flat.VOZN12_NDS
		 ELSE 0
	  END) AS sum_vozn_NDS,
  SUM(CASE
	     WHEN NOT(usl_dog.vid_usl_id=7 AND kls_dog.DOG_NUMBER='0311176') AND v_bills.IS_AGENT<>2 AND v_bills.PROD_ID_NPR<>'10001' THEN v_bill_pos_flat.VOZN11+v_bill_pos_flat.VOZN12
		 ELSE 0
	  END) AS sum_vozn,
  -- Услуги по организации транспортировки в аренд вагонах
  SUM(CASE
	     WHEN usl_dog.vid_usl_id=7 AND NVL(v_bill_pos_flat.VOZN12_BN,0)<>0 AND kls_dog.DOG_NUMBER='0311176' AND v_bills.IS_AGENT<>2 AND v_bills.PROD_ID_NPR<>'10001' THEN v_bill_pos_flat.VOZN11_BN+v_bill_pos_flat.VOZN12_BN
		 ELSE 0
	  END) AS sum_usl_arend_bn,
  SUM(CASE
	     WHEN usl_dog.vid_usl_id=7 AND NVL(v_bill_pos_flat.VOZN12_BN,0)<>0 AND kls_dog.DOG_NUMBER='0311176' AND v_bills.IS_AGENT<>2 AND v_bills.PROD_ID_NPR<>'10001' THEN v_bill_pos_flat.VOZN11_NDS+v_bill_pos_flat.VOZN12_NDS
		 ELSE 0
	  END) AS sum_usl_arend_NDS,
  SUM(CASE
	     WHEN usl_dog.vid_usl_id=7 AND NVL(v_bill_pos_flat.VOZN12_BN,0)<>0 AND kls_dog.DOG_NUMBER='0311176' AND v_bills.IS_AGENT<>2 AND v_bills.PROD_ID_NPR<>'10001' THEN v_bill_pos_flat.VOZN11+v_bill_pos_flat.VOZN12
		 ELSE 0
	  END) AS sum_usl_arend,
  -- Услуги по организации транспортировки в вагонах МПС
  SUM(CASE
	     WHEN usl_dog.vid_usl_id=7 AND NVL(v_bill_pos_flat.VOZN12_BN,0)=0 AND kls_dog.DOG_NUMBER='0311176' AND v_bills.IS_AGENT<>2 AND v_bills.PROD_ID_NPR<>'10001' THEN v_bill_pos_flat.VOZN11_BN+v_bill_pos_flat.VOZN12_BN
		 ELSE 0
	  END) AS sum_usl_bn,
  SUM(CASE
	     WHEN usl_dog.vid_usl_id=7 AND NVL(v_bill_pos_flat.VOZN12_BN,0)=0 AND kls_dog.DOG_NUMBER='0311176' AND v_bills.IS_AGENT<>2 AND v_bills.PROD_ID_NPR<>'10001' THEN v_bill_pos_flat.VOZN11_NDS+v_bill_pos_flat.VOZN12_NDS
		 ELSE 0
	  END) AS sum_usl_NDS,
  SUM(CASE
	     WHEN usl_dog.vid_usl_id=7 AND NVL(v_bill_pos_flat.VOZN12_BN,0)=0 AND kls_dog.DOG_NUMBER='0311176' AND v_bills.IS_AGENT<>2 AND v_bills.PROD_ID_NPR<>'10001' THEN v_bill_pos_flat.VOZN11+v_bill_pos_flat.VOZN12
		 ELSE 0
	  END) AS sum_usl,
  -- Услуги предоставлению вагонов
  SUM(CASE
	     WHEN v_bills.IS_AGENT=2 THEN v_bill_pos_flat.VOZN11_BN+v_bill_pos_flat.VOZN12_BN
		 ELSE 0
	  END) AS sum_vozn_gd_bn,
  SUM(CASE
	     WHEN v_bills.IS_AGENT=2 THEN v_bill_pos_flat.VOZN11_NDS+v_bill_pos_flat.VOZN12_NDS
		 ELSE 0
	  END) AS sum_vozn_gd_NDS,
  SUM(CASE
	     WHEN v_bills.IS_AGENT=2 THEN v_bill_pos_flat.VOZN11+v_bill_pos_flat.VOZN12
		 ELSE 0
	  END) AS sum_vozn_gd,
  SUM(v_bill_pos_flat.STRAH) AS sum_strah
 FROM v_bills_fin_snp v_bills,v_bill_pos_flat_fin_snp v_bill_pos_flat,kls_dog,kls_predpr,usl_dog,V_MASTER_REPORTS
 WHERE
   v_bills.DOG_ID=kls_dog.id and
   v_bills.NOM_DOK=v_bill_pos_flat.NOM_DOK and
   kls_dog.PREDPR_ID=kls_predpr.ID and
   v_bills.DATE_VYP_SF>=TO_DATE('01.01.2004','dd.mm.yyyy') and
   v_bill_pos_flat.DATE_REALIZ>=TO_DATE('01.01.2004','dd.mm.yyyy') and
   kls_dog.dog_number LIKE V_MASTER_REPORTS.DOG_NUMBER and
   v_bills.DATE_VYP_SF between begin_date AND end_date and
   NLS_UPPER(V_MASTER_REPORTS.REPORT_FILE)='OTCH_AGENT_2004.XLS'
   AND (v_bills.PROD_ID_NPR='10001' OR
        v_bills.PROD_ID_NPR>='10100')
   AND v_bills.DOG_ID=usl_dog.DOG_ID(+)
   AND v_bills.USL_NUMBER=usl_dog.USL_NUMBER(+)
   AND v_bills.IS_AGENT IN (1,2)
 GROUP BY
   LAST_DAY(v_bills.DATE_VYP_SF),
   kls_dog.DOG_NUMBER,
   kls_dog.dog_date,
   kls_predpr.PREDPR_NAME;


