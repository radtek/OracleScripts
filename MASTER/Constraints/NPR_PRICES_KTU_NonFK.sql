-- 
-- Non Foreign Key Constraints for Table NPR_PRICES_KTU 
-- 
ALTER TABLE MASTER.NPR_PRICES_KTU ADD (
  CHECK ("CAT_CEN_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES_KTU ADD (
  CHECK ("PROD_ID_NPR" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES_KTU ADD (
  CHECK ("CENA" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES_KTU ADD (
  CHECK ("NDS20" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES_KTU ADD (
  CHECK ("NGSM25" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES_KTU ADD (
  CHECK ("AKCIZ" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES_KTU ADD (
  CHECK ("CENA_OTP" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES_KTU ADD (
  CHECK ("BEGIN_DATE" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES_KTU ADD (
  CHECK ("INPUT_DATE" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES_KTU ADD (
  CHECK ("OWNERSHIP_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES_KTU ADD (
  CHECK ("SUPPLIER_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES_KTU ADD (
  CHECK ("IS_ORIGINAL" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.NPR_PRICES_KTU ADD (
  CONSTRAINT NPR_PRICES_KTU_PK
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.NPR_PRICES_KTU_PK
  ENABLE VALIDATE);

