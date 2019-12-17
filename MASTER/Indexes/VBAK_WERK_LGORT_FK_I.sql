/* This object may not be sorted properly in the script due to cirular references. */
--
-- VBAK_WERK_LGORT_FK_I  (Index) 
--
CREATE INDEX MASTER.VBAK_WERK_LGORT_FK_I ON MASTER.R3_VBAK
(VBAP_WERKS, LGORT)
TABLESPACE USERSINDX;


