--
-- DOVER_DATE_NUM_PREDPR  (Index) 
--
CREATE UNIQUE INDEX MASTER.DOVER_DATE_NUM_PREDPR ON MASTER.KLS_DOVER
(DATE_DOVER, NUM_DOVER, PREDPR_ID)
TABLESPACE USERSINDX;

