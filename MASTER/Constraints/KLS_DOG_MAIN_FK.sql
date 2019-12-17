-- 
-- Foreign Key Constraints for Table KLS_DOG_MAIN 
-- 
ALTER TABLE MASTER.KLS_DOG_MAIN ADD (
  CONSTRAINT KLS_DOG_MAIN_DOG_FK 
  FOREIGN KEY (DOG_ID) 
  REFERENCES MASTER.KLS_DOG (ID)
  ENABLE NOVALIDATE);

