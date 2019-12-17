/* This object may not be sorted properly in the script due to cirular references. */
--
-- OD_PK  (Index) 
--
CREATE UNIQUE INDEX MASTER.OD_PK ON MASTER.R3_OD
(VBAK_VBELN, VBAP_POSNR)
TABLESPACE USERSINDX;


