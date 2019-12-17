/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_PSD_SQ_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_PSD_SQ_FK_I ON MASTER.EUL_EXP_DEPS
(PSD_SQ_ID)
TABLESPACE USERSINDX;


