-- 
-- Non Foreign Key Constraints for Table KLS_ST_PRIH_KONS 
-- 
ALTER TABLE MASTER.KLS_ST_PRIH_KONS ADD (
  CHECK ("NAME" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_ST_PRIH_KONS ADD (
  CONSTRAINT ST_PRIH_PK
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.ST_PRIH_PK
  ENABLE VALIDATE);
