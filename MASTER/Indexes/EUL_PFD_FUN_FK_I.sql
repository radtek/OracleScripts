/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_PFD_FUN_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_PFD_FUN_FK_I ON MASTER.EUL_EXP_DEPS
(PFD_FUN_ID)
TABLESPACE USERSINDX;


