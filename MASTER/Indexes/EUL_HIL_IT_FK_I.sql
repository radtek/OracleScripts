/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_HIL_IT_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_HIL_IT_FK_I ON MASTER.EUL_IG_EXP_LINKS
(HIL_EXP_ID)
TABLESPACE USERSINDX;


