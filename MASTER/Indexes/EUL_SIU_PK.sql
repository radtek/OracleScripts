/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SIU_PK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_SIU_PK ON MASTER.EUL_SUMO_ITEM_USGS
(SIU_ID)
TABLESPACE USERSINDX;


