-- 
-- Non Foreign Key Constraints for Table KLS_PREDPR_CONTACTS 
-- 
ALTER TABLE MASTER.KLS_PREDPR_CONTACTS ADD (
  CHECK ("PREDPR_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PREDPR_CONTACTS ADD (
  CONSTRAINT PK_KLS_PREDPR_CONTACTS
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.PK_KLS_PREDPR_CONTACTS
  ENABLE VALIDATE);

