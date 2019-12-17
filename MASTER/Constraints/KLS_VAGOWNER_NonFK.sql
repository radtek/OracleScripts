-- 
-- Non Foreign Key Constraints for Table KLS_VAGOWNER 
-- 
ALTER TABLE MASTER.KLS_VAGOWNER ADD (
  CHECK ("VAGOWNER_NAME" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_VAGOWNER ADD (
  CHECK ("PREDPR_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_VAGOWNER ADD (
  CHECK ("VAGOWN_TYP_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_VAGOWNER ADD (
  CHECK ("SOBSTV_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_VAGOWNER ADD (
  CHECK ("OWNER_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_VAGOWNER ADD (
  CONSTRAINT VAGOWNER_PK
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.VAGOWNER_PK
  ENABLE VALIDATE);

