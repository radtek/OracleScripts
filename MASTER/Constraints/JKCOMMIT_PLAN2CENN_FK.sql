-- 
-- Foreign Key Constraints for Table JKCOMMIT_PLAN2CENN 
-- 
ALTER TABLE MASTER.JKCOMMIT_PLAN2CENN ADD (
  CONSTRAINT PLAN2CENN_CAT_CEN_FK 
  FOREIGN KEY (CAT_CEN_ID) 
  REFERENCES MASTER.KLS_CAT_CEN (ID)
  ENABLE NOVALIDATE);
