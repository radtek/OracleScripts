/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SIU_SUMO_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_SIU_SUMO_FK_I ON MASTER.EUL_SUMO_ITEM_USGS
(SIU_SUMO_ID)
TABLESPACE USERSINDX;


