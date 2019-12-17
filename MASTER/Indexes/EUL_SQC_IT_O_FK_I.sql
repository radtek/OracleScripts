/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SQC_IT_O_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_SQC_IT_O_FK_I ON MASTER.EUL_SQ_CRRLTNS
(SQC_IT_OUTER_ID)
TABLESPACE USERSINDX;


