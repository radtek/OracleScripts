/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_BQD_BQD1_UK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_BQD_BQD1_UK ON MASTER.EUL_BQ_DEPS
(BQD_TYPE, BQD_BQ_ID, BFILD_FIL_ID, BID_IT_ID, BFUND_FUN_ID)
TABLESPACE USERSINDX;


