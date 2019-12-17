/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_BQD_PK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_BQD_PK ON MASTER.EUL_BQ_DEPS
(BQD_ID)
TABLESPACE USERSINDX;


