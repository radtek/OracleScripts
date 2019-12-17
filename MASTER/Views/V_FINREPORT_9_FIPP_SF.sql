--
-- V_FINREPORT_9_FIPP_SF  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FINREPORT_9_FIPP_SF
(PAYFORM_ID, GROUPDOG_ID, GOSPROG_ID, PREDPR_NAME, DOG_ID, 
 DATE_KVIT, DATE_BUXG, DATE_TO_OPL, SUMMA_DOK)
AS 
SELECT 
       NVL(DECODE(usl_dog.payform_id,0,10,usl_dog.payform_id),10),
	   NVL(kls_dog.groupdog_id,6),
	   NVL(month.gosprog_id,0),
	   kls_predpr.PREDPR_NAME,
       kls_dog.id,
	   v_bills.date_kvit,
	   v_bills.date_kvit, v_bills.DATE_KVIT+v_bills.KOL_DN, v_bills.summa_dok
  FROM v_bills,
       kls_dog,
       usl_dog,
       MONTH,
	   kls_predpr
 WHERE (    (kls_dog.id = v_bills.dog_id)
        AND (v_bills.dog_id = usl_dog.dog_id(+))
        AND (v_bills.usl_number = usl_dog.usl_number(+))
        AND (v_bills.nom_zd = MONTH.nom_zd(+))
		AND (kls_predpr.ID = kls_dog.PREDPR_ID)
		AND NOT (kls_dog.id=668 AND (v_bills.summa_dok=500 OR v_bills.summa_dok=600))
       )
UNION ALL
SELECT 
       NVL(DECODE(usl_dog.payform_id,0,10,usl_dog.payform_id),10),
	   1,
	   1,
	   kls_predpr.PREDPR_NAME,
       kls_dog.id,
	   v_bills.date_kvit,
	   v_bills.date_kvit, v_bills.DATE_KVIT+v_bills.KOL_DN, v_bills.summa_dok
  FROM v_bills,
       kls_dog,
       usl_dog,
       MONTH,
	   kls_predpr
 WHERE (    (kls_dog.id = v_bills.dog_id)
        AND (v_bills.dog_id = usl_dog.dog_id(+))
        AND (v_bills.usl_number = usl_dog.usl_number(+))
        AND (v_bills.nom_zd = MONTH.nom_zd(+))
		AND (kls_predpr.ID = kls_dog.PREDPR_ID)
		AND (kls_dog.id=668 AND (v_bills.summa_dok=500 OR v_bills.summa_dok=600))
       );


