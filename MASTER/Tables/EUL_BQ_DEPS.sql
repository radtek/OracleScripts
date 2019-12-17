/* This object may not be sorted properly in the script due to cirular references. */
--
-- EUL_BQ_DEPS  (Table) 
--
CREATE TABLE MASTER.EUL_BQ_DEPS
(
  BQD_ID        NUMBER(10)                      NOT NULL,
  BQD_TYPE      VARCHAR2(10 BYTE),
  BQD_BQ_ID     NUMBER(10),
  BFILD_FIL_ID  NUMBER(10),
  BID_IT_ID     NUMBER(10),
  BFUND_FUN_ID  NUMBER(10),
  NOTM          NUMBER(10)
)
TABLESPACE USERS2
NOCOMPRESS ;


