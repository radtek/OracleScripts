/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_IT_FUN_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_IT_FUN_FK_I ON MASTER.EUL_EXPRESSIONS
(IT_FUN_ID)
TABLESPACE USERSINDX;


