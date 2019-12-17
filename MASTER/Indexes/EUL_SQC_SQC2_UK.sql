/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SQC_SQC2_UK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_SQC_SQC2_UK ON MASTER.EUL_SQ_CRRLTNS
(SQC_SQ_ID, SQC_IT_INNER_ID, SQC_IT_OUTER_ID)
TABLESPACE USERSINDX;


