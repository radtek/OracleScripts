/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SIU_SIU1_UK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_SIU_SIU1_UK ON MASTER.EUL_SUMO_ITEM_USGS
(SIU_TYPE, SIU_SUMO_ID, SIU_EXP_ID, SMIU_FUN_ID, SMIU_MEASURE_SET)
TABLESPACE USERSINDX;


