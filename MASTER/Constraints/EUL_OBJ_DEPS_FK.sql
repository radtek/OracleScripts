-- 
-- Foreign Key Constraints for Table EUL_OBJ_DEPS 
-- 
ALTER TABLE MASTER.EUL_OBJ_DEPS ADD (
  CONSTRAINT EUL_OD_COBJ_FK 
  FOREIGN KEY (OD_OBJ_ID_FROM) 
  REFERENCES MASTER.EUL_OBJS (OBJ_ID)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.EUL_OBJ_DEPS ADD (
  CONSTRAINT EUL_OD_OBJ_FK 
  FOREIGN KEY (OD_OBJ_ID_TO) 
  REFERENCES MASTER.EUL_OBJS (OBJ_ID)
  ENABLE NOVALIDATE);

