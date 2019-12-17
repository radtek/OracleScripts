/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_OSS_OSS2_UK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_OSS_OSS2_UK ON MASTER.EUL_SEGMENTS
(OSS_SUMO_ID, OSS_SEG_TYPE, OSS_SEQUENCE, OSS_OBJ_ID, OSS_CUO_ID, 
OSS_BQ_ID, OSS_EXP_ID)
TABLESPACE USERSINDX;


