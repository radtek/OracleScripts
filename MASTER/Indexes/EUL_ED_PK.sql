/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_ED_PK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_ED_PK ON MASTER.EUL_EXP_DEPS
(ED_ID)
TABLESPACE USERSINDX;


