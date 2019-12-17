/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_PED_EXP_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_PED_EXP_FK_I ON MASTER.EUL_EXP_DEPS
(PED_EXP_ID)
TABLESPACE USERSINDX;


