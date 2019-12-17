-- 
-- Non Foreign Key Constraints for Table KLS_DOG_PARUS 
-- 
ALTER TABLE MASTER.KLS_DOG_PARUS ADD (
  CHECK ("BASE_NUMB" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_DOG_PARUS ADD (
  CHECK ("IS_AUTO_LINK" IS NOT NULL)
  DISABLE NOVALIDATE);
