/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_CFD_FUN_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_CFD_FUN_FK_I ON MASTER.EUL_EXP_DEPS
(CFD_FUN_ID)
TABLESPACE USERSINDX;


