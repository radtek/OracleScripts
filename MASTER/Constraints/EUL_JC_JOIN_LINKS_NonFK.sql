-- 
-- Non Foreign Key Constraints for Table EUL_JC_JOIN_LINKS 
-- 
ALTER TABLE MASTER.EUL_JC_JOIN_LINKS ADD (
  CHECK ("JJL_JC_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_JC_JOIN_LINKS ADD (
  CHECK ("JJL_KEY_ID" IS NOT NULL)
  DISABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_JC_JOIN_LINKS ADD (
  CONSTRAINT EUL_JJL_PK
  PRIMARY KEY
  (JJL_ID)
  USING INDEX MASTER.EUL_JJL_PK
  ENABLE VALIDATE);

ALTER TABLE MASTER.EUL_JC_JOIN_LINKS ADD (
  CONSTRAINT EUL_JJL_JJL1_UK
  UNIQUE (JJL_KEY_ID, JJL_JC_ID)
  USING INDEX MASTER.EUL_JJL_JJL1_UK
  ENABLE VALIDATE);

