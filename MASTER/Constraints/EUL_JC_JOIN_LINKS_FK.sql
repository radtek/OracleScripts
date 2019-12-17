-- 
-- Foreign Key Constraints for Table EUL_JC_JOIN_LINKS 
-- 
ALTER TABLE MASTER.EUL_JC_JOIN_LINKS ADD (
  CONSTRAINT EUL_JJL_FK_FK 
  FOREIGN KEY (JJL_KEY_ID) 
  REFERENCES MASTER.EUL_KEY_CONS (KEY_ID)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_JC_JOIN_LINKS ADD (
  CONSTRAINT EUL_JJL_JC_FK 
  FOREIGN KEY (JJL_JC_ID) 
  REFERENCES MASTER.EUL_JOIN_COMBS (JC_ID)
  ENABLE NOVALIDATE);
