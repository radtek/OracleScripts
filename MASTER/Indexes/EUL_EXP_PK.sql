/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_EXP_PK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_EXP_PK ON MASTER.EUL_EXPRESSIONS
(EXP_ID)
TABLESPACE USERSINDX;


