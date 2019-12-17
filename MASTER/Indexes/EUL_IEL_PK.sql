/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_IEL_PK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_IEL_PK ON MASTER.EUL_IG_EXP_LINKS
(IEL_ID)
TABLESPACE USERSINDX;


