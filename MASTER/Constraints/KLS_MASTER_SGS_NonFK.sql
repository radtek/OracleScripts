-- 
-- Non Foreign Key Constraints for Table KLS_MASTER_SGS 
-- 
ALTER TABLE MASTER.KLS_MASTER_SGS ADD (
  CHECK ("ID" IS NOT NULL)
  DISABLE NOVALIDATE);
