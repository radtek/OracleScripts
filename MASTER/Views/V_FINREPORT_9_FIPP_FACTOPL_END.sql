--
-- V_FINREPORT_9_FIPP_FACTOPL_END  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_FINREPORT_9_FIPP_FACTOPL_END
(PAYFORM_ID, GROUPDOG_ID, GOSPROG_ID, PREDPR_NAME, DOG_ID, 
 DATA_POST, SUMMA)
AS 
SELECT 
       payform_id,
	   groupdog_id,
	   0,
	   PREDPR_NAME,
       dog_id,
	   data_post, 
	   summa
FROM v_finreport_9_fipp_factOPL
WHERE NOT (gosprog_id=1 OR gosprog_id=2 OR gosprog_id=6)  
UNION ALL
SELECT 
       payform_id,
	   1,
	   gosprog_id,
	   PREDPR_NAME,
       dog_id,
	   data_post, 
	   summa
FROM v_finreport_9_fipp_factOPL
WHERE (gosprog_id=1 OR gosprog_id=2 OR gosprog_id=6);


