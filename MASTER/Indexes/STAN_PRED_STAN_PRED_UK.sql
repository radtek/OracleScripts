--
-- STAN_PRED_STAN_PRED_UK  (Index) 
--
CREATE UNIQUE INDEX MASTER.STAN_PRED_STAN_PRED_UK ON MASTER.STAN_PREDPR
(STAN_ID, PREDPR_ID, VETKA_ID)
TABLESPACE USERSINDX;


