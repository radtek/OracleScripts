-- 
-- Non Foreign Key Constraints for Table PLAN_FACT 
-- 
ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("TERMINAL_NAME" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("OSUSER_NAME" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("TIP_ROW" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("PLAN_MON_C" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("PLAN_MON_V" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("PLAN_MON_SOBS_C" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("PLAN_MON_SOBS_V" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("PLAN_NAR_C" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("PLAN_NAR_V" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("PLAN_NAR_SOBS_C" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("PLAN_NAR_SOBS_V" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("ZAYV" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("BEG_OST" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("FACT_C" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("FACT_V" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("FACT_SOBS_C" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("FACT_SOBS_V" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("MAX_VOL" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("DEAD_VOL" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("VOL" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("EMPTY_VOL" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("OST" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("FACT_DECADA_1" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("FACT_DECADA_2" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("FACT_DECADA_3" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("PLAN_DECADA_1" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("PLAN_DECADA_2" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("PLAN_DECADA_3" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CHECK ("NUM_DECADA" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PLAN_FACT ADD (
  CONSTRAINT PLAN_FACT_PK
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.PLAN_FACT_PK
  ENABLE VALIDATE);

