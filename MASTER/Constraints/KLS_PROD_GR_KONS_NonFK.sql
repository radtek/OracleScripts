-- 
-- Non Foreign Key Constraints for Table KLS_PROD_GR_KONS 
-- 
ALTER TABLE MASTER.KLS_PROD_GR_KONS ADD (
  CHECK ("NAME" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PROD_GR_KONS ADD (
  CHECK ("ABBR" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PROD_GR_KONS ADD (
  CONSTRAINT PROD_GR_PK
  PRIMARY KEY
  (ID_GR)
  USING INDEX MASTER.PROD_GR_PK
  ENABLE VALIDATE);

