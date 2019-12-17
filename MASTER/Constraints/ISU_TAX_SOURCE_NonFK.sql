-- 
-- Non Foreign Key Constraints for Table ISU_TAX_SOURCE 
-- 
ALTER TABLE MASTER.ISU_TAX_SOURCE ADD (
  CONSTRAINT ISU_DOCSOURCE_PK
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.ISU_DOCSOURCE_PK
  ENABLE VALIDATE);

