/* This object may not be sorted properly in the script due to cirular references. */
--
-- VENDORS_CUSTOMERS_FK_I  (Index) 
--
CREATE INDEX MASTER.VENDORS_CUSTOMERS_FK_I ON MASTER.R3_VENDORS
(CUSTOMERS_ID)
TABLESPACE USERSINDX;


