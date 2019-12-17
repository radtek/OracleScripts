/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SQ_PK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_SQ_PK ON MASTER.EUL_SUB_QUERIES
(SQ_ID)
TABLESPACE USERSINDX;


