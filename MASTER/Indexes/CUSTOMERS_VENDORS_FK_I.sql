/* This object may not be sorted properly in the script due to cirular references. */
--
-- CUSTOMERS_VENDORS_FK_I  (Index) 
--
CREATE INDEX MASTER.CUSTOMERS_VENDORS_FK_I ON MASTER.R3_CUSTOMERS
(VENDORS_ID)
TABLESPACE USERSINDX;


