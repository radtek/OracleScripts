-- 
-- Non Foreign Key Constraints for Table KLS_PREDPR 
-- 
ALTER TABLE MASTER.KLS_PREDPR ADD (
  CHECK ("PREDPR_NAME" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PREDPR ADD (
  CHECK ("REGION_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PREDPR ADD (
  CHECK ("HOLDING_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PREDPR ADD (
  CHECK ("PERTYPE_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PREDPR ADD (
  CHECK ("EX_SVID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PREDPR ADD (
  CHECK ("IS_BLOCK" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PREDPR ADD (
  CONSTRAINT PREDPR_PK
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.PREDPR_PK
  ENABLE VALIDATE);
