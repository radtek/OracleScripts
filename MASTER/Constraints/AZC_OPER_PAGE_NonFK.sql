-- 
-- Non Foreign Key Constraints for Table AZC_OPER_PAGE 
-- 
ALTER TABLE MASTER.AZC_OPER_PAGE ADD (
  CONSTRAINT PK_AZC_OPER_PAGE
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.PK_AZC_OPER_PAGE
  ENABLE VALIDATE);

