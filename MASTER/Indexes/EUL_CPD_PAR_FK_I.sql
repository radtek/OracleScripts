/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_CPD_PAR_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_CPD_PAR_FK_I ON MASTER.EUL_EXP_DEPS
(CPD_EXP_ID)
TABLESPACE USERSINDX;


