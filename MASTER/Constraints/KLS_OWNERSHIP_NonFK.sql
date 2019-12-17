-- 
-- Non Foreign Key Constraints for Table KLS_OWNERSHIP 
-- 
ALTER TABLE MASTER.KLS_OWNERSHIP ADD (
  CHECK ("OWNERSHIP_NAME" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_OWNERSHIP ADD (
  CONSTRAINT OWNERSHIP_PK
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.OWNERSHIP_PK
  ENABLE VALIDATE);

