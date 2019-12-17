/* This object may not be sorted properly in the script due to cirular references. */
--
-- PK_R3_VAGOWNER  (Index) 
--
CREATE UNIQUE INDEX MASTER.PK_R3_VAGOWNER ON MASTER.R3_VAGOWNER
(R3_VENDORS_ID, VAGOWNER_ID)
TABLESPACE USERSINDX;


