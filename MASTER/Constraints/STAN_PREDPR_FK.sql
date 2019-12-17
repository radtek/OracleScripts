-- 
-- Foreign Key Constraints for Table STAN_PREDPR 
-- 
ALTER TABLE MASTER.STAN_PREDPR ADD (
  CONSTRAINT STAN_PRED_PREDPR_FK 
  FOREIGN KEY (PREDPR_ID) 
  REFERENCES MASTER.KLS_PREDPR (ID)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.STAN_PREDPR ADD (
  CONSTRAINT STAN_PRED_STAN_FK 
  FOREIGN KEY (STAN_ID) 
  REFERENCES MASTER.KLS_STAN (ID)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.STAN_PREDPR ADD (
  CONSTRAINT STAN_PRED_VETKA_FK 
  FOREIGN KEY (VETKA_ID) 
  REFERENCES MASTER.KLS_VETKA (ID)
  ENABLE NOVALIDATE);
