--
-- V_STAN_PREDPR  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_STAN_PREDPR
(STAN_ID, PREDPR_ID, PREDPR_GDKOD)
AS 
SELECT /*+ INDEX(STAN_PREDPR STAN_PRED_STAN_PRED_UK) */ STAN_ID, PREDPR_ID, MAX(PREDPR_GDKOD) AS PREDPR_GDKOD
FROM STAN_PREDPR
GROUP BY STAN_ID,PREDPR_ID;

