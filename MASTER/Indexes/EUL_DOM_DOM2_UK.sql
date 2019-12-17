/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_DOM_DOM2_UK  (Index) 
--
CREATE UNIQUE INDEX MASTER.EUL_DOM_DOM2_UK ON MASTER.EUL_DOMAINS
(DOM_NAME)
TABLESPACE USERSINDX;


