-- 
-- Non Foreign Key Constraints for Table NPR_PRICES 
-- 
ALTER TABLE MASTER.NPR_PRICES ADD (
  CHECK ("CAT_CEN_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES ADD (
  CHECK ("PROD_ID_NPR" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES ADD (
  CHECK ("CENA" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES ADD (
  CHECK ("NDS20" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES ADD (
  CHECK ("NGSM25" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES ADD (
  CHECK ("AKCIZ" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES ADD (
  CHECK ("CENA_OTP" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES ADD (
  CHECK ("BEGIN_DATE" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES ADD (
  CHECK ("INPUT_DATE" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES ADD (
  CHECK ("OWNERSHIP_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES ADD (
  CHECK ("SUPPLIER_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES ADD (
  CHECK ("IS_ORIGINAL" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES ADD (
  CONSTRAINT NPR_PRICES_PK
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.NPR_PRICES_PK
  ENABLE VALIDATE);

