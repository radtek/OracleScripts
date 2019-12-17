/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_BFUND_FUN_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_BFUND_FUN_FK_I ON MASTER.EUL_BQ_DEPS
(BFUND_FUN_ID)
TABLESPACE USERSINDX;


