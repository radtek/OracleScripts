/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_BQD_BQ_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_BQD_BQ_FK_I ON MASTER.EUL_BQ_DEPS
(BQD_BQ_ID)
TABLESPACE USERSINDX;


