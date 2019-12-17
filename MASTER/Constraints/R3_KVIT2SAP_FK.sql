-- 
-- Foreign Key Constraints for Table R3_KVIT2SAP 
-- 
ALTER TABLE MASTER.R3_KVIT2SAP ADD (
  CONSTRAINT KVIT2SAP_LOAD_TYPE_FK 
  FOREIGN KEY (LOAD_TYPE_ID) 
  REFERENCES MASTER.KLS_LOAD_TYPE (ID)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.R3_KVIT2SAP ADD (
  CONSTRAINT KVIT2SAP_MONTH_FK 
  FOREIGN KEY (NOM_ZD) 
  REFERENCES MASTER.MONTH (NOM_ZD)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.R3_KVIT2SAP ADD (
  CONSTRAINT KVIT2SAP_OD_FK 
  FOREIGN KEY (VBAK_VBELN, VBAP_POSNR) 
  REFERENCES MASTER.R3_OD (VBAK_VBELN,VBAP_POSNR)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.R3_KVIT2SAP ADD (
  CONSTRAINT KVIT2SAP_PROD_FK 
  FOREIGN KEY (PROD_ID_NPR) 
  REFERENCES MASTER.KLS_PROD (ID_NPR)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.R3_KVIT2SAP ADD (
  CONSTRAINT KVIT2SAP_VSTEL_FK 
  FOREIGN KEY (VSTEL) 
  REFERENCES MASTER.R3_VSTEL (VBAP_VSTEL)
  ENABLE NOVALIDATE);
