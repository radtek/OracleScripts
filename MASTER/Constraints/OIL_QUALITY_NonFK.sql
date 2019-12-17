-- 
-- Non Foreign Key Constraints for Table OIL_QUALITY 
-- 
ALTER TABLE MASTER.OIL_QUALITY ADD (
  CHECK ("PROD_ID_NPR" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.OIL_QUALITY ADD (
  CONSTRAINT OIL_QUALITY_PK
  PRIMARY KEY
  (OIL_QUALITY_ID)
  USING INDEX MASTER.OIL_QUALITY_PK
  ENABLE VALIDATE);

