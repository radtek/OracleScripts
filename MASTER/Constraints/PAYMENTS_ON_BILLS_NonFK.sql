-- 
-- Non Foreign Key Constraints for Table PAYMENTS_ON_BILLS 
-- 
ALTER TABLE MASTER.PAYMENTS_ON_BILLS ADD (
  CHECK ("NOM_DOK" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PAYMENTS_ON_BILLS ADD (
  CHECK ("BILL_POS_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PAYMENTS_ON_BILLS ADD (
  CHECK ("PAYMENTS_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PAYMENTS_ON_BILLS ADD (
  CHECK ("SUMMA" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PAYMENTS_ON_BILLS ADD (
  CHECK ("DATE_REALIZ" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.PAYMENTS_ON_BILLS ADD (
  CONSTRAINT PK_PAYMENTS_ON_BILLS
  PRIMARY KEY
  (ID)
  USING INDEX MASTER.PK_PAYMENTS_ON_BILLS
  ENABLE VALIDATE);

