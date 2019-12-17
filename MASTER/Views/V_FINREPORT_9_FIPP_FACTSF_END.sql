--
-- V_FINREPORT_9_FIPP_FACTSF_END  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FINREPORT_9_FIPP_FACTSF_END
(PAYFORM_ID, GROUPDOG_ID, GOSPROG_ID, PREDPR_NAME, DOG_ID, 
 DATE_BUXG, DATE_TO_OPL, SUMMA_DOK)
AS 
SELECT 
       payform_id,
	   groupdog_id,
	   0,
	   PREDPR_NAME,
       dog_id,
	   date_buxg, DATE_TO_OPL, summa_dok
FROM v_finreport_9_fipp_factSF
WHERE NOT (gosprog_id=1 OR gosprog_id=2 OR gosprog_id=6)  
UNION ALL
SELECT 
       payform_id,
	   1,
	   gosprog_id,
	   PREDPR_NAME,
       dog_id,
	   date_buxg, DATE_TO_OPL, summa_dok
FROM v_finreport_9_fipp_factSF
WHERE (gosprog_id=1 OR gosprog_id=2 OR gosprog_id=6);


