/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SDE_SBO_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_SDE_SBO_FK_I ON MASTER.EUL_SBO_DSGN_ELEMS
(SDE_SUMO_ID)
TABLESPACE USERSINDX;


