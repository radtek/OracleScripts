-- 
-- Non Foreign Key Constraints for Table KLS_PRIORITY_MONTH_REESTR 
-- 
ALTER TABLE MASTER.KLS_PRIORITY_MONTH_REESTR ADD (
  CHECK ("NAME" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PRIORITY_MONTH_REESTR ADD (
  CONSTRAINT PK_KLS_MONTH_REESTR_PRIORITY
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.PK_KLS_MONTH_REESTR_PRIORITY
  ENABLE VALIDATE);

