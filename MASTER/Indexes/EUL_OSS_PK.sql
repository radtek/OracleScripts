/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_OSS_PK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_OSS_PK ON MASTER.EUL_SEGMENTS
(OSS_ID)
TABLESPACE USERSINDX;


