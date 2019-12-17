-- 
-- Non Foreign Key Constraints for Table KLS_PROD_PLAN 
-- 
ALTER TABLE MASTER.KLS_PROD_PLAN ADD (
  CHECK ("NAME_NPR" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PROD_PLAN ADD (
  CHECK ("ORDER_NPR" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PROD_PLAN ADD (
  CHECK ("FLG_ALLOWED" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.KLS_PROD_PLAN ADD (
  CONSTRAINT PROD_PLAN_PK
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.PROD_PLAN_PK
  ENABLE VALIDATE);

