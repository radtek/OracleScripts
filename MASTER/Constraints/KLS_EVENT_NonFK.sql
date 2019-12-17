-- 
-- Non Foreign Key Constraints for Table KLS_EVENT 
-- 
ALTER TABLE MASTER.KLS_EVENT ADD (
  CHECK ("EVENT_NAME" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_EVENT ADD (
  CONSTRAINT KLS_EVENT_PK
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.KLS_EVENT_PK
  ENABLE VALIDATE);

