-- 
-- Foreign Key Constraints for Table EUL_BA_OBJ_LINKS 
-- 
ALTER TABLE MASTER.EUL_BA_OBJ_LINKS ADD (
  CONSTRAINT EUL_BOL_BA_FK 
  FOREIGN KEY (BOL_BA_ID) 
  REFERENCES MASTER.EUL_BUSINESS_AREAS (BA_ID)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_BA_OBJ_LINKS ADD (
  CONSTRAINT EUL_BOL_OBJ_FK 
  FOREIGN KEY (BOL_OBJ_ID) 
  REFERENCES MASTER.EUL_OBJS (OBJ_ID)
  ENABLE NOVALIDATE);
