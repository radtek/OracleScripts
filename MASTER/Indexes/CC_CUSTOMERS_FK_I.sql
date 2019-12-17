/* This object may not be sorted properly in the script due to cirular references. */
--
-- CC_CUSTOMERS_FK_I  (Index) 
--
CREATE INDEX MASTER.CC_CUSTOMERS_FK_I ON MASTER.R3_CC
(CUSTOMERS_ID)
TABLESPACE USERSINDX;


