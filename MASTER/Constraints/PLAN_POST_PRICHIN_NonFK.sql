-- 
-- Non Foreign Key Constraints for Table PLAN_POST_PRICHIN 
-- 
ALTER TABLE MASTER.PLAN_POST_PRICHIN ADD (
  CHECK ("BEG_DATE" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_POST_PRICHIN ADD (
  CHECK ("END_DATE" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_POST_PRICHIN ADD (
  CHECK ("PROD_ID_NPR" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_POST_PRICHIN ADD (
  CHECK ("PLANSTRU_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_POST_PRICHIN ADD (
  CHECK ("OWNER_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_POST_PRICHIN ADD (
  CONSTRAINT PLAN_POST_PRICHIN_PK
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.PLAN_POST_PRICHIN_PK
  ENABLE VALIDATE);
