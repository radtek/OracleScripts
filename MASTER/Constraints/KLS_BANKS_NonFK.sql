-- 
-- Non Foreign Key Constraints for Table KLS_BANKS 
-- 
ALTER TABLE MASTER.KLS_BANKS ADD (
  CHECK ("KORS" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_BANKS ADD (
  CHECK ("BANK_NAME" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_BANKS ADD (
  CONSTRAINT BANKS_PK
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.BANKS_PK
  ENABLE VALIDATE);

