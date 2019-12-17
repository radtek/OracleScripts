/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SDE_SDE1_UK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_SDE_SDE1_UK ON MASTER.EUL_SBO_DSGN_ELEMS
(SDE_SUMO_ID, SAIL_EXP_ID, SMIL_EXP_ID, SMIL_FUN_ID)
TABLESPACE USERSINDX;


