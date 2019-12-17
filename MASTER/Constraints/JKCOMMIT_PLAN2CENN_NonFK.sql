-- 
-- Non Foreign Key Constraints for Table JKCOMMIT_PLAN2CENN 
-- 
ALTER TABLE MASTER.JKCOMMIT_PLAN2CENN ADD (
  CONSTRAINT PLAN2CENN_PK
  PRIMARY KEY
  (CAT_CEN_ID, PLANSTRU_ID)
  USING INDEX MASTER.PLAN2CENN_PK
  ENABLE VALIDATE);

