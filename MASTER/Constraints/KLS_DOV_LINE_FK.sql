-- 
-- Foreign Key Constraints for Table KLS_DOV_LINE 
-- 
ALTER TABLE MASTER.KLS_DOV_LINE ADD (
  CONSTRAINT DOV_LINE_DOVER_FK 
  FOREIGN KEY (DOVER_ID) 
  REFERENCES MASTER.KLS_DOVER (ID)
  ENABLE NOVALIDATE);
