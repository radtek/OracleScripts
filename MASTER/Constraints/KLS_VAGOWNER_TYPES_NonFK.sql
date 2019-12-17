-- 
-- Non Foreign Key Constraints for Table KLS_VAGOWNER_TYPES 
-- 
ALTER TABLE MASTER.KLS_VAGOWNER_TYPES ADD (
  CHECK ("NAME" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_VAGOWNER_TYPES ADD (
  CONSTRAINT VAGOWN_TYP_PK
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.VAGOWN_TYP_PK
  ENABLE VALIDATE);

