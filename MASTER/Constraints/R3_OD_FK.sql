-- 
-- Foreign Key Constraints for Table R3_OD 
-- 
ALTER TABLE MASTER.R3_OD ADD (
  CONSTRAINT OD_BLOCKS_FK 
  FOREIGN KEY (V_TJ30_TXT04) 
  REFERENCES MASTER.R3_BLOCKS (V_TJ30_TXT04)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.R3_OD ADD (
  CONSTRAINT OD_LPRIO_FK 
  FOREIGN KEY (VBAP_LPRIO) 
  REFERENCES MASTER.R3_LPRIO (VBAP_LPRIO)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.R3_OD ADD (
  CONSTRAINT OD_MATERIALS_FK 
  FOREIGN KEY (VBAP_MATNR) 
  REFERENCES MASTER.R3_MATERIALS (VBAP_MATNR)
  ENABLE NOVALIDATE);

ALTER TABLE MASTER.R3_OD ADD (
  CONSTRAINT OD_VBAK_FK 
  FOREIGN KEY (VBAK_VBELN) 
  REFERENCES MASTER.R3_VBAK (VBELN)
  ENABLE NOVALIDATE);

