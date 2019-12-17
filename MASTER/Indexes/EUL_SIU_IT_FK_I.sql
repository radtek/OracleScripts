/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SIU_IT_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_SIU_IT_FK_I ON MASTER.EUL_SUMO_ITEM_USGS
(SIU_EXP_ID)
TABLESPACE USERSINDX;


