--
-- REPORTS_NUM_REP_UK  (Index) 
--
CREATE UNIQUE INDEX MASTER.REPORTS_NUM_REP_UK ON MASTER.REPORTS_NUM_REP
(REP_ID, BEGIN_DATE, END_DATE, IS_CRT)
TABLESPACE USERSINDX;


