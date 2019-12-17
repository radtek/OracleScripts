-- 
-- Non Foreign Key Constraints for Table PAYMENTS_TO_BILLS 
-- 
ALTER TABLE MASTER.PAYMENTS_TO_BILLS ADD (
  CONSTRAINT PK_PAYMENTS_TO_BILLS
  PRIMARY KEY
  (PAYMENTS_ID, NOM_DOK)
  USING INDEX MASTER.PK_PAYMENTS_TO_BILLS
  ENABLE VALIDATE);

