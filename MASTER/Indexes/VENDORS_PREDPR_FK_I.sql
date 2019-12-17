/* This object may not be sorted properly in the script due to cirular references. */
--
-- VENDORS_PREDPR_FK_I  (Index) 
--
CREATE INDEX MASTER.VENDORS_PREDPR_FK_I ON MASTER.R3_VENDORS
(PREDPR_ID)
TABLESPACE USERSINDX;


