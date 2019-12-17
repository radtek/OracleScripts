/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_DOM_IT_R_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_DOM_IT_R_FK_I ON MASTER.EUL_DOMAINS
(DOM_IT_ID_RANK)
TABLESPACE USERSINDX;


