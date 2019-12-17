-- 
-- Non Foreign Key Constraints for Table KLS_PASP 
-- 
ALTER TABLE MASTER.KLS_PASP ADD (
  CHECK ("PROD_ID_NPR" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PASP ADD (
  CHECK ("MESTO_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PASP ADD (
  CHECK ("DATEUPLOAD" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PASP ADD (
  CHECK ("PASP_TYP" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PASP ADD (
  CHECK ("VZLIV" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PASP ADD (
  CONSTRAINT PASP_PK
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.PASP_PK
  ENABLE VALIDATE);

