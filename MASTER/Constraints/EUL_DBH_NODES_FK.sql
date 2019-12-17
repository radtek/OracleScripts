-- 
-- Foreign Key Constraints for Table EUL_DBH_NODES 
-- 
ALTER TABLE MASTER.EUL_DBH_NODES ADD (
  CONSTRAINT EUL_DHN_DBH_FK 
  FOREIGN KEY (DHN_HI_ID) 
  REFERENCES MASTER.EUL_HIERARCHIES (HI_ID)
  ENABLE NOVALIDATE);

