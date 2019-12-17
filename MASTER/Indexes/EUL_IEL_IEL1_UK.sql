/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_IEL_IEL1_UK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_IEL_IEL1_UK ON MASTER.EUL_IG_EXP_LINKS
(KIL_EXP_ID, KIL_KEY_ID, HIL_EXP_ID, HIL_HN_ID)
TABLESPACE USERSINDX;


