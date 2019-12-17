/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SQ_CRRLTNS  (Table) 
--
CREATE TABLE MASTER.EUL_SQ_CRRLTNS
(
  SQC_ID           NUMBER(10)                   NOT NULL,
  SQC_SQ_ID        NUMBER(10),
  SQC_IT_INNER_ID  NUMBER(10),
  SQC_IT_OUTER_ID  NUMBER(10),
  NOTM             NUMBER(10)
)
TABLESPACE USERS2
NOCOMPRESS ;


