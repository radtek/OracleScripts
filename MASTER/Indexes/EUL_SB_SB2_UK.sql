/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SB_SB2_UK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_SB_SB2_UK ON MASTER.EUL_SUM_BITMAPS
(SB_EXP_ID, SB_KEY_ID, SB_FUN_ID, SB_SEQUENCE)
TABLESPACE USERSINDX;


