-- 
-- Non Foreign Key Constraints for Table PARUS_NOMEN_PROD_LINK 
-- 
ALTER TABLE MASTER.PARUS_NOMEN_PROD_LINK ADD (
  CHECK ("NOMEN_RN" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PARUS_NOMEN_PROD_LINK ADD (
  CHECK ("PROD_ID_NPR" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PARUS_NOMEN_PROD_LINK ADD (
  CHECK ("IS_AUTO_LINK" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PARUS_NOMEN_PROD_LINK ADD (
  CHECK ("IS_MAIN" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PARUS_NOMEN_PROD_LINK ADD (
  CONSTRAINT PK_PARUS_NOMEN_PROD_LINK
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.PK_PARUS_NOMEN_PROD_LINK
  ENABLE VALIDATE);

