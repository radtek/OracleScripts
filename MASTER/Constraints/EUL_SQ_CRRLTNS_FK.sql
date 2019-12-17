-- 
-- Foreign Key Constraints for Table EUL_SQ_CRRLTNS 
-- 
ALTER TABLE MASTER.EUL_SQ_CRRLTNS ADD (
  CONSTRAINT EUL_SQC_IT_I_FK 
  FOREIGN KEY (SQC_IT_INNER_ID) 
  REFERENCES MASTER.EUL_EXPRESSIONS (EXP_ID)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_SQ_CRRLTNS ADD (
  CONSTRAINT EUL_SQC_IT_O_FK 
  FOREIGN KEY (SQC_IT_OUTER_ID) 
  REFERENCES MASTER.EUL_EXPRESSIONS (EXP_ID)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_SQ_CRRLTNS ADD (
  CONSTRAINT EUL_SQC_SQ_FK 
  FOREIGN KEY (SQC_SQ_ID) 
  REFERENCES MASTER.EUL_SUB_QUERIES (SQ_ID)
  ENABLE NOVALIDATE);

