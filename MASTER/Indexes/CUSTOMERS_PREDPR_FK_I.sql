/* This object may not be sorted properly in the script due to cirular references. */
--
-- CUSTOMERS_PREDPR_FK_I  (Index) 
--
CREATE INDEX MASTER.CUSTOMERS_PREDPR_FK_I ON MASTER.R3_CUSTOMERS
(PREDPR_ID)
TABLESPACE USERSINDX;


