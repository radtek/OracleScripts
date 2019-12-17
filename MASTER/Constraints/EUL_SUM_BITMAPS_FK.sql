-- 
-- Foreign Key Constraints for Table EUL_SUM_BITMAPS 
-- 
ALTER TABLE MASTER.EUL_SUM_BITMAPS ADD (
  CONSTRAINT EUL_SB_FK_FK 
  FOREIGN KEY (SB_KEY_ID) 
  REFERENCES MASTER.EUL_KEY_CONS (KEY_ID)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_SUM_BITMAPS ADD (
  CONSTRAINT EUL_SB_FUN_FK 
  FOREIGN KEY (SB_FUN_ID) 
  REFERENCES MASTER.EUL_FUNCTIONS (FUN_ID)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_SUM_BITMAPS ADD (
  CONSTRAINT EUL_SB_IT_FK 
  FOREIGN KEY (SB_EXP_ID) 
  REFERENCES MASTER.EUL_EXPRESSIONS (EXP_ID)
  ENABLE NOVALIDATE);

