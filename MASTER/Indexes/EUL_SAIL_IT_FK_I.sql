/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SAIL_IT_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_SAIL_IT_FK_I ON MASTER.EUL_SBO_DSGN_ELEMS
(SAIL_EXP_ID)
TABLESPACE USERSINDX;


