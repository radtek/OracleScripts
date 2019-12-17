-- 
-- Non Foreign Key Constraints for Table EUL_HI_NODES 
-- 
ALTER TABLE MASTER.EUL_HI_NODES ADD (
  CHECK ("HN_NAME" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_HI_NODES ADD (
  CHECK ("HN_HI_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_HI_NODES ADD (
  CONSTRAINT EUL_HN_PK
  PRIMARY KEY
  (HN_ID)
  USING INDEX MASTER.EUL_HN_PK
  ENABLE VALIDATE);

ALTER TABLE MASTER.EUL_HI_NODES ADD (
  CONSTRAINT EUL_HN_HN2_UK
  UNIQUE (HN_HI_ID, HN_NAME)
  USING INDEX MASTER.EUL_HN_HN2_UK
  ENABLE VALIDATE);

