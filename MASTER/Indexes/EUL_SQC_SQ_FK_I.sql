/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SQC_SQ_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_SQC_SQ_FK_I ON MASTER.EUL_SQ_CRRLTNS
(SQC_SQ_ID)
TABLESPACE USERSINDX;


