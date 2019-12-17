-- 
-- Non Foreign Key Constraints for Table OIL_PLAN 
-- 
ALTER TABLE MASTER.OIL_PLAN ADD (
  CHECK ("SOBSTVEN" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.OIL_PLAN ADD (
  CHECK ("POSTAV" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.OIL_PLAN ADD (
  CHECK ("PER" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.OIL_PLAN ADD (
  CHECK ("MESTOR" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.OIL_PLAN ADD (
  CHECK ("ID_PROD_NPR" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.OIL_PLAN ADD (
  CONSTRAINT OIL_PLAN_PK
  PRIMARY KEY
  (KOD)
  USING INDEX MASTER.OIL_PLAN_PK
  ENABLE VALIDATE);
