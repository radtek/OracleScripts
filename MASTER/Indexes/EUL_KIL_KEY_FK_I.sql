/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_KIL_KEY_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_KIL_KEY_FK_I ON MASTER.EUL_IG_EXP_LINKS
(KIL_KEY_ID)
TABLESPACE USERSINDX;


