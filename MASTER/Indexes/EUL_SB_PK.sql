/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SB_PK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_SB_PK ON MASTER.EUL_SUM_BITMAPS
(SB_ID)
TABLESPACE USERSINDX;


