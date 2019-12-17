/* This object may not be sorted properly in the script due to cirular references. */
--
-- VBAK_MATERIALS_FK_I  (Index) 
--
CREATE INDEX MASTER.VBAK_MATERIALS_FK_I ON MASTER.R3_VBAK
(VBAP_MATNR)
TABLESPACE USERSINDX;


