-- 
-- Foreign Key Constraints for Table MONTH_VISIR 
-- 
ALTER TABLE MASTER.MONTH_VISIR ADD (
  CONSTRAINT MON_VISIR_APP_USERS_FK 
  FOREIGN KEY (APP_USERS_ID) 
  REFERENCES MASTER.APP_USERS (ID)
  ENABLE NOVALIDATE);

