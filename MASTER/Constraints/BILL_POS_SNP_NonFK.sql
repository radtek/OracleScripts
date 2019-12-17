-- 
-- Non Foreign Key Constraints for Table BILL_POS_SNP 
-- 
ALTER TABLE MASTER.BILL_POS_SNP ADD (
  CHECK ("VES" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.BILL_POS_SNP ADD (
  CHECK ("KVIT_VES" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.BILL_POS_SNP ADD (
  CHECK ("CENA_BN" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.BILL_POS_SNP ADD (
  CHECK ("CENA" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.BILL_POS_SNP ADD (
  CHECK ("SUMMA_BN" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.BILL_POS_SNP ADD (
  CHECK ("SUMMA_AKCIZ" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.BILL_POS_SNP ADD (
  CHECK ("SUMMA_NDS20" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.BILL_POS_SNP ADD (
  CHECK ("SUMMA_GSM25" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.BILL_POS_SNP ADD (
  CHECK ("SUMMA" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.BILL_POS_SNP ADD (
  CHECK ("CENA_POKUP" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.BILL_POS_SNP ADD (
  CHECK ("SUMMA_BN_POKUP" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.BILL_POS_SNP ADD (
  CHECK ("SUMMA_NDS20_POKUP" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.BILL_POS_SNP ADD (
  CHECK ("SUMMA_GSM25_POKUP" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.BILL_POS_SNP ADD (
  CHECK ("DATE_REALIZ" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.BILL_POS_SNP ADD (
  CHECK ("OWNERSHIP_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.BILL_POS_SNP ADD (
  CHECK ("IS_AGENT" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.BILL_POS_SNP ADD (
  CONSTRAINT BILL_POS_SNP_PK
  PRIMARY KEY
  (NOM_DOK, BILL_POS_SNP_ID)
  USING INDEX MASTER.BILL_POS_SNP_PK
  ENABLE VALIDATE);

