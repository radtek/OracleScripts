-- 
-- Non Foreign Key Constraints for Table ARH_DATE 
-- 
ALTER TABLE MASTER.ARH_DATE ADD (
  CONSTRAINT ARH_DATE_PK
  PRIMARY KEY
  (TABLENAME)
  USING INDEX MASTER.ARH_DATE_PK
  ENABLE VALIDATE);

