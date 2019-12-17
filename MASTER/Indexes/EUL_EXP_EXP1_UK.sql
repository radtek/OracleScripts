/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_EXP_EXP1_UK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_EXP_EXP1_UK ON MASTER.EUL_EXPRESSIONS
(ITE_EU_ID, NJP_EU_ID, JP_KEY_ID, NJP_OBJ_ID_OWNER, ITE_OBJ_ID, 
EXP_NAME)
TABLESPACE USERSINDX;


