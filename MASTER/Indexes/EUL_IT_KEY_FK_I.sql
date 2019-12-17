/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_IT_KEY_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_IT_KEY_FK_I ON MASTER.EUL_EXPRESSIONS
(IT_KEY_ID_DESC_FOR)
TABLESPACE USERSINDX;


