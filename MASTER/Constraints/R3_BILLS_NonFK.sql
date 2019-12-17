-- 
-- Non Foreign Key Constraints for Table R3_BILLS 
-- 
ALTER TABLE MASTER.R3_BILLS ADD (
  CHECK ("NOM_R3" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.R3_BILLS ADD (
  CHECK ("SUMMA_DOK" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.R3_BILLS ADD (
  CHECK ("SUMMA_PROD" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.R3_BILLS ADD (
  CHECK ("SUMMA_PROD_NDS" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.R3_BILLS ADD (
  CHECK ("SUMMA_AKCIZ" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.R3_BILLS ADD (
  CHECK ("SUMMA_TARIF" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.R3_BILLS ADD (
  CHECK ("SUMMA_TARIF_NDS" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.R3_BILLS ADD (
  CHECK ("SUMMA_VOZN" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.R3_BILLS ADD (
  CHECK ("SUMMA_VOZN_NDS" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.R3_BILLS ADD (
  CHECK ("SUMMA_STRAH" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.R3_BILLS ADD (
  CHECK ("VES" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.R3_BILLS ADD (
  CONSTRAINT R3_BILLS_PK
  PRIMARY KEY
  (VBELN)
  USING INDEX MASTER.R3_BILLS_PK
  ENABLE VALIDATE);

ALTER TABLE MASTER.R3_BILLS ADD (
  CONSTRAINT R3_BILLS_UK
  UNIQUE (NOM_DOK)
  DISABLE NOVALIDATE);
