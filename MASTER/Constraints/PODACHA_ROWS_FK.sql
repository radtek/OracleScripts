-- 
-- Foreign Key Constraints for Table PODACHA_ROWS 
-- 
ALTER TABLE MASTER.PODACHA_ROWS ADD (
  CONSTRAINT PODACHA_ROW_PROD_FK 
  FOREIGN KEY (PROD_ID_NPR) 
  REFERENCES MASTER.KLS_PROD (ID_NPR)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.PODACHA_ROWS ADD (
  CONSTRAINT PODACHA_ROWS_PODACHA_FK 
  FOREIGN KEY (PODACHA_ID) 
  REFERENCES MASTER.PODACHA (ID)
  ON DELETE CASCADE
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.PODACHA_ROWS ADD (
  CONSTRAINT PODACHA_ROWS_VAGOWNER_FK 
  FOREIGN KEY (VAGOWNER_ID) 
  REFERENCES MASTER.KLS_VAGOWNER (ID)
  ENABLE NOVALIDATE);

