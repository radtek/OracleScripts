/* This object may not be sorted properly in the script due to cirular references. */
--
-- KONV_SC_FK_I  (Index) 
--
CREATE INDEX MASTER.KONV_SC_FK_I ON MASTER.R3_KONV
(MATCH_ASNUM)
TABLESPACE USERSINDX;


