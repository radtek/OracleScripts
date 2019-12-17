/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_DOM_PK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_DOM_PK ON MASTER.EUL_DOMAINS
(DOM_ID)
TABLESPACE USERSINDX;


