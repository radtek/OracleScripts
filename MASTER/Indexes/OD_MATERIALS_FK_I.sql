/* This object may not be sorted properly in the script due to cirular references. */
--
-- OD_MATERIALS_FK_I  (Index) 
--
CREATE INDEX MASTER.OD_MATERIALS_FK_I ON MASTER.R3_OD
(VBAP_MATNR)
TABLESPACE USERSINDX;


