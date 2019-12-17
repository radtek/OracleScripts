--
-- V_FINREPORT_9_FIPP_FACT  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FINREPORT_9_FIPP_FACT
(PAYFORM_ID, GROUPDOG_ID, GOSPROG_ID, PREDPR_ID, PREDPR_NAME, 
 DOG_ID, DATE_BUXG, DATE_TO_OPL, SUMMA_DOK)
AS 
SELECT 
       NVL(DECODE(usl_dog.payform_id,0,10,usl_dog.payform_id),10),
	   NVL(kls_dog.groupdog_id,6),
	   NVL(month.gosprog_id,0),
	   kls_predpr.ID,
	   kls_predpr.PREDPR_NAME,
       kls_dog.id,
	   v_bills_for_real_opl.date_buxg, 
	   v_bills_for_real_opl.DATE_KVIT+v_bills_for_real_opl.KOL_DN, 
	   r_o.summa_dok1
  FROM MASTER.real_opl r_o,
       v_bills_for_real_opl,
       kls_dog,
       usl_dog,
       MONTH,
	   kls_predpr
 WHERE (    (kls_dog.id = v_bills_for_real_opl.dog_id)
        AND (v_bills_for_real_opl.dog_id = usl_dog.dog_id(+))
        AND (v_bills_for_real_opl.usl_number = usl_dog.usl_number(+))
        AND (v_bills_for_real_opl.nom_zd = MONTH.nom_zd(+))
		AND (kls_predpr.ID = kls_dog.PREDPR_ID)
		AND (r_o.nom_dok=v_bills_for_real_opl.nom_dok(+))
		AND (r_o.close_date is null)
		AND NOT (kls_dog.id=668 AND (v_bills_for_real_opl.summa_dok=600 OR v_bills_for_real_opl.summa_dok=500))
       )
UNION ALL
SELECT 
       NVL(DECODE(usl_dog.payform_id,0,10,usl_dog.payform_id),10),
	   1,
	   1,
	   kls_predpr.ID,
	   kls_predpr.PREDPR_NAME,
       kls_dog.id,
	   v_bills_for_real_opl.date_buxg, v_bills_for_real_opl.DATE_KVIT+v_bills_for_real_opl.KOL_DN, r_o.summa_dok1
  FROM MASTER.real_opl r_o,
       v_bills_for_real_opl,
       kls_dog,
       usl_dog,
       MONTH,
	   kls_predpr
 WHERE (    (kls_dog.id = v_bills_for_real_opl.dog_id)
        AND (v_bills_for_real_opl.dog_id = usl_dog.dog_id(+))
        AND (v_bills_for_real_opl.usl_number = usl_dog.usl_number(+))
        AND (v_bills_for_real_opl.nom_zd = MONTH.nom_zd(+))
		AND (kls_predpr.ID = kls_dog.PREDPR_ID)
		AND (r_o.nom_dok=v_bills_for_real_opl.nom_dok(+))
		AND (r_o.close_date is null)
		AND (kls_dog.id=668 AND (v_bills_for_real_opl.summa_dok=600 OR v_bills_for_real_opl.summa_dok=500))
       );


