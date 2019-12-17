-- 
-- Non Foreign Key Constraints for Table TEMP_PAYMENTS_TO_BILLS 
-- 
ALTER TABLE MASTER.TEMP_PAYMENTS_TO_BILLS ADD (
  CHECK ("PAYMENTS_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.TEMP_PAYMENTS_TO_BILLS ADD (
  CHECK ("NOM_DOK" IS NOT NULL)
  DISABLE NOVALIDATE);

