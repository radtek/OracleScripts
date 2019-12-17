-- 
-- Non Foreign Key Constraints for Table KLS_PREDPR_RS 
-- 
ALTER TABLE MASTER.KLS_PREDPR_RS ADD (
  CHECK ("PREDPR_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PREDPR_RS ADD (
  CHECK ("BANKS_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PREDPR_RS ADD (
  CHECK ("RS" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PREDPR_RS ADD (
  CHECK ("IS_MAIN" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PREDPR_RS ADD (
  CONSTRAINT PK_KLS_PREDPR_RS
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.PK_KLS_PREDPR_RS
  ENABLE VALIDATE);

