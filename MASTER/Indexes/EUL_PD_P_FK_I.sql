/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_PD_P_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_PD_P_FK_I ON MASTER.EUL_EXP_DEPS
(PD_P_ID)
TABLESPACE USERSINDX;


