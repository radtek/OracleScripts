/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_CD_CI_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_CD_CI_FK_I ON MASTER.EUL_EXP_DEPS
(CD_EXP_ID)
TABLESPACE USERSINDX;


