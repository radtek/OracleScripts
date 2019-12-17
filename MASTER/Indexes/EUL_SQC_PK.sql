/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SQC_PK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_SQC_PK ON MASTER.EUL_SQ_CRRLTNS
(SQC_ID)
TABLESPACE USERSINDX;


