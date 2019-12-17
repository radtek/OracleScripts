-- 
-- Non Foreign Key Constraints for Table KLS_VETKA 
-- 
ALTER TABLE MASTER.KLS_VETKA ADD (
  CHECK ("VETKA_NAME" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_VETKA ADD (
  CHECK ("IS_AUTO_LINK" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_VETKA ADD (
  CONSTRAINT VETKA_PK
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.VETKA_PK
  ENABLE VALIDATE);
