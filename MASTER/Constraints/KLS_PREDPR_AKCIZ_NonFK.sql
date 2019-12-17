-- 
-- Non Foreign Key Constraints for Table KLS_PREDPR_AKCIZ 
-- 
ALTER TABLE MASTER.KLS_PREDPR_AKCIZ ADD (
  CHECK ("PLAT_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PREDPR_AKCIZ ADD (
  CHECK ("DATE_BEG" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PREDPR_AKCIZ ADD (
  CHECK ("DATE_END" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PREDPR_AKCIZ ADD (
  CHECK ("EX_SVID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PREDPR_AKCIZ ADD (
  CONSTRAINT KLS_PREDPR_AKCIZ_PK
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.KLS_PREDPR_AKCIZ_PK
  ENABLE VALIDATE);

