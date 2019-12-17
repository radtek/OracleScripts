/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_HIL_HN_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_HIL_HN_FK_I ON MASTER.EUL_IG_EXP_LINKS
(HIL_HN_ID)
TABLESPACE USERSINDX;


