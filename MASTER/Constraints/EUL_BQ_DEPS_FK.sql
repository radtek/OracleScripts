-- 
-- Foreign Key Constraints for Table EUL_BQ_DEPS 
-- 
ALTER TABLE MASTER.EUL_BQ_DEPS ADD (
  CONSTRAINT EUL_BFILD_FIL_FK 
  FOREIGN KEY (BFILD_FIL_ID) 
  REFERENCES MASTER.EUL_EXPRESSIONS (EXP_ID)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_BQ_DEPS ADD (
  CONSTRAINT EUL_BFUND_FUN_FK 
  FOREIGN KEY (BFUND_FUN_ID) 
  REFERENCES MASTER.EUL_FUNCTIONS (FUN_ID)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_BQ_DEPS ADD (
  CONSTRAINT EUL_BID_IT_FK 
  FOREIGN KEY (BID_IT_ID) 
  REFERENCES MASTER.EUL_EXPRESSIONS (EXP_ID)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_BQ_DEPS ADD (
  CONSTRAINT EUL_BQD_BQ_FK 
  FOREIGN KEY (BQD_BQ_ID) 
  REFERENCES MASTER.EUL_BATCH_QUERIES (BQ_ID)
  ENABLE NOVALIDATE);
