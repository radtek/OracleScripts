/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_OSS_CUO_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_OSS_CUO_FK_I ON MASTER.EUL_SEGMENTS
(OSS_CUO_ID)
TABLESPACE USERSINDX;


