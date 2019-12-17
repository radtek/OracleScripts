-- 
-- Foreign Key Constraints for Table EUL_BATCH_REPORTS 
-- 
ALTER TABLE MASTER.EUL_BATCH_REPORTS ADD (
  CONSTRAINT EUL_BR_EU_FK 
  FOREIGN KEY (BR_EU_ID) 
  REFERENCES MASTER.EUL_EUL_USERS (EU_ID)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_BATCH_REPORTS ADD (
  CONSTRAINT EUL_BR_RFU_FK 
  FOREIGN KEY (BR_RFU_ID) 
  REFERENCES MASTER.EUL_FREQ_UNITS (RFU_ID)
  ENABLE NOVALIDATE);

