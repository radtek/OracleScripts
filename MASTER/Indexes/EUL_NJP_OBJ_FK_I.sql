/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_NJP_OBJ_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_NJP_OBJ_FK_I ON MASTER.EUL_EXPRESSIONS
(NJP_OBJ_ID_OWNER)
TABLESPACE USERSINDX;


