/* This object may not be sorted properly in the script due to cirular references. */
--
-- OA_OD_FK_I  (Index) 
--
CREATE INDEX MASTER.OA_OD_FK_I ON MASTER.R3_OA
(VBAK_VBELN, VBAP_POSNR)
TABLESPACE USERSINDX;


