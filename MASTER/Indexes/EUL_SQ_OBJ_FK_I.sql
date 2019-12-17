/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SQ_OBJ_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_SQ_OBJ_FK_I ON MASTER.EUL_SUB_QUERIES
(SQ_OBJ_ID)
TABLESPACE USERSINDX;


