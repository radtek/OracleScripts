/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_ITE_OBJ_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_ITE_OBJ_FK_I ON MASTER.EUL_EXPRESSIONS
(ITE_OBJ_ID)
TABLESPACE USERSINDX;


