/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_CID_IT_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_CID_IT_FK_I ON MASTER.EUL_EXP_DEPS
(CID_EXP_ID)
TABLESPACE USERSINDX;


