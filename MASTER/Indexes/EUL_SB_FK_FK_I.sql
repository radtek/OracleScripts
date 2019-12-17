/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_SB_FK_FK_I  (Index) 
--
CREATE INDEX MASTER.EUL_SB_FK_FK_I ON MASTER.EUL_SUM_BITMAPS
(SB_KEY_ID)
TABLESPACE USERSINDX;


