/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SMIU_FUN_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_SMIU_FUN_FK_I ON MASTER.EUL_SUMO_ITEM_USGS
(SMIU_FUN_ID)
TABLESPACE USERSINDX;


