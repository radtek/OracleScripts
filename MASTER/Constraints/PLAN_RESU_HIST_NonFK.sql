-- 
-- Non Foreign Key Constraints for Table PLAN_RESU_HIST 
-- 
ALTER TABLE MASTER.PLAN_RESU_HIST ADD (
  CHECK ("PLAN_UTMSK" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_RESU_HIST ADD (
  CHECK ("HRAN_UTMSK" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_RESU_HIST ADD (
  CHECK ("OSTAT_UTMSK" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_RESU_HIST ADD (
  CHECK ("PLAN_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_RESU_HIST ADD (
  CHECK ("PLAN_PER_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_RESU_HIST ADD (
  CHECK ("PROD_ID_NPR" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_RESU_HIST ADD (
  CHECK ("SOBSTV_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_RESU_HIST ADD (
  CHECK ("REFINER_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_RESU_HIST ADD (
  CONSTRAINT PL_RES_HST_PK
  PRIMARY KEY
  (ID, NUM_IZM)
  USING INDEX MASTER.PL_RES_HST_PK
  ENABLE VALIDATE);

