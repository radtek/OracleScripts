/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_NJP_EU_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_NJP_EU_FK_I ON MASTER.EUL_EXPRESSIONS
(NJP_EU_ID)
TABLESPACE USERSINDX;


