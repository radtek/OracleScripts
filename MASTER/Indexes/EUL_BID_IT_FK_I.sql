/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_BID_IT_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_BID_IT_FK_I ON MASTER.EUL_BQ_DEPS
(BID_IT_ID)
TABLESPACE USERSINDX;


